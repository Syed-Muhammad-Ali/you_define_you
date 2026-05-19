// ─────────────────────────────────────────────
//  YOU DEFINE YOU — All Static Data
// ─────────────────────────────────────────────

const List<String> kLifeAreas = [
  'Career', 'Relationship', 'Family',
  'Health', 'Friendships', 'Creativity & Interests',
];

const List<String> kBeliefs = [
  "I should be able to handle this on my own",
  "Asking for help is a sign of weakness",
  "I'm not smart enough",
  "I'm not successful enough to be taken seriously",
  "I don't have enough time",
  "I don't have enough energy",
  "I'm not where I should be at my age",
  "I'm not a good enough father",
  "I'm not a good enough partner",
  "I'm a failure",
  "I'm not strong enough — mentally or physically",
  "I'll never be truly happy",
  "Change is too hard — I've tried before",
  "I don't deserve to have more than what I have",
  "Not trying is better than failing",
  "I'll never be successful enough",
  "I just have bad luck",
  "I can't trust myself",
  "I feel like an imposter — people will find out I can't do my job",
  "I can't relax or everything will fall apart",
  "Showing emotion makes me less of a man",
  "Being vulnerable will be used against me",
  "I have to hold everything together — no one else will",
  "No one would understand what I'm going through",
  "Men don't talk about this stuff",
  "I should just get on with it",
  "My needs don't matter as much as everyone else's",
  "Risking failure is not worth the embarrassment",
  "I'm not self-disciplined enough",
  "I don't deserve to rest",
  "I'm too far gone to change now",
  "Why try? I'll just fail again",
  "I'm not good enough — full stop",
  "Getting my hopes up always leads to disappointment",
  "Everyone else has it together and I'm struggling",
  "I can't let anyone see how much I'm really struggling",
  "My mental health issues make me less of a man",
  "There's always someone doing better than me",
  "I don't have the right background or education",
  "I've wasted too many years already",
];

class Trigger {
  final String name;
  final String desc;
  const Trigger({required this.name, required this.desc});
}

const List<Trigger> kDailyTriggers = [
  Trigger(name: 'Procrastination', desc: 'Putting things off creates a build-up of pressure that feeds the anxiety.'),
  Trigger(name: 'Comparison', desc: 'Measuring yourself against others — what they have, what they\'ve achieved, how they look.'),
  Trigger(name: 'Jumping to conclusions', desc: 'Assuming the worst without evidence. The brain filling in gaps with fear.'),
  Trigger(name: 'Worrying what others think', desc: 'Living your life based on how you think you\'re being judged.'),
  Trigger(name: 'Lack of personal direction', desc: 'No clear picture of where you\'re going or why.'),
  Trigger(name: 'Unfinished projects', desc: 'Things started but never completed — they sit in the background draining energy.'),
  Trigger(name: 'Disorganised', desc: 'Chaos in your environment or schedule creates chaos in your head.'),
  Trigger(name: 'Hiding from fears', desc: 'Avoiding the thing rather than confronting it. The avoidance becomes its own problem.'),
  Trigger(name: 'Feeling overwhelmed', desc: 'Too much on, no way to see clearly, no obvious first step.'),
  Trigger(name: 'External influences', desc: 'Things outside your control that knock your mood or confidence.'),
];

const List<Trigger> kSpecificTriggers = [
  Trigger(name: 'Alcohol', desc: 'Alcohol disrupts sleep and mood regulation, increasing anxiety the next day.'),
  Trigger(name: 'Poor sleep', desc: 'Sleep deprivation amplifies emotional responses and reduces resilience.'),
  Trigger(name: 'Allergies', desc: 'Some physical allergic responses can mimic or trigger anxiety symptoms.'),
  Trigger(name: 'Diet & nutrition', desc: 'Blood sugar crashes and poor nutrition directly impact mood and anxiety.'),
];

// ── QUESTIONS ──
class QuestionOption {
  final String text;
  final String profile; // ANXIETY | BURNOUT | OVERWHELM | ALL
  const QuestionOption({required this.text, required this.profile});
}

const List<QuestionOption> kQ1Options = [
  QuestionOption(text: "The head's constantly going — I can't switch it off", profile: 'ANXIETY'),
  QuestionOption(text: "I wake up dreading the day and don't know why", profile: 'ANXIETY'),
  QuestionOption(text: "I'm completely wiped out — nothing left to give", profile: 'BURNOUT'),
  QuestionOption(text: "I've lost all motivation — just going through the motions", profile: 'BURNOUT'),
  QuestionOption(text: "Too much going on — I can't see the wood for the trees", profile: 'OVERWHELM'),
  QuestionOption(text: "I'm holding everything together but something's got to give", profile: 'OVERWHELM'),
];

