import 'dart:async';

import 'package:flutter/foundation.dart';

import '../app/constants/app_content.dart';
import '../data/coping_api.dart';
import '../data/foundation_api.dart';
import '../data/snapshot_api.dart';
import '../data/tools_api.dart';
import '../models/app_models.dart';
import '../services/local_storage_service.dart';

class AppController extends ChangeNotifier {
  AppController({
    required LocalStorageService storageService,
    SnapshotApi? snapshotApi,
    CopingApi? copingApi,
    FoundationApi? foundationApi,
    ToolsApi? toolsApi,
  })  : _storageService = storageService,
        _snapshotApi = snapshotApi ?? SnapshotApi(),
        _copingApi = copingApi ?? CopingApi(),
        _foundationApi = foundationApi ?? FoundationApi(),
        _toolsApi = toolsApi ?? ToolsApi();

  final LocalStorageService _storageService;
  final SnapshotApi _snapshotApi;
  final CopingApi _copingApi;
  final FoundationApi _foundationApi;
  final ToolsApi _toolsApi;

  // ── AUTH ──
  String _authToken = '';
  String _userEmail = '';
  String _firstName = '';
  String _lastName = '';
  String _planKey = '';
  String _planName = '';
  String _planPriceLabel = '';
  bool _rememberSession = false;
  String _rememberedEmail = '';
  String _rememberedPassword = '';

  bool get isAuthenticated => _authToken.isNotEmpty;
  String get authToken => _authToken;
  String get userEmail => _userEmail;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get planKey => _planKey;
  String get planName => _planName;
  String get planPriceLabel => _planPriceLabel;
  bool get rememberSession => _rememberSession;
  String get rememberedLoginEmail => _rememberedEmail;
  String get rememberedLoginPassword => _rememberedPassword;

  AppStage currentStage = AppStage.join;
  OnboardingStage onboardingStage = OnboardingStage.welcome;

  int joinStep = 1;
  String joinName = '';
  String joinEmail = '';
  bool consentData = false;
  bool consentAge = false;

  int? selectedAcknowledgementIndex;
  int currentQuestionIndex = 0;
  final Map<String, String> answers = <String, String>{};
  String freeTextAnswer = '';
  String commitName = '';

  final Map<String, int> lifeScores = <String, int>{};
  final Map<String, String> lifeNotes = <String, String>{};
  final List<int> selectedBeliefs = <int>[];
  final List<TimelineEventModel> timeline = <TimelineEventModel>[];
  final List<String> selectedTriggers = <String>[];
  final List<bool> completedFoundationSteps = <bool>[
    false,
    false,
    false,
    false,
  ];
  final List<ThoughtDiaryEntry> diaryEntries = <ThoughtDiaryEntry>[];
  final List<CopingCheckinEntry> copingEntries = <CopingCheckinEntry>[];

  // ── TOOLS ──
  int currentTool = 1;
  final Set<int> completedTools = <int>{};
  final List<WorkEntry> enquiryEntries = <WorkEntry>[];
  final List<WorkEntry> unwireEntries = <WorkEntry>[];

  JoinData? _joinData;
  JoinData? get joinData => _joinData;

  Future<void> initialize() async {
    _rememberedEmail = await _storageService.loadRememberedEmail();
    _rememberedPassword = await _storageService.loadRememberedPassword();
    if (_rememberedEmail.isNotEmpty) _rememberSession = true;

    final auth = await _storageService.loadAuth();
    if (auth != null) {
      _authToken = auth.token;
      _userEmail = auth.email;
      _firstName = auth.firstName;
      _lastName = auth.lastName;
      _planKey = auth.planKey;
      _planName = auth.planName;
      _planPriceLabel = auth.planPriceLabel;

      var hasSnapshot = false;
      var hasFoundationData = false;
      try {
        final serverData = await _snapshotApi.load(_authToken);
        if (serverData != null) {
          _applySnapshot(AppSnapshot.fromJson(serverData));
          hasSnapshot = true;
        }
      } catch (_) {}

      try {
        final entries = await _copingApi.load(_authToken);
        copingEntries
          ..clear()
          ..addAll(entries);
      } catch (_) {}

      try {
        final fd = await _foundationApi.load(_authToken);
        if (fd != null) {
          _applyFoundation(fd);
          hasFoundationData = true;
        }
      } catch (_) {}

      try {
        final td = await _toolsApi.load(_authToken);
        if (td != null) _applyTools(td);
      } catch (_) {}

      if (!hasSnapshot && hasFoundationData) currentStage = AppStage.foundation;
      if (joinName.isEmpty) joinName = '$_firstName $_lastName'.trim();
      if (joinEmail.isEmpty) joinEmail = _userEmail;
      _seedDefaults();
      return;
    }

    final snapshot = await _storageService.loadSnapshot();
    if (snapshot == null) {
      _seedDefaults();
      return;
    }
    _applySnapshot(snapshot);
    _seedDefaults();
  }

