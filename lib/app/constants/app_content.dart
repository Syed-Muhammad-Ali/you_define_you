class AppContent {
  AppContent._();

  static const List<String> joinStepTwo = [
    'You\'ll understand what\'s driving it\nNot vague self-help advice. A clear picture of what\'s actually going on under the surface — the beliefs, the patterns, the triggers.',
    'You\'ll get a set of tools that actually work\nFive weekly tools built for men. Each one builds on the last. They work because of the foundation work you do first — not despite it.',
    'You\'ll build a picture of your week\nThe Thought Diary runs daily. After 7 days you\'ll see your patterns in a way you never have before. That\'s the intel that changes how you operate.',
    'You\'ll have something for when it hits hard\nBreathing. Tapping. Cold water. When anxiety is live — before the tools, before thinking — these work directly on your nervous system.',
  ];

  static const List<String> joinStepTwoIcons = ['🔍', '🛠', '📓', '🆘'];

  static const List<String> joinStepThree = [
    'You\'re not weak for being here. You\'re here because you\'re done pretending everything is fine.',
    'Whatever you\'re carrying right now — anxiety, burnout, overwhelm — it didn\'t come from nowhere. And it won\'t go away by ignoring it.',
    'Most men who find this app have been going round the same circle for a long time. That circle ends when you decide it does. Not before.',
    'You\'re not broken. You define you — and you\'ve chosen to start doing that on your terms.',
  ];

  static const List<String> acknowledgementStatements = [
    'You\'re holding it together on the outside but it\'s a different story in your head.',
    'You wake up anxious and don\'t fully know why. You just do.',
    'You\'re doing everything for everyone else and running on empty.',
  ];

  static const List<Map<String, String>> questionOneOptions = [
    {
      'label': 'The head\'s constantly going — I can\'t switch it off',
      'profile': 'ANXIETY',
    },
    {
      'label': 'I wake up dreading the day and don\'t know why',
      'profile': 'ANXIETY',
    },
    {
      'label': 'I\'m completely wiped out — nothing left to give',
      'profile': 'BURNOUT',
    },
    {
      'label': 'I\'ve lost all motivation — just going through the motions',
      'profile': 'BURNOUT',
    },
    {
      'label': 'Too much going on — I can\'t see the wood for the trees',
      'profile': 'OVERWHELM',
    },
    {
      'label': 'I\'m holding everything together but something\'s got to give',
      'profile': 'OVERWHELM',
    },
  ];

  static const Map<String, Map<String, List<String>>> questionBanks = {
    'ANXIETY': {
      'q2': [
        'Recently — something\'s triggered it and it hasn\'t stopped',
        'Last year or two — it\'s been creeping up on me',
        'Years — I\'ve managed it but it\'s getting worse',
        'Always been there — it\'s just part of who I am, going back to when I was young',
      ],
      'q3': [
        'Keep Busy — work, gym, whatever fills the time',
        'Avoid it — I don\'t do the things that trigger it',
        'Numb it — drink, food, TV, scrolling',
        'Push Through — just get on with it and hope it passes',
        'Nothing — I let it build up',
      ],
      'q4': [
        'Quiet head — less noise, better sleep, able to actually switch off',
        'More confidence — stop second-guessing every decision I make',
        'Stop avoiding things — I want my life back, not a smaller version of it',
        'Better relationships — stop snapping at the wrong people',
        'Just feel normal — not on edge all the time',
      ],
    },
    'BURNOUT': {
      'q2': [
        'Recently — hit a wall out of nowhere',
        'Last year or two — it\'s been grinding me down',
        'Years — I\'ve been running on empty for longer than I can remember',
        'Always — I\'ve never really known what it feels like to not be exhausted',
      ],
      'q3': [
        'Keep Busy — work, gym, whatever fills the time',
        'Avoid it — I don\'t do the things that trigger it',
        'Numb it — drink, food, TV, scrolling',
        'Push Through — just get on with it and hope it passes',
        'Nothing — I let it build up',
      ],
      'q4': [
        'Energy back — to actually want to get up in the morning',
        'Feel like myself again — I don\'t know when that version of me left',
        'Better relationships — to actually show up for the people around me',
        'Direction — something to work toward that actually means something',
        'Just stop — to rest without feeling guilty about it',
      ],
    },
    'OVERWHELM': {
      'q2': [
        'Recently — something changed and now everything feels unmanageable',
        'Last year or two — it\'s been stacking up bit by bit',
        'Years — I\'ve just kept adding more and never taken anything away',
        'Always — I\'ve always taken on too much, it\'s just what I do',
      ],
      'q3': [
        'Keep Busy — work, gym, whatever fills the time',
        'Avoid it — I don\'t do the things that trigger it',
        'Numb it — drink, food, TV, scrolling',
        'Push Through — just get on with it and hope it passes',
        'Nothing — I let it build up',
      ],
      'q4': [
        'Clarity — to know what actually matters and let the rest go',
        'Control — to feel like I\'m steering my life instead of just surviving it',
        'Space — headspace, time, breathing room — just less',
        'Better relationships — to stop being distracted and actually be present',
        'Direction — to feel like I\'m moving forward instead of just treading water',
      ],
    },
  };

  static const List<String> lifeAreas = [
    'Career',
    'Relationship',
    'Family',
    'Health',
    'Friendships',
    'Creativity & Interests',
  ];

  static const List<String> beliefs = [
    'I should be able to handle this on my own',
    'Asking for help is a sign of weakness',
    'I\'m not smart enough',
    'I\'m not successful enough to be taken seriously',
    'I don\'t have enough time',
    'I don\'t have enough energy',
    'I\'m not where I should be at my age',
    'I\'m not a good enough father',
    'I\'m not a good enough partner',
    'I\'m a failure',
    'I\'m not strong enough — mentally or physically',
    'I\'ll never be truly happy',
    'Change is too hard — I\'ve tried before',
    'I don\'t deserve to have more than what I have',
    'Not trying is better than failing',
    'I\'ll never be successful enough',
    'I just have bad luck',
    'I can\'t trust myself',
    'I feel like an imposter — people will find out I can\'t do my job',
    'I can\'t relax or everything will fall apart',
    'Showing emotion makes me less of a man',
    'Being vulnerable will be used against me',
    'I have to hold everything together — no one else will',
    'No one would understand what I\'m going through',
    'Men don\'t talk about this stuff',
    'I should just get on with it',
    'My needs don\'t matter as much as everyone else\'s',
    'Risking failure is not worth the embarrassment',
    'I\'m not self-disciplined enough',
    'I don\'t deserve to rest',
    'I\'m too far gone to change now',
    'Why try? I\'ll just fail again',
    'I\'m not good enough — full stop',
    'Getting my hopes up always leads to disappointment',
    'Everyone else has it together and I\'m struggling',
    'I can\'t let anyone see how much I\'m really struggling',
    'My mental health issues make me less of a man',
    'There\'s always someone doing better than me',
    'I don\'t have the right background or education',
    'I\'ve wasted too many years already',
  ];

  static const List<Map<String, String>> dailyTriggers = [
    {
      'name': 'Procrastination',
      'desc':
          'Putting things off creates a build-up of pressure that feeds the anxiety.',
    },
    {
      'name': 'Comparison',
      'desc':
          'Measuring yourself against others — what they have, what they\'ve achieved, how they look.',
    },
    {
      'name': 'Jumping to conclusions',
      'desc':
          'Assuming the worst without evidence. The brain filling in gaps with fear.',
    },
    {
      'name': 'Worrying what others think',
      'desc': 'Living your life based on how you think you\'re being judged.',
    },
    {
      'name': 'Lack of personal direction',
      'desc': 'No clear picture of where you\'re going or why.',
    },
    {
      'name': 'Unfinished projects',
      'desc':
          'Things started but never completed — they sit in the background draining energy.',
    },
    {
      'name': 'Disorganised',
      'desc':
          'Chaos in your environment or schedule creates chaos in your head.',
    },
    {
      'name': 'Hiding from fears',
      'desc':
          'Avoiding the thing rather than confronting it. The avoidance becomes its own problem.',
    },
    {
      'name': 'Feeling overwhelmed',
      'desc': 'Too much on, no way to see clearly, no obvious first step.',
    },
    {
      'name': 'External influences',
      'desc': 'Things outside your control that knock your mood or confidence.',
    },
  ];

  static const List<Map<String, String>> specificTriggers = [
    {
      'name': 'Alcohol',
      'desc':
          'Alcohol disrupts sleep and mood regulation, increasing anxiety the next day.',
    },
    {
      'name': 'Poor sleep',
      'desc':
          'Sleep deprivation amplifies emotional responses and reduces resilience.',
    },
    {
      'name': 'Allergies',
      'desc':
          'Some physical allergic responses can mimic or trigger anxiety symptoms.',
    },
    {
      'name': 'Diet & nutrition',
      'desc':
          'Blood sugar crashes and poor nutrition directly impact mood and anxiety.',
    },
  ];
}