const Map<String, List<String>> kQ2Options = {
  'ANXIETY': [
    'Recently — something\'s triggered it and it hasn\'t stopped',
    'Last year or two — it\'s been creeping up on me',
    'Years — I\'ve managed it but it\'s getting worse',
    'Always been there — it\'s just part of who I am, going back to when I was young',
  ],
  'BURNOUT': [
    'Recently — hit a wall out of nowhere',
    'Last year or two — it\'s been grinding me down',
    'Years — I\'ve been running on empty for longer than I can remember',
    'Always — I\'ve never really known what it feels like to not be exhausted',
  ],
  'OVERWHELM': [
    'Recently — something changed and now everything feels unmanageable',
    'Last year or two — it\'s been stacking up bit by bit',
    'Years — I\'ve just kept adding more and never taken anything away',
    'Always — I\'ve always taken on too much, it\'s just what I do',
  ],
};

const List<String> kQ3Options = [
  'Keep Busy — work, gym, whatever fills the time',
  'Avoid it — I don\'t do the things that trigger it',
  'Numb it — drink, food, TV, scrolling',
  'Push Through — just get on with it and hope it passes',
  'Nothing — I let it build up',
];

const Map<String, List<String>> kQ4Options = {
  'ANXIETY': [
    'Quiet head — less noise, better sleep, able to actually switch off',
    'More confidence — stop second-guessing every decision I make',
    'Stop avoiding things — I want my life back, not a smaller version of it',
    'Better relationships — stop snapping at the wrong people',
    'Just feel normal — not on edge all the time',
  ],
  'BURNOUT': [
    'Energy back — to actually want to get up in the morning',
    'Feel like myself again — I don\'t know when that version of me left',
    'Better relationships — to actually show up for the people around me',
    'Direction — something to work toward that actually means something',
    'Just stop — to rest without feeling guilty about it',
  ],
  'OVERWHELM': [
    'Clarity — to know what actually matters and let the rest go',
    'Control — to feel like I\'m steering my life instead of just surviving it',
    'Space — headspace, time, breathing room — just less',
    'Better relationships — to stop being distracted and actually be present',
    'Direction — to feel like I\'m moving forward instead of just treading water',
  ],
};

// ── PROFILE COPY ──
class ProfileData {
  final String type;
  final String headline;
  final String summary;
  final String recognition;
  final String belief;
  final String beliefSub;
  const ProfileData({
    required this.type, required this.headline, required this.summary,
    required this.recognition, required this.belief, required this.beliefSub,
  });
}

const Map<String, ProfileData> kProfiles = {
  'ANXIETY': ProfileData(
    type: 'ANXIETY',
    headline: 'Anxiety.',
    summary: 'The head never fully switches off. Something\'s always running in the background.',
    recognition: 'You\'re not anxious because something\'s wrong with you. You\'re anxious because your brain has learned to stay on alert — and it\'s never been shown how to switch off. That ends here.',
    belief: '"I can\'t relax or everything will fall apart."',
    beliefSub: 'This is the belief underneath most male anxiety. And it\'s not true.',
  ),
  'BURNOUT': ProfileData(
    type: 'BURNOUT',
    headline: 'Burnout.',
    summary: 'The tank\'s been running on empty for a while. You\'re still going — but only just.',
    recognition: 'Burnout isn\'t laziness. It\'s what happens when you give everything to everyone else and leave nothing for yourself. The version of you that used to have energy is still in there — it just needs the right conditions to come back.',
    belief: '"I don\'t deserve to rest."',
    beliefSub: 'This is what keeps burnout going. Rest isn\'t a reward — it\'s a requirement.',
  ),
  'OVERWHELM': ProfileData(
    type: 'OVERWHELM',
    headline: 'Overwhelm.',
    summary: 'Too much on, no way to see clearly. Everything feels urgent and nothing feels manageable.',
    recognition: 'Overwhelm isn\'t a sign you\'re weak or disorganised. It\'s a sign you\'ve taken on more than any one person should. The first step isn\'t doing more — it\'s getting clear on what actually matters.',
    belief: '"I have to hold everything together — no one else will."',
    beliefSub: 'This belief is exhausting you. And it\'s not entirely true.',
  ),
};

// ── TOOLS ──
class ToolStep {
  final String title;
  final String body;
  const ToolStep({required this.title, required this.body});
}