  void _applySnapshot(AppSnapshot snapshot) {
    _joinData = snapshot.joinData;
    currentStage = snapshot.currentStage;
    onboardingStage = snapshot.onboardingStage;
    joinStep = snapshot.joinStep;
    selectedAcknowledgementIndex = snapshot.acknowledgementIndex;
    currentQuestionIndex = snapshot.questionIndex;
    answers
      ..clear()
      ..addAll(snapshot.answers);
    freeTextAnswer = snapshot.freeText;
    commitName = snapshot.joinData?.name ?? '';
    joinName = snapshot.joinData?.name ?? '';
    joinEmail = snapshot.joinData?.email ?? '';
    consentData = snapshot.joinData?.consentData ?? false;
    consentAge = snapshot.joinData?.consentAge ?? false;
    lifeScores
      ..clear()
      ..addAll(snapshot.lifeScores);
    lifeNotes
      ..clear()
      ..addAll(snapshot.lifeNotes);
    selectedBeliefs
      ..clear()
      ..addAll(snapshot.selectedBeliefs);
    timeline
      ..clear()
      ..addAll(snapshot.timeline);
    selectedTriggers
      ..clear()
      ..addAll(snapshot.selectedTriggers);
    completedFoundationSteps
      ..clear()
      ..addAll(snapshot.completedFoundationSteps);
    diaryEntries
      ..clear()
      ..addAll(snapshot.diaryEntries);
    copingEntries
      ..clear()
      ..addAll(snapshot.copingEntries);
  }

  void _applyFoundation(FoundationData fd) {
    lifeScores
      ..clear()
      ..addAll(fd.lifeScores);
    lifeNotes
      ..clear()
      ..addAll(fd.lifeNotes);
    selectedBeliefs
      ..clear()
      ..addAll(fd.selectedBeliefs);
    timeline
      ..clear()
      ..addAll(fd.timeline);
    selectedTriggers
      ..clear()
      ..addAll(fd.selectedTriggers);
    completedFoundationSteps
      ..clear()
      ..addAll(fd.completedSteps);
  }

  void _applyTools(ToolsData td) {
    currentTool = td.currentTool;
    completedTools
      ..clear()
      ..addAll(td.completedTools);
    enquiryEntries
      ..clear()
      ..addAll(td.enquiryEntries);
    unwireEntries
      ..clear()
      ..addAll(td.unwireEntries);
  }

  void _saveTools() {
    if (_authToken.isEmpty) return;
    final td = ToolsData(
      currentTool: currentTool,
      completedTools: Set<int>.from(completedTools),
      enquiryEntries: List<WorkEntry>.from(enquiryEntries),
      unwireEntries: List<WorkEntry>.from(unwireEntries),
    );
    unawaited(_toolsApi.save(_authToken, td).catchError((_) {}));
  }

  void addEnquiryEntry(WorkEntry entry) {
    enquiryEntries.add(entry);
    notifyListeners();
    _saveTools();
  }

  void addUnwireEntry(WorkEntry entry) {
    unwireEntries.add(entry);
    notifyListeners();
    _saveTools();
  }

  void markToolComplete(int toolNum) {
    completedTools.add(toolNum);
    if (currentTool == toolNum && toolNum < 5) currentTool = toolNum + 1;
    notifyListeners();
    _saveTools();
  }

  void _saveFoundation() {
    if (_authToken.isEmpty) return;
    final fd = FoundationData(
      lifeScores: Map<String, int>.from(lifeScores),
      lifeNotes: Map<String, String>.from(lifeNotes),
      selectedBeliefs: List<int>.from(selectedBeliefs),
      timeline: List<TimelineEventModel>.from(timeline),
      selectedTriggers: List<String>.from(selectedTriggers),
      completedSteps: List<bool>.from(completedFoundationSteps),
    );
    unawaited(_foundationApi.save(_authToken, fd).catchError((_) {}));
  }

