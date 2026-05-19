import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../data/auth_api.dart';
import '../data/diary_api.dart';
import '../data/foundation_api.dart';

class AppState extends ChangeNotifier {
  // ── USER ──
  String _userName = '';
  String _firstName = '';
  String _lastName = '';
  String _userEmail = '';
  String _planKey = '';
  String _planName = '';
  String _planPriceLabel = '';
  String _profileType = ''; // ANXIETY | BURNOUT | OVERWHELM
  String _authToken = '';
  bool _rememberSession = false;
  String _rememberedLoginEmail = '';
  String _rememberedLoginPassword = '';
  final FoundationApi _foundationApi = FoundationApi();
  final DiaryApi _diaryApi = DiaryApi();
  final Map<String, String> _onboardingAnswers = {};

  // ── FOUNDATION ──
  Map<String, int> _lifeScores = {};
  Map<String, String> _lifeNotes = {};
  List<int> _selectedBeliefs = [];
  List<Map<String, dynamic>> _timeline = [];
  List<String> _selectedTriggers = [];
  List<bool> _foundationCompleted = [false, false, false, false];

  // ── TOOLS ──
  List<int> _completedTools = [];
  int _currentTool = 1;

  // ── DIARY ──
  List<Map<String, dynamic>> _diaryEntries = [];

  // ── ENQUIRY LOG ──
  List<Map<String, dynamic>> _enquiryLog = [];

  // ── GETTERS ──
  String get userName => _userName;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get userEmail => _userEmail;
  String get planKey => _planKey;
  String get planName => _planName;
  String get planPriceLabel => _planPriceLabel;
  String get profileType => _profileType;
  String get authToken => _authToken;
  bool get rememberSession => _rememberSession;
  String get rememberedLoginEmail => _rememberedLoginEmail;
  String get rememberedLoginPassword => _rememberedLoginPassword;
  bool get isAuthenticated => _authToken.isNotEmpty;
  Map<String, String> get onboardingAnswers => _onboardingAnswers;
  Map<String, int> get lifeScores => _lifeScores;
  Map<String, String> get lifeNotes => _lifeNotes;
  List<int> get selectedBeliefs => _selectedBeliefs;
  List<Map<String, dynamic>> get timeline => _timeline;
  List<String> get selectedTriggers => _selectedTriggers;
  List<bool> get foundationCompleted => _foundationCompleted;
  List<int> get completedTools => _completedTools;
  int get currentTool => _currentTool;
  List<Map<String, dynamic>> get diaryEntries => _diaryEntries;
  List<Map<String, dynamic>> get enquiryLog => _enquiryLog;

  bool get foundationComplete => _foundationCompleted.every((c) => c);
  int get foundationProgress => _foundationCompleted.where((c) => c).length;

  // ── ONBOARDING ──
  void setUserName(String name) {
    _userName = name;
    _save();
    notifyListeners();
  }

  Future<void> signIn(
    AuthResponse response, {
    required bool rememberSession,
    required String loginEmail,
    required String loginPassword,
  }) async {
    _firstName = response.firstName.trim();
    _lastName = response.lastName.trim();
    final fallbackName = '${_firstName.isNotEmpty ? _firstName : ''} ${_lastName.isNotEmpty ? _lastName : ''}'.trim();
    _userName = response.userName.isNotEmpty
        ? response.userName
        : fallbackName.isNotEmpty
            ? fallbackName
            : response.email;
    _userEmail = response.email;
    _planKey = response.planKey.isNotEmpty ? response.planKey : 'standard';
    _planName = response.planName;
    _planPriceLabel = response.planPriceLabel;
    _authToken = response.token;
    _rememberSession = rememberSession;
    _rememberedLoginEmail = rememberSession ? loginEmail.trim() : '';
    _rememberedLoginPassword = rememberSession ? loginPassword : '';
    await _save();
    await _loadFoundationFromApi();
    await _loadDiaryFromApi();
    await _loadDiaryFromApi();
    notifyListeners();
  }

  Future<void> signOut() async {
    _userName = '';
    _firstName = '';
    _lastName = '';
    _userEmail = '';
    _planKey = '';
    _planName = '';
    _planPriceLabel = '';
    _authToken = '';
    _diaryEntries = [];
    await _save();
    notifyListeners();
  }

  void setProfile(String type) {
    _profileType = type;
    _save();
    notifyListeners();
  }

  void setAnswer(String key, String val) {
    _onboardingAnswers[key] = val;
    notifyListeners();
  }

  // ── FOUNDATION ──
  void setLifeScore(String area, int score) {
    _lifeScores[area] = score;
    _save();
    notifyListeners();
    unawaited(_persistFoundationState());
  }

  void setLifeNote(String area, String note) {
    _lifeNotes[area] = note;
    _save();
    notifyListeners();
    unawaited(_persistFoundationState());
  }

