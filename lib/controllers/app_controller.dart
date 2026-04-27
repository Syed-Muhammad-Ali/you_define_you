import 'package:flutter/foundation.dart';

import '../app/constants/app_content.dart';
import '../models/app_models.dart';
import '../services/local_storage_service.dart';

class AppController extends ChangeNotifier {
  AppController({required LocalStorageService storageService})
    : _storageService = storageService;

  final LocalStorageService _storageService;

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

  JoinData? _joinData;
  JoinData? get joinData => _joinData;

  Future<void> initialize() async {
    final snapshot = await _storageService.loadSnapshot();
    if (snapshot == null) {
      _seedDefaults();
      return;
    }

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

    _seedDefaults();
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
    if (q1 == 'BURNOUT') {
      return {
        'headline': 'Burnout.',
        'recognition':
            'You\'ve been giving everything to everyone else and there\'s nothing left. The version of you before all this is still there. We just need to get back to him.',
        'belief': '"I don\'t deserve to stop."',
        'beliefSub':
            'Rest feels selfish. So you keep going until something breaks. This is where that pattern changes.',
      };
    }
    if (q1 == 'OVERWHELM') {
      return {
        'headline': 'Overwhelm.',
        'recognition':
            'There\'s too much going on and you can\'t see the wood for the trees. You\'ve been carrying too much without the right tools to put some of it down.',
        'belief': '"I have to hold it all together."',
        'beliefSub':
            'That weight has been sitting on your shoulders for a long time. Naming it is the first crack in it.',
      };
    }
    return {
      'headline': 'Anxiety.',
      'recognition':
          'The head\'s constantly going. You\'ve been carrying this without the right tools to deal with it. That changes now.',
      'belief': '"I should be able to handle this on my own."',
      'beliefSub':
          'Most anxious men carry this one. Asking for help feels like failing, so it compounds in silence.',
    };
  }

  int get completedFoundationCount =>
      completedFoundationSteps.where((done) => done).length;

  void updateLifeScore(String area, int score) {
    lifeScores[area] = score;
    notifyListeners();
    _persist();
  }

  void updateLifeNote(String area, String note) {
    lifeNotes[area] = note;
    notifyListeners();
    _persist();
  }

  bool get lifeAssessmentReady =>
      AppContent.lifeAreas.every((area) => (lifeScores[area] ?? 0) > 0);

  void toggleBelief(int index) {
    if (selectedBeliefs.contains(index)) {
      selectedBeliefs.remove(index);
    } else if (selectedBeliefs.length < 5) {
      selectedBeliefs.add(index);
    }
    notifyListeners();
    _persist();
  }

  void updateTimelineYear(int index, String value) {
    timeline[index] = timeline[index].copyWith(year: value);
    notifyListeners();
    _persist();
  }

  void updateTimelineEvent(int index, String value) {
    timeline[index] = timeline[index].copyWith(event: value);
    notifyListeners();
    _persist();
  }

  void updateTimelineType(int index, String value) {
    timeline[index] = timeline[index].copyWith(type: value);
    notifyListeners();
    _persist();
  }

  void addTimelineEvent() {
    timeline.add(const TimelineEventModel(year: '', event: '', type: ''));
    notifyListeners();
    _persist();
  }

  void removeTimelineEvent(int index) {
    if (timeline.length <= 1) return;
    timeline.removeAt(index);
    notifyListeners();
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
    _persist();
  }

  bool get triggersReady => selectedTriggers.isNotEmpty;

  Future<void> completeFoundationStep(int index) async {
    completedFoundationSteps[index] = true;
    notifyListeners();
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
    final label = _dateLabel(now);
    diaryEntries.removeWhere((entry) => entry.dateLabel == label);
    diaryEntries.add(
      ThoughtDiaryEntry(
        dateLabel: label,
        score: score,
        why: why,
        happened: happened,
        heaviestThought: thought,
      ),
    );
    notifyListeners();
    await _persist();
  }

  ThoughtDiaryEntry? get todayDiaryEntry {
    final label = _dateLabel(DateTime.now());
    try {
      return diaryEntries.firstWhere((entry) => entry.dateLabel == label);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveCopingEntry({
    required int score,
    required String down,
    required String up,
    required String action,
  }) async {
    copingEntries.add(
      CopingCheckinEntry(
        dateLabel: _dateLabel(DateTime.now()),
        score: score,
        down: down,
        up: up,
        action: action,
      ),
    );
    notifyListeners();
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
}