  Future<void> signIn({
    required String token,
    required String email,
    required String firstName,
    required String lastName,
    String planKey = '',
    String planName = '',
    String planPriceLabel = '',
    bool rememberSession = false,
    String loginEmail = '',
    String loginPassword = '',
  }) async {
    _authToken = token;
    _userEmail = email;
    _firstName = firstName;
    _lastName = lastName;
    _planKey = planKey;
    _planName = planName;
    _planPriceLabel = planPriceLabel;
    _rememberSession = rememberSession;
    _rememberedEmail = rememberSession ? loginEmail : '';
    _rememberedPassword = rememberSession ? loginPassword : '';

    if (rememberSession) {
      await _storageService.saveRememberedEmail(loginEmail);
      await _storageService.saveRememberedPassword(loginPassword);
      await _storageService.saveAuth(
        AuthSession(
          token: token,
          email: email,
          firstName: firstName,
          lastName: lastName,
          planKey: planKey,
          planName: planName,
          planPriceLabel: planPriceLabel,
        ),
      );
    } else {
      await _storageService.clearRememberedEmail();
      await _storageService.clearRememberedPassword();
    }

    var hasSnapshot = false;
    var hasFoundationData = false;
    try {
      final serverData = await _snapshotApi.load(token);
      if (serverData != null) {
        _applySnapshot(AppSnapshot.fromJson(serverData));
        hasSnapshot = true;
      }
    } catch (_) {}

    try {
      final entries = await _copingApi.load(token);
      copingEntries
        ..clear()
        ..addAll(entries);
    } catch (_) {}

    try {
      final fd = await _foundationApi.load(token);
      if (fd != null) {
        _applyFoundation(fd);
        hasFoundationData = true;
      }
    } catch (_) {}

    try {
      final td = await _toolsApi.load(token);
      if (td != null) _applyTools(td);
    } catch (_) {}

    if (hasSnapshot || hasFoundationData) {
      if (!hasSnapshot && hasFoundationData) currentStage = AppStage.foundation;
      if (joinName.isEmpty) joinName = '$firstName $lastName'.trim();
      if (joinEmail.isEmpty) joinEmail = email;
      _seedDefaults();
      return;
    }

    // New user — if they already have a plan (registered via landing page),
    // skip the join marketing screens and go straight to onboarding.
    joinName = '$firstName $lastName'.trim();
    joinEmail = email;
    commitName = joinName;
    if (planKey.isNotEmpty && planKey != 'free') {
      currentStage = AppStage.onboarding;
      onboardingStage = OnboardingStage.welcome;
    } else {
      currentStage = AppStage.join;
      onboardingStage = OnboardingStage.welcome;
    }
    _seedDefaults();
  }

  Future<void> signOut() async {
    _authToken = '';
    _userEmail = '';
    _firstName = '';
    _lastName = '';
    _planKey = '';
    _planName = '';
    _planPriceLabel = '';
    // Keep _rememberSession, _rememberedEmail, _rememberedPassword so the
    // sign-in form is pre-filled with the user's saved credentials.
    await _storageService.clearAuth();
    await resetApp();
  }

  Future<void> clearHistory() async {
    await _snapshotApi.delete(_authToken).catchError((_) {});
    await _foundationApi.delete(_authToken).catchError((_) {});
    await _toolsApi.delete(_authToken).catchError((_) {});
    await _copingApi.deleteAll(_authToken).catchError((_) {});
    await resetApp();
  }

  void _seedDefaults() {
    for (final area in AppContent.lifeAreas) {
      lifeScores.putIfAbsent(area, () => 0);
      lifeNotes.putIfAbsent(area, () => '');
    }
    if (timeline.isEmpty) {
      timeline.addAll(const [
        TimelineEventModel(year: '', event: '', type: ''),
        TimelineEventModel(year: '', event: '', type: ''),
        TimelineEventModel(year: '', event: '', type: ''),
      ]);
    }
    notifyListeners();
  }