class ToolData {
  final String key;
  final String title;
  final String intro;
  final List<ToolStep> steps;
  final bool isWorksheet;
  final String icon;
  final String weekLabel;
  final String desc;
  const ToolData({
    required this.key, required this.title, required this.intro,
    required this.steps, required this.icon, required this.weekLabel,
    required this.desc, this.isWorksheet = false,
  });
}

const List<ToolData> kTools = [
  ToolData(
    key: 'enquiry', icon: '🔍', weekLabel: 'Week 1', isWorksheet: true,
    title: 'Self Enquiry',
    desc: 'Separate what\'s real from what\'s perceived. The thoughts running your anxiety — are they facts or stories?',
    intro: 'When you\'re below a 7 on the happiness scale, reach for this tool. Self-enquiry is how you become conscious of the subconscious — how you take the thoughts that are running the show and hold them up to the light to see if they\'re actually real.',
    steps: [
      ToolStep(title: 'Name the stressful thought', body: 'Write down exactly what\'s going through your mind. Don\'t dress it up. Don\'t make it sound better than it is. The raw version is the one you need to work with.'),
      ToolStep(title: 'True or Perceived?', body: 'Is this thought based on facts, or on what you fear might happen? A genuine mistake at work is true. Assuming your mate is annoyed with you because he didn\'t text back — that\'s perceived.'),
      ToolStep(title: 'For TRUE thoughts — problem solve', body: 'What can you learn from this? What can you do differently? What\'s the end goal you\'re trying to reach? Get back to that goal and work forward from there.'),
      ToolStep(title: 'For PERCEIVED thoughts — challenge and reframe', body: 'Ask yourself: who would I be without this thought? What would I actually be doing right now if I didn\'t have it? Then reframe it into a positive goal you can move towards.'),
    ],
  ),
  ToolData(
    key: 'unwire', icon: '⚡', weekLabel: 'Week 2', isWorksheet: true,
    title: 'Unwire The Thought',
    desc: 'Break the thought pattern before it spirals. Once you\'ve identified the thoughts — this is how you stop them running the show.',
    intro: 'Your beliefs aren\'t facts. They\'re patterns that got wired in — by experiences, by things people said, by what you told yourself when something went wrong. This tool is how you start unwiring them.',
    steps: [
      ToolStep(title: 'Identify the belief', body: 'Which of your selected beliefs is most active right now? Name it clearly. Don\'t soften it — the exact wording matters.'),
      ToolStep(title: 'Where did it come from?', body: 'Think back. When did you first start believing this? Was it something that happened, something someone said, a pattern that repeated? You don\'t need all the answers — just start looking.'),
      ToolStep(title: 'Is it actually true?', body: 'Not "does it feel true" — is it objectively, provably, factually true? Write down three pieces of evidence that contradict this belief. They exist. Find them.'),
      ToolStep(title: 'Replace it', body: 'Write a new belief that\'s realistic, forward-facing, and yours. Not an affirmation — a genuine replacement. Something you can actually start to believe with work.'),
    ],
  ),
  ToolData(
    key: 'reframe', icon: '🔄', weekLabel: 'Week 3', isWorksheet: true,
    title: 'Reframing',
    desc: 'Turn the stuck thought into a forward-facing one. Reframing isn\'t denial — it\'s redirecting your energy from the problem to the goal.',
    intro: 'Anxiety loves a fixed, negative narrative. Reframing doesn\'t mean pretending everything\'s fine — it means refusing to let a fear-based thought have the final word.',
    steps: [
      ToolStep(title: 'Write the stuck thought down', body: 'The thought that\'s been going round and round. Get it out of your head and onto paper exactly as it sounds in your mind — no editing.'),
      ToolStep(title: 'Is it a fact or a story?', body: 'Ask yourself brutally honestly: is this provably true, or is it a story I\'ve been telling myself? Most anxiety lives in the story, not the facts.'),
      ToolStep(title: 'Find the reframe', body: '"I always fail" becomes "What do I need to succeed this time?" The reframe doesn\'t deny the feeling — it redirects the energy.'),
      ToolStep(title: 'Make it actionable', body: 'Write down one thing you can do today that moves you towards the reframe. Small movement beats perfect stillness every time.'),
    ],
  ),
  ToolData(
    key: 'problem', icon: '🎯', weekLabel: 'Week 4', isWorksheet: true,
    title: 'Problem Solve',
    desc: 'Strip the emotion out and replace it with clarity. Three steps. Simple enough to use in the thick of it.',
    intro: 'When you\'re stuck in a problem, you\'re usually stuck in the emotion of the problem. This tool strips the emotion out and replaces it with clarity.',
    steps: [
      ToolStep(title: 'Write the problem out fully', body: 'Don\'t edit yourself. Get everything about the problem onto paper — the facts, the feelings, the fears. Only when it\'s out of your head can you actually work on it.'),
      ToolStep(title: 'Define what \'solved\' looks like', body: 'What\'s the best case scenario? Be specific. Not "things would be better" — what exactly would be different? This becomes your north star.'),
      ToolStep(title: 'Find three actions you can take today', body: 'Not eventually. Not next week. Right now. What can you actually do today to move towards solved? Start with the smallest one.'),
      ToolStep(title: 'Do the first action immediately', body: 'Do the smallest action within the next 15 minutes of completing this tool. Even a tiny action changes your state.'),
    ],
  ),
  ToolData(
    key: 'productivity', icon: '🚀', weekLabel: 'Week 5',
    title: 'Productivity Superpower',
    desc: 'A cluttered mind creates a cluttered life. This system gets everything out of your head and onto paper.',
    intro: 'A cluttered mind creates a cluttered life. This system gets everything out of your head and onto paper — so your mind can actually rest.',
    steps: [
      ToolStep(title: 'Do a full brain dump', body: 'Write down everything that\'s in your head — tasks, worries, ideas, commitments. Everything. Don\'t filter it. Don\'t organise it yet. Just get it all out.'),
      ToolStep(title: 'Sort into categories', body: 'Now go through your list. Each item is either: Do it today. Schedule it. Delegate it. Delete it. Nothing stays in the "think about later" pile.'),
      ToolStep(title: 'Pick your three', body: 'From your "do it today" list, pick the three most important things. Just three. Everything else moves to tomorrow\'s list.'),
      ToolStep(title: 'Protect the time', body: 'Block out specific time in your day for those three things. Not "when I get a chance" — actual time. Treat it like an appointment you can\'t miss.'),
    ],
  ),
  ToolData(
    key: 'thoughtdiary', icon: '📓', weekLabel: 'Daily · runs throughout',
    title: 'Thought Diary',
    desc: '5 minutes every night. Score your day, write what happened, name the heaviest thought.',
    intro: 'Every night before bed, 5 minutes. Score your day, write what happened, name the thought that\'s sitting heaviest. Do it for 7 nights and you\'ll see your week in a way you never have before.',
    steps: [
      ToolStep(title: 'Every night before bed', body: 'Even on the days when everything was fine, you still fill it in. The good entries are just as important as the bad ones.'),
      ToolStep(title: 'Score your day 1–10', body: 'Your gut number. Don\'t overthink it. Then write 2–3 honest sentences — what happened, what you felt, what shaped the day.'),
      ToolStep(title: 'Name the heaviest thought', body: 'What\'s the one thing that\'s sitting with you as you go to sleep? Write it down. Getting it on paper breaks the loop.'),
      ToolStep(title: 'Weekly review', body: 'Every Sunday, look at your 7 scores together. Which days were low? What triggered the dips? This is your intel.'),
    ],
  ),
  ToolData(
    key: 'bullying', icon: '🛡', weekLabel: 'Suggested from your timeline',
    title: 'Heal From Childhood Bullying',
    desc: 'If you flagged this in your timeline — this is where you work through it.',
    intro: 'If you were bullied as a kid, you know it didn\'t stay in the playground. Healing it isn\'t about forgiving the bully. It\'s about reclaiming the version of you they tried to take.',
    steps: [
      ToolStep(title: 'Acknowledge it — fully', body: 'Stop minimising it. It happened. It wasn\'t okay. And it wasn\'t your fault. You can\'t begin to heal something you\'re still pretending was fine.'),
      ToolStep(title: 'Understand what they were doing', body: 'Bullies deflect their own pain. They chose you because you were available — not because of something wrong with you.'),
      ToolStep(title: 'Write your real strengths', body: 'What are you actually good at? This isn\'t arrogance — this is reclaiming your truth from the lies they planted.'),
      ToolStep(title: 'Be patient with yourself', body: 'One day you\'ll realise the voice in your head has changed — and that\'s because of the quiet, consistent work you\'re doing now.'),
    ],
  ),
];

ToolData? getToolByKey(String key) {
  try {
    return kTools.firstWhere((t) => t.key == key);
  } catch (_) {
    return null;
  }
}