  bool get step1Valid => lifeScores.length >= 6 && lifeScores.values.every((s) => s > 0);

  void toggleBelief(int index) {
    if (_selectedBeliefs.contains(index)) {
      _selectedBeliefs.remove(index);
    } else {
      _selectedBeliefs.add(index);
    }
    _save();
    notifyListeners();
    unawaited(_persistFoundationState());
  }

  bool get step2Valid => _selectedBeliefs.isNotEmpty;

  void addTimelineEvent(Map<String, dynamic> event) {
    _timeline.add(event);
    _save();
    notifyListeners();
    unawaited(_persistFoundationState());
  }

  void updateTimelineEvent(int index, Map<String, dynamic> event) {
    if (index < _timeline.length) {
      _timeline[index] = event;
      _save();
      notifyListeners();
      unawaited(_persistFoundationState());
    }
  }

  void removeTimelineEvent(int index) {
    if (index < _timeline.length) {
      _timeline.removeAt(index);
      _save();
      notifyListeners();
      unawaited(_persistFoundationState());
    }
  }

  bool get step3Valid {
    final valid = _timeline.where((e) {
      final year = '${e['year'] ?? ''}'.trim();
      final event = '${e['event'] ?? ''}'.trim();
      return year.isNotEmpty && event.length > 2;
    }).length;
    return valid >= 3;
  }

  void toggleTrigger(String key) {
    if (_selectedTriggers.contains(key)) {
      _selectedTriggers.remove(key);
    } else {
      _selectedTriggers.add(key);
    }
    _save();
    notifyListeners();
    unawaited(_persistFoundationState());
  }

  bool get step4Valid => _selectedTriggers.isNotEmpty;

  void completeFoundationStep(int step) {
    // step is 1-indexed
    if (step >= 1 && step <= 4) {
      _foundationCompleted[step - 1] = true;
      _save();
      notifyListeners();
      unawaited(_persistFoundationState());
    }
  }

  FoundationProgress _foundationProgressPayload() => FoundationProgress(
        lifeScores: Map<String, int>.from(_lifeScores),
        lifeNotes: Map<String, String>.from(_lifeNotes),
        selectedBeliefs: List<int>.from(_selectedBeliefs),
        selectedTriggers: List<String>.from(_selectedTriggers),
        foundationCompleted: List<bool>.from(_foundationCompleted),
        timeline: _timeline.map((entry) => Map<String, dynamic>.from(entry)).toList(),
      );

  Future<void> _persistFoundationState() async {
    if (_authToken.isEmpty) return;
    try {
      await _foundationApi.saveProgress(_authToken, _foundationProgressPayload());
    } catch (error) {
      debugPrint('Foundation save failed: $error');
    }
  }

  Future<void> _loadFoundationFromApi() async {
    if (_authToken.isEmpty) return;
    try {
      final progress = await _foundationApi.loadProgress(_authToken);
      _lifeScores = Map<String, int>.from(progress.lifeScores);
      _lifeNotes = Map<String, String>.from(progress.lifeNotes);
      _selectedBeliefs = List<int>.from(progress.selectedBeliefs);
      _selectedTriggers = List<String>.from(progress.selectedTriggers);
      _foundationCompleted = List<bool>.from(progress.foundationCompleted);
      _timeline = progress.timeline
          .map((entry) => Map<String, dynamic>.from(entry))
          .toList();
      await _save();
    } catch (error) {
      debugPrint('Foundation load failed: $error');
    }
  }

  Future<void> _loadDiaryFromApi() async {
    if (_authToken.isEmpty) return;
    try {
      final entries = await _diaryApi.loadEntries(_authToken);
      _diaryEntries = entries;
      await _save();
      notifyListeners();
    } catch (error) {
      debugPrint('Diary load failed: $error');
    }
  }

  Future<void> _persistDiaryEntry(Map<String, dynamic> entry) async {
    if (_authToken.isEmpty) return;
    try {
      final saved = await _diaryApi.saveEntry(_authToken, entry);
      if (saved.isNotEmpty) {
        final index = _diaryEntries.indexWhere((e) => e['ts'] == entry['ts']);
        if (index != -1) {
          final merged = {..._diaryEntries[index], ...saved};
          if (saved['entry_date'] != null) {
            merged['date'] = saved['entry_date'];
          }
          _diaryEntries[index] = merged;
          await _save();
          notifyListeners();
        }
      }
    } catch (error) {
      debugPrint('Diary persist failed: $error');
    }
  }

  // ── TOOLS ──
  void completeTool(int toolNum) {
    if (!_completedTools.contains(toolNum)) {
      _completedTools.add(toolNum);
    }
    _currentTool = toolNum + 1;
    _save();
    notifyListeners();
  }

  bool isToolUnlocked(int toolNum) {
    if (toolNum == 1) return foundationComplete;
    return _completedTools.contains(toolNum - 1);
  }