  Future<void> _persist() async {
    final snapshot = AppSnapshot(
      joinData: _joinData,
      currentStage: currentStage,
      onboardingStage: onboardingStage,
      joinStep: joinStep,
      acknowledgementIndex: selectedAcknowledgementIndex,
      questionIndex: currentQuestionIndex,
      answers: Map<String, String>.from(answers),
      freeText: freeTextAnswer,
      lifeScores: Map<String, int>.from(lifeScores),
      lifeNotes: Map<String, String>.from(lifeNotes),
      selectedBeliefs: List<int>.from(selectedBeliefs),
      timeline: List<TimelineEventModel>.from(timeline),
      selectedTriggers: List<String>.from(selectedTriggers),
      completedFoundationSteps: List<bool>.from(completedFoundationSteps),
      diaryEntries: List<ThoughtDiaryEntry>.from(diaryEntries),
      copingEntries: List<CopingCheckinEntry>.from(copingEntries),
    );
    await _storageService.saveSnapshot(snapshot);
    if (_authToken.isNotEmpty) {
      unawaited(
        _snapshotApi.save(_authToken, snapshot.toJson()).catchError((_) {}),
      );
    }
  }

  Future<void> advanceJoinStep(int step) async {
    joinStep = step;
    notifyListeners();
    await _persist();
  }

  void updateJoinName(String value) {
    joinName = value;
    notifyListeners();
  }

  void updateJoinEmail(String value) {
    joinEmail = value;
    notifyListeners();
  }

  void toggleConsentData() {
    consentData = !consentData;
    notifyListeners();
  }

  void toggleConsentAge() {
    consentAge = !consentAge;
    notifyListeners();
  }

  bool get joinReady {
    final emailOk = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(joinEmail);
    return joinName.trim().isNotEmpty && emailOk && consentAge && consentData;
  }

  Future<void> submitJoin() async {
    _joinData = JoinData(
      name: joinName.trim(),
      email: joinEmail.trim(),
      consentData: consentData,
      consentAge: consentAge,
      joinedAtEpochMs: DateTime.now().millisecondsSinceEpoch,
    );
    commitName = _joinData!.name;
    currentStage = AppStage.onboarding;
    onboardingStage = OnboardingStage.welcome;
    notifyListeners();
    await _persist();
  }

  Future<void> selectAcknowledgement(int index) async {
    selectedAcknowledgementIndex = index;
    notifyListeners();
    await _persist();
  }

  List<String> get currentQuestionOptions {
    if (currentQuestionIndex == 0) {
      return AppContent.questionOneOptions
          .map((item) => item['label']!)
          .toList();
    }

    final profile = answers['q1Profile'] ?? 'ANXIETY';
    final key = 'q${currentQuestionIndex + 1}';
    return AppContent.questionBanks[profile]?[key] ?? <String>[];
  }

  String get currentProfileKey => answers['q1Profile'] ?? 'ANXIETY';

  Future<void> selectQuestionAnswer(String value) async {
    final questionKey = 'q${currentQuestionIndex + 1}';
    answers[questionKey] = value;

    if (currentQuestionIndex == 0) {
      final profile = AppContent.questionOneOptions.firstWhere(
        (item) => item['label'] == value,
      )['profile']!;
      answers['q1Profile'] = profile;
      answers.remove('q2');
      answers.remove('q3');
      answers.remove('q4');
    }

    notifyListeners();
    await _persist();
  }

  bool get canAdvanceQuestion {
    if (currentQuestionIndex == 4) return true;
    return answers['q${currentQuestionIndex + 1}']?.isNotEmpty ?? false;
  }

  Future<void> nextQuestion() async {
    if (currentQuestionIndex < 4) {
      currentQuestionIndex += 1;
      notifyListeners();
      await _persist();
      return;
    }
    onboardingStage = OnboardingStage.profile;
    notifyListeners();
    await _persist();
  }

  Future<void> moveToOnboardingStage(OnboardingStage stage) async {
    onboardingStage = stage;
    notifyListeners();
    await _persist();
  }

  void updateFreeTextAnswer(String value) {
    freeTextAnswer = value;
    notifyListeners();
  }

  void updateCommitName(String value) {
    commitName = value;
    notifyListeners();
  }

  bool get canEnterFoundation => commitName.trim().length >= 2;

  Future<void> enterFoundation() async {
    if (_joinData != null) {
      _joinData = JoinData(
        name: commitName.trim(),
        email: _joinData!.email,
        consentData: _joinData!.consentData,
        consentAge: _joinData!.consentAge,
        joinedAtEpochMs: _joinData!.joinedAtEpochMs,
      );
    }
    currentStage = AppStage.foundation;
    notifyListeners();
    await _persist();
  }

