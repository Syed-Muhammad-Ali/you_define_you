enum AppStage { join, onboarding, foundation }

class AuthSession {
  const AuthSession({
    required this.token,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.planKey = '',
    this.planName = '',
    this.planPriceLabel = '',
  });

  final String token;
  final String email;
  final String firstName;
  final String lastName;
  final String planKey;
  final String planName;
  final String planPriceLabel;

  Map<String, dynamic> toJson() => {
        'token': token,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'planKey': planKey,
        'planName': planName,
        'planPriceLabel': planPriceLabel,
      };

  factory AuthSession.fromJson(Map<String, dynamic> json) => AuthSession(
        token: json['token'] as String? ?? '',
        email: json['email'] as String? ?? '',
        firstName: json['firstName'] as String? ?? '',
        lastName: json['lastName'] as String? ?? '',
        planKey: json['planKey'] as String? ?? '',
        planName: json['planName'] as String? ?? '',
        planPriceLabel: json['planPriceLabel'] as String? ?? '',
      );
}

enum OnboardingStage { welcome, acknowledge, questions, profile, commitment }

class JoinData {
  const JoinData({
    required this.name,
    required this.email,
    required this.consentData,
    required this.consentAge,
    required this.joinedAtEpochMs,
  });

  final String name;
  final String email;
  final bool consentData;
  final bool consentAge;
  final int joinedAtEpochMs;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'consentData': consentData,
      'consentAge': consentAge,
      'joinedAtEpochMs': joinedAtEpochMs,
    };
  }

  factory JoinData.fromJson(Map<String, dynamic> json) {
    return JoinData(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      consentData: json['consentData'] as bool? ?? false,
      consentAge: json['consentAge'] as bool? ?? false,
      joinedAtEpochMs: json['joinedAtEpochMs'] as int? ?? 0,
    );
  }
}

class TimelineEventModel {
  const TimelineEventModel({
    required this.year,
    required this.event,
    required this.type,
  });

  final String year;
  final String event;
  final String type;