  // ── DIARY ──
  Future<void> addDiaryEntry(Map<String, dynamic> entry) async {
    _diaryEntries.insert(0, entry);
    await _save();
    notifyListeners();
    await _persistDiaryEntry(entry);
  }

  // ── ENQUIRY ──
  void addEnquiryEntry(Map<String, dynamic> entry) {
    _enquiryLog.insert(0, entry);
    _save();
    notifyListeners();
  }

  // ── PERSISTENCE ──
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _rememberSession = prefs.getBool('rememberSession') ?? false;
    _rememberedLoginEmail = prefs.getString('rememberedLoginEmail') ?? '';
    _rememberedLoginPassword = prefs.getString('rememberedLoginPassword') ?? '';
    _userName = prefs.getString('userName') ?? '';
    _firstName = prefs.getString('firstName') ?? '';
    _lastName = prefs.getString('lastName') ?? '';
    _userEmail = prefs.getString('email') ?? '';
    _authToken = prefs.getString('authToken') ?? '';
    _profileType = prefs.getString('profileType') ?? '';
    _planKey = prefs.getString('planKey') ?? '';
    _planName = prefs.getString('planName') ?? '';
    _planPriceLabel = prefs.getString('planPriceLabel') ?? '';
    _lifeScores = Map<String, int>.from(
      jsonDecode(prefs.getString('lifeScores') ?? '{}'));
    _lifeNotes = Map<String, String>.from(
      jsonDecode(prefs.getString('lifeNotes') ?? '{}'));
    _selectedBeliefs = List<int>.from(
      jsonDecode(prefs.getString('selectedBeliefs') ?? '[]'));
    _timeline = List<Map<String, dynamic>>.from(
      jsonDecode(prefs.getString('timeline') ?? '[]'));
    _selectedTriggers = List<String>.from(
      jsonDecode(prefs.getString('selectedTriggers') ?? '[]'));
    _foundationCompleted = List<bool>.from(
      jsonDecode(prefs.getString('foundationCompleted') ?? '[false,false,false,false]'));
    _completedTools = List<int>.from(
      jsonDecode(prefs.getString('completedTools') ?? '[]'));
    _currentTool = prefs.getInt('currentTool') ?? 1;
    _diaryEntries = List<Map<String, dynamic>>.from(
      jsonDecode(prefs.getString('diaryEntries') ?? '[]'));
    _enquiryLog = List<Map<String, dynamic>>.from(
      jsonDecode(prefs.getString('enquiryLog') ?? '[]'));
    if (!_rememberSession) {
      _rememberedLoginEmail = '';
      _rememberedLoginPassword = '';
      _userName = '';
      _firstName = '';
      _lastName = '';
      _userEmail = '';
      _authToken = '';
      _planKey = '';
      _planName = '';
      _planPriceLabel = '';
    }
    await _loadFoundationFromApi();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberSession', _rememberSession);
    if (_rememberSession) {
      await prefs.setString('rememberedLoginEmail', _rememberedLoginEmail);
      await prefs.setString('rememberedLoginPassword', _rememberedLoginPassword);
    } else {
      await prefs.remove('rememberedLoginEmail');
      await prefs.remove('rememberedLoginPassword');
    }
    if (_rememberSession) {
      await prefs.setString('userName', _userName);
      await prefs.setString('firstName', _firstName);
      await prefs.setString('lastName', _lastName);
      await prefs.setString('email', _userEmail);
      await prefs.setString('authToken', _authToken);
      await prefs.setString('planKey', _planKey);
      await prefs.setString('planName', _planName);
      await prefs.setString('planPriceLabel', _planPriceLabel);
    } else {
      await prefs.remove('userName');
      await prefs.remove('firstName');
      await prefs.remove('lastName');
      await prefs.remove('email');
      await prefs.remove('authToken');
      await prefs.remove('planKey');
      await prefs.remove('planName');
      await prefs.remove('planPriceLabel');
    }
    await prefs.setString('profileType', _profileType);
    await prefs.setString('lifeScores', jsonEncode(_lifeScores));
    await prefs.setString('lifeNotes', jsonEncode(_lifeNotes));
    await prefs.setString('selectedBeliefs', jsonEncode(_selectedBeliefs));
    await prefs.setString('timeline', jsonEncode(_timeline));
    await prefs.setString('selectedTriggers', jsonEncode(_selectedTriggers));
    await prefs.setString('foundationCompleted', jsonEncode(_foundationCompleted));
    await prefs.setString('completedTools', jsonEncode(_completedTools));
    await prefs.setInt('currentTool', _currentTool);
    await prefs.setString('diaryEntries', jsonEncode(_diaryEntries));
    await prefs.setString('enquiryLog', jsonEncode(_enquiryLog));
  }
}