  Map<String, String> get profileData {
    final q1 = answers['q1Profile'] ?? 'ANXIETY';
    final q2 = answers['q2'] ?? '';
    final q3 = answers['q3'] ?? '';
    final q4 = answers['q4'] ?? '';

    bool has(String value, String fragment) {
      return value.toLowerCase().contains(fragment.toLowerCase());
    }

    final timeLine = has(q2, 'recently')
        ? 'something recent has triggered this'
        : has(q2, 'last year')
        ? 'it\'s been building for a year or two'
        : has(q2, 'years')
        ? 'you\'ve been carrying this for years'
        : has(q2, 'always')
        ? 'this goes right back — probably further than you think'
        : 'this has been going on for a while';

    final copeLine = has(q3, 'keep busy')
        ? 'keeping busy to avoid it'
        : has(q3, 'numb')
        ? 'numbing it — drink, food, scrolling, whatever takes the edge off'
        : has(q3, 'push')
        ? 'pushing through and hoping it passes'
        : has(q3, 'anger') || has(q3, 'fuck')
        ? 'it coming out as anger and frustration'
        : has(q3, 'build')
        ? 'letting it build until it gets too heavy'
        : 'trying to manage it the best way you know how';

    final wantLine = has(q4, 'quiet')
        ? 'a quieter head — less noise, better sleep'
        : has(q4, 'relationship')
        ? 'better relationships — to actually show up for the people around you'
        : has(q4, 'direction')
        ? 'direction — to know what you want and start moving'
        : has(q4, 'confidence')
        ? 'confidence — to stop second-guessing every decision'
        : has(q4, 'myself')
        ? 'to feel like yourself again'
        : 'to feel like yourself again';

    if (q1 == 'BURNOUT') {
      return {
        'headline': 'Burnout.',
        'recognition':
            'You\'ve been giving everything to everyone else and there\'s nothing left — and $timeLine. You\'ve been $copeLine. What you actually want is $wantLine. The man you were before all this — he\'s still there.\n\nYou\'re not weak. You define you — and you\'re a man who\'s been running on empty without the right tools to refuel. That changes now.',
        'belief': '"I don\'t deserve to stop."',
        'beliefSub':
            'Rest feels selfish. Self-care feels indulgent. So you keep going until something breaks. This is how we change that.',
      };
    }
    if (q1 == 'OVERWHELM') {
      return {
        'headline': 'Overwhelm.',
        'recognition':
            'There\'s too much going on and you can\'t see the wood for the trees — and $timeLine. You\'ve been $copeLine. What you actually want is $wantLine. That\'s what we help you find.\n\nYou\'re not weak. You define you — and you\'re a man carrying too much without the right tools to put some of it down. That changes now.',
        'belief': '"I have to hold it all together."',
        'beliefSub':
            'The weight of keeping everything going falls on you. It always has. But carrying everything alone isn\'t strength — it\'s a pattern. And it can change.',
      };
    }
    return {
      'headline': 'Anxiety.',
      'recognition':
          'The head\'s constantly going — and $timeLine. You\'ve been $copeLine. What you actually want is $wantLine. That\'s not too much to ask. And it\'s exactly what the tools in here are built for.\n\nYou\'re not weak. You define you — and you\'re a man who\'s been carrying this without the right tools to deal with it. That changes now.',
      'belief': '"I should be able to handle this on my own."',
      'beliefSub':
          'Most anxious men carry this one. Asking for help feels like failing. So it compounds in silence. That cycle ends here.',
    };
  }

  int get completedFoundationCount =>
      completedFoundationSteps.where((done) => done).length;

  void updateLifeScore(String area, int score) {
    lifeScores[area] = score;
    notifyListeners();
    _saveFoundation();
    _persist();
  }

  void updateLifeNote(String area, String note) {
    lifeNotes[area] = note;
    notifyListeners();
    _saveFoundation();
    _persist();
  }

  bool get lifeAssessmentReady =>
      AppContent.lifeAreas.every((area) => (lifeScores[area] ?? 0) > 0);

  void toggleBelief(int index) {
    if (selectedBeliefs.contains(index)) {
      selectedBeliefs.remove(index);
    } else {
      selectedBeliefs.add(index);
    }
    notifyListeners();
    _saveFoundation();
    _persist();
  }

  void updateTimelineYear(int index, String value) {
    timeline[index] = timeline[index].copyWith(year: value);
    notifyListeners();
    _saveFoundation();
    _persist();
  }

  void updateTimelineEvent(int index, String value) {
    timeline[index] = timeline[index].copyWith(event: value);
    notifyListeners();
    _saveFoundation();
    _persist();
  }

  void updateTimelineType(int index, String value) {
    timeline[index] = timeline[index].copyWith(type: value);
    notifyListeners();
    _saveFoundation();
    _persist();
  }