  TimelineEventModel copyWith({String? year, String? event, String? type}) {
    return TimelineEventModel(
      year: year ?? this.year,
      event: event ?? this.event,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    return {'year': year, 'event': event, 'type': type};
  }

  factory TimelineEventModel.fromJson(Map<String, dynamic> json) {
    return TimelineEventModel(
      year: json['year'] as String? ?? '',
      event: json['event'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }
}

class ThoughtDiaryEntry {
  const ThoughtDiaryEntry({
    required this.dateKey,
    required this.dateLabel,
    required this.score,
    required this.why,
    required this.happened,
    required this.heaviestThought,
    this.createdAtEpochMs = 0,
  });

  final String dateKey;
  final String dateLabel;
  final int score;
  final String why;
  final String happened;
  final String heaviestThought;
  final int createdAtEpochMs;

  Map<String, dynamic> toJson() {
    return {
      'dateKey': dateKey,
      'dateLabel': dateLabel,
      'score': score,
      'why': why,
      'happened': happened,
      'heaviestThought': heaviestThought,
      'createdAtEpochMs': createdAtEpochMs,
    };
  }

  factory ThoughtDiaryEntry.fromJson(Map<String, dynamic> json) {
    return ThoughtDiaryEntry(
      dateKey: json['dateKey'] as String? ?? json['dateLabel'] as String? ?? '',
      dateLabel: json['dateLabel'] as String? ?? '',
      score: json['score'] as int? ?? 0,
      why: json['why'] as String? ?? '',
      happened: json['happened'] as String? ?? '',
      heaviestThought: json['heaviestThought'] as String? ?? '',
      createdAtEpochMs: json['createdAtEpochMs'] as int? ?? 0,
    );
  }
}

class WorkEntry {
  const WorkEntry({
    required this.beliefIndex,
    required this.belief,
    required this.type,
    required this.response,
    required this.action,
    required this.date,
  });

  final int beliefIndex;
  final String belief;
  final String type;
  final String response;
  final String action;
  final String date;

  Map<String, dynamic> toJson() => {
        'beliefIndex': beliefIndex,
        'belief': belief,
        'type': type,
        'response': response,
        'action': action,
        'date': date,
      };

  factory WorkEntry.fromJson(Map<String, dynamic> json) => WorkEntry(
        beliefIndex: (json['beliefIndex'] as num?)?.toInt() ?? 0,
        belief: json['belief'] as String? ?? '',
        type: json['type'] as String? ?? '',
        response: json['response'] as String? ?? '',
        action: json['action'] as String? ?? '',
        date: json['date'] as String? ?? '',
      );
}

class CopingCheckinEntry {
  const CopingCheckinEntry({
    required this.dateLabel,
    required this.score,
    required this.down,
    required this.up,
    required this.action,
    this.change = '',
    this.createdAtEpochMs = 0,
  });

  final String dateLabel;
  final int score;
  final String down;
  final String up;
  final String action;
  final String change;
  final int createdAtEpochMs;

  Map<String, dynamic> toJson() {
    return {
      'dateLabel': dateLabel,
      'score': score,
      'down': down,
      'up': up,
      'action': action,
      'change': change,
      'createdAtEpochMs': createdAtEpochMs,
    };
  }

  factory CopingCheckinEntry.fromJson(Map<String, dynamic> json) {
    return CopingCheckinEntry(
      dateLabel: json['dateLabel'] as String? ?? '',
      score: json['score'] as int? ?? 0,
      down: json['down'] as String? ?? '',
      up: json['up'] as String? ?? '',
      action: json['action'] as String? ?? '',
      change: json['change'] as String? ?? '',
      createdAtEpochMs: json['createdAtEpochMs'] as int? ?? 0,
    );
  }
}

class AppSnapshot {
  const AppSnapshot({
    this.joinData,
    this.currentStage = AppStage.join,
    this.onboardingStage = OnboardingStage.welcome,
    this.joinStep = 1,
    this.acknowledgementIndex,
    this.questionIndex = 0,
    this.answers = const {},
    this.freeText = '',
    this.lifeScores = const {},
    this.lifeNotes = const {},
    this.selectedBeliefs = const [],
    this.timeline = const [],
    this.selectedTriggers = const [],
    this.completedFoundationSteps = const [false, false, false, false],
    this.diaryEntries = const [],
    this.copingEntries = const [],
  });

  final JoinData? joinData;
  final AppStage currentStage;
  final OnboardingStage onboardingStage;
  final int joinStep;
  final int? acknowledgementIndex;
  final int questionIndex;
  final Map<String, String> answers;
  final String freeText;
  final Map<String, int> lifeScores;
  final Map<String, String> lifeNotes;
  final List<int> selectedBeliefs;
  final List<TimelineEventModel> timeline;
  final List<String> selectedTriggers;
  final List<bool> completedFoundationSteps;
  final List<ThoughtDiaryEntry> diaryEntries;
  final List<CopingCheckinEntry> copingEntries;

  Map<String, dynamic> toJson() {
    return {
      'joinData': joinData?.toJson(),
      'currentStage': currentStage.name,
      'onboardingStage': onboardingStage.name,
      'joinStep': joinStep,
      'acknowledgementIndex': acknowledgementIndex,
      'questionIndex': questionIndex,
      'answers': answers,
      'freeText': freeText,
      'lifeScores': lifeScores,
      'lifeNotes': lifeNotes,
      'selectedBeliefs': selectedBeliefs,
      'timeline': timeline.map((e) => e.toJson()).toList(),
      'selectedTriggers': selectedTriggers,
      'completedFoundationSteps': completedFoundationSteps,
      'diaryEntries': diaryEntries.map((e) => e.toJson()).toList(),
      'copingEntries': copingEntries.map((e) => e.toJson()).toList(),
    };
  }

  factory AppSnapshot.fromJson(Map<String, dynamic> json) {
    return AppSnapshot(
      joinData: json['joinData'] == null
          ? null
          : JoinData.fromJson(
              Map<String, dynamic>.from(json['joinData'] as Map),
            ),
      currentStage: AppStage.values.firstWhere(
        (stage) => stage.name == json['currentStage'],
        orElse: () => AppStage.join,
      ),
      onboardingStage: OnboardingStage.values.firstWhere(
        (stage) => stage.name == json['onboardingStage'],
        orElse: () => OnboardingStage.welcome,
      ),
      joinStep: json['joinStep'] as int? ?? 1,
      acknowledgementIndex: json['acknowledgementIndex'] as int?,
      questionIndex: json['questionIndex'] as int? ?? 0,
      answers:
          (json['answers'] as Map?)?.map(
            (key, value) => MapEntry(key.toString(), value.toString()),
          ) ??
          {},
      freeText: json['freeText'] as String? ?? '',
      lifeScores:
          (json['lifeScores'] as Map?)?.map(
            (key, value) => MapEntry(key.toString(), (value as num).toInt()),
          ) ??
          {},
      lifeNotes:
          (json['lifeNotes'] as Map?)?.map(
            (key, value) => MapEntry(key.toString(), value.toString()),
          ) ??
          {},
      selectedBeliefs:
          (json['selectedBeliefs'] as List?)
              ?.map((item) => (item as num).toInt())
              .toList() ??
          [],
      timeline:
          (json['timeline'] as List?)
              ?.map(
                (item) => TimelineEventModel.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList() ??
          [],
      selectedTriggers:
          (json['selectedTriggers'] as List?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      completedFoundationSteps:
          (json['completedFoundationSteps'] as List?)
              ?.map((item) => item as bool)
              .toList() ??
          [false, false, false, false],
      diaryEntries:
          (json['diaryEntries'] as List?)
              ?.map(
                (item) => ThoughtDiaryEntry.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList() ??
          [],
      copingEntries:
          (json['copingEntries'] as List?)
              ?.map(
                (item) => CopingCheckinEntry.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList() ??
          [],
    );
  }
}