  void addTimelineEvent() {
    timeline.add(const TimelineEventModel(year: '', event: '', type: ''));
    notifyListeners();
    _saveFoundation();
    _persist();
  }

  void removeTimelineEvent(int index) {
    if (timeline.length <= 1) return;
    timeline.removeAt(index);
    notifyListeners();
    _saveFoundation();
    _persist();
  }

  bool get timelineReady =>
      timeline.where((item) {
        return item.year.trim().isNotEmpty &&
            item.event.trim().length > 2 &&
            item.type.isNotEmpty;
      }).length >=
      3;

  void toggleTrigger(String key) {
    if (selectedTriggers.contains(key)) {
      selectedTriggers.remove(key);
    } else {
      selectedTriggers.add(key);
    }
    notifyListeners();
    _saveFoundation();
    _persist();
  }

  bool get triggersReady => selectedTriggers.isNotEmpty;

  Future<void> completeFoundationStep(int index) async {
    completedFoundationSteps[index] = true;
    notifyListeners();
    _saveFoundation();
    await _persist();
  }

  bool isFoundationStepUnlocked(int index) {
    if (index == 0) return true;
    return completedFoundationSteps[index - 1];
  }

  double get foundationProgress => completedFoundationCount / 4;

  String get primaryName {
    final joinedName = _joinData?.name.trim() ?? '';
    if (joinedName.isNotEmpty) return joinedName;

    final committedName = commitName.trim();
    if (committedName.isNotEmpty) return committedName;

    return 'Mate';
  }

  Future<void> saveDiaryEntry({
    required int score,
    required String why,
    required String happened,
    required String thought,
  }) async {
    final now = DateTime.now();
    final key = _dateKey(now);
    final label = _dateLabel(now);
    diaryEntries.removeWhere(
      (entry) => entry.dateKey == key || entry.dateLabel == label,
    );
    diaryEntries.add(
      ThoughtDiaryEntry(
        dateKey: key,
        dateLabel: label,
        score: score,
        why: why,
        happened: happened,
        heaviestThought: thought,
        createdAtEpochMs: now.millisecondsSinceEpoch,
      ),
    );
    notifyListeners();
    await _persist();
  }

  ThoughtDiaryEntry? get todayDiaryEntry {
    final now = DateTime.now();
    final key = _dateKey(now);
    final label = _dateLabel(now);
    try {
      return diaryEntries.firstWhere(
        (entry) => entry.dateKey == key || entry.dateLabel == label,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> saveCopingEntry({
    required int score,
    required String down,
    required String up,
    required String action,
    String change = '',
  }) async {
    final now = DateTime.now();
    final entry = CopingCheckinEntry(
      dateLabel: _dateLabel(now),
      score: score,
      down: down,
      up: up,
      action: action,
      change: change,
      createdAtEpochMs: now.millisecondsSinceEpoch,
    );
    copingEntries.add(entry);
    notifyListeners();
    if (_authToken.isNotEmpty) {
      unawaited(_copingApi.save(_authToken, entry).catchError((_) {}));
    }
    await _persist();
  }

  Future<void> resetApp() async {
    await _storageService.clear();
    currentStage = AppStage.join;
    onboardingStage = OnboardingStage.welcome;
    joinStep = 1;
    joinName = '';
    joinEmail = '';
    consentData = false;
    consentAge = false;
    selectedAcknowledgementIndex = null;
    currentQuestionIndex = 0;
    answers.clear();
    freeTextAnswer = '';
    commitName = '';
    selectedBeliefs.clear();
    selectedTriggers.clear();
    lifeScores.clear();
    lifeNotes.clear();
    timeline
      ..clear()
      ..addAll(const [
        TimelineEventModel(year: '', event: '', type: ''),
        TimelineEventModel(year: '', event: '', type: ''),
        TimelineEventModel(year: '', event: '', type: ''),
      ]);
    completedFoundationSteps
      ..clear()
      ..addAll([false, false, false, false]);
    diaryEntries.clear();
    copingEntries.clear();
    currentTool = 1;
    completedTools.clear();
    enquiryEntries.clear();
    unwireEntries.clear();
    _joinData = null;
    _seedDefaults();
    notifyListeners();
  }

  String _dateLabel(DateTime date) {
    const days = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${days[date.weekday % 7]} ${date.day} ${months[date.month - 1]}';
  }

  String _dateKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
