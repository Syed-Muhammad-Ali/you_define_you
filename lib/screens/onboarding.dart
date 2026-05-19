import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/api_config.dart';
import '../theme/theme.dart';
import '../models/app_state.dart';
import '../widgets/widgets.dart';
import '../data/data.dart';

// ═══════════════════════════════════════
//  SCREEN 1: WELCOME
// ═══════════════════════════════════════
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> _openLandingPage(BuildContext context) async {
    final uri = Uri.parse(kLandingPageUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open the landing page right now. Please try again shortly.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YDYColors.black,
      body: Stack(
        children: [
          // Orange glow
          Positioned(
            right: -60, top: MediaQuery.of(context).size.height * 0.25,
            child: const OrangeGlow(size: 280),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TOP: Brand
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 40, 28, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('YOU', style: YDYTypography.bebasNeue(fontSize: 80, color: YDYColors.white, height: 0.9)),
                        Text('DEFINE', style: YDYTypography.bebasNeue(fontSize: 80, color: YDYColors.orange, height: 0.9)),
                        Text('YOU.', style: YDYTypography.bebasNeue(fontSize: 80, color: YDYColors.white, height: 0.9)),
                        const SizedBox(height: 20),
                        Text(
                          'The You Define You Mindset Method.\nBuilt for men who are ready to stop going round the same circle.',
                          style: YDYTypography.dmSans(fontSize: 14, color: YDYColors.muted, fontWeight: FontWeight.w300, height: 1.65),
                        ),
                      ],
                    ),
                  ),
                ),
                // BOTTOM: Statement + CTA
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 0, 28, 48),
                  child: Column(
                    children: [
                      BorderStatement(
                        "If you've landed here, something's been eating at you.\n\nMaybe you don't even know what it is. That's exactly the right place to start.",
                      ),
                      const SizedBox(height: 24),
                      YDYButton(
                        label: "I'M READY — LET'S GO →",
                        onTap: () => _openLandingPage(context),
                      ),
                      const SizedBox(height: 10),
                      YDYGhostButton(
                        label: "I already have an account",
                        onTap: () => Navigator.pushNamed(context, '/signin'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════
//  SCREEN 2: ACKNOWLEDGE
// ═══════════════════════════════════════
class AcknowledgeScreen extends StatefulWidget {
  const AcknowledgeScreen({super.key});

  @override
  State<AcknowledgeScreen> createState() => _AcknowledgeScreenState();
}

class _AcknowledgeScreenState extends State<AcknowledgeScreen> {
  int? _selected;

  final List<String> _statements = [
    "You're holding it together on the outside but it's a different story in your head.",
    "You wake up anxious and don't fully know why. You just do.",
    "You're doing everything for everyone else and running on empty.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YDYColors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Before we start', style: YDYTypography.dmSans(fontSize: 12, color: YDYColors.orange, letterSpacing: 1.5)),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: YDYTypography.bebasNeue(fontSize: 44, color: YDYColors.white),
                      children: [
                        const TextSpan(text: "What's going "),
                        TextSpan(text: "on?", style: YDYTypography.bebasNeue(fontSize: 44, color: YDYColors.orange)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the answer that fits you. No wrong answers. Nobody\'s watching.',
                    style: YDYTypography.dmSans(fontSize: 13, color: YDYColors.muted, fontWeight: FontWeight.w300, height: 1.65),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _statements.length,
                itemBuilder: (context, i) {
                  final selected = _selected == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selected = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: selected ? YDYColors.orangeDim : YDYColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: selected ? YDYColors.orange : YDYColors.border, width: selected ? 1.5 : 1),
                      ),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 22, height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selected ? YDYColors.orange : Colors.transparent,
                              border: Border.all(color: selected ? YDYColors.orange : YDYColors.muted),
                            ),
                            child: selected ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              _statements[i],
                              style: YDYTypography.dmSans(fontSize: 14, color: selected ? YDYColors.white : YDYColors.muted, fontWeight: FontWeight.w300, height: 1.55),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Text(
                'Nothing you tick here goes anywhere. This is just between you and the app.',
                style: YDYTypography.dmSans(fontSize: 12, color: YDYColors.muted, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
              child: YDYButton(
                label: "LET'S KEEP GOING →",
                onTap: () => Navigator.pushNamed(context, '/questions'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════
//  SCREEN 3: 5 QUESTIONS
// ═══════════════════════════════════════
class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  int _currentQ = 1;
  String? _profile;
  final Map<String, String> _answers = {};
  final _q5Controller = TextEditingController();
  final PageController _pageController = PageController();

  bool get _canProceed {
    if (_currentQ == 5) return true;
    return _answers.containsKey('q$_currentQ');
  }

  void _selectOption(String qKey, String value, {String? profile}) {
    setState(() {
      _answers[qKey] = value;
      if (profile != null) _profile = profile;
    });
  }

  void _next() {
    if (_currentQ < 5) {
      setState(() => _currentQ++);
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      final appState = context.read<AppState>();
      appState.setProfile(_profile ?? 'ANXIETY');
      _answers.forEach((k, v) => appState.setAnswer(k, v));
      Navigator.pushNamed(context, '/profile');
    }
  }

  List<String> get _q2Options => kQ2Options[_profile ?? 'ANXIETY'] ?? kQ2Options['ANXIETY']!;
  List<String> get _q4Options => kQ4Options[_profile ?? 'ANXIETY'] ?? kQ4Options['ANXIETY']!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YDYColors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Progress dots
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                children: [
                  Text('Getting to know you', style: YDYTypography.dmSans(fontSize: 12, color: YDYColors.muted)),
                  const Spacer(),
                  Row(
                    children: List.generate(5, (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(left: 6),
                      width: _currentQ == i + 1 ? 20 : 8, height: 8,
                      decoration: BoxDecoration(
                        color: i < _currentQ ? YDYColors.orange : YDYColors.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Questions
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildQ1(),
                  _buildQ2(),
                  _buildQ3(),
                  _buildQ4(),
                  _buildQ5(),
                ],
              ),
            ),
            // Next button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
              child: YDYButton(
                label: _currentQ == 5 ? "SEE MY PROFILE →" : "LET'S KEEP GOING →",
                enabled: _canProceed,
                onTap: _canProceed ? _next : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQShell(int qNum, String question, String highlight, String sub, Widget options) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Question $qNum of 5', style: YDYTypography.dmSans(fontSize: 12, color: YDYColors.orange)),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: YDYTypography.bebasNeue(fontSize: 36, color: YDYColors.white),
              children: question.contains(highlight)
                  ? [
                      TextSpan(text: question.split(highlight)[0]),
                      TextSpan(text: highlight, style: YDYTypography.bebasNeue(fontSize: 36, color: YDYColors.orange)),
                      TextSpan(text: question.split(highlight)[1]),
                    ]
                  : [TextSpan(text: question)],
            ),
          ),
          const SizedBox(height: 6),
          Text(sub, style: YDYTypography.dmSans(fontSize: 13, color: YDYColors.muted, fontWeight: FontWeight.w300)),
          const SizedBox(height: 20),
          options,
        ],
      ),
    );
  }

  Widget _buildQ1() => _buildQShell(1, "What's been going on for you?", 'going on', 'Pick the one that speaks to you the most.',
    Column(children: kQ1Options.map((o) => OptionTile(
      text: o.text,
      selected: _answers['q1'] == o.text,
      onTap: () => _selectOption('q1', o.text, profile: o.profile),
    )).toList()),
  );

  Widget _buildQ2() => _buildQShell(2, "When did this start?", 'start', 'Most men find it goes back further than they think.',
    Column(children: _q2Options.map((o) => OptionTile(
      text: o, selected: _answers['q2'] == o,
      onTap: () => _selectOption('q2', o),
    )).toList()),
  );

  Widget _buildQ3() => _buildQShell(3, "What do you do to manage it?", 'manage', 'No judgment. This is just where most men end up.',
    Column(children: kQ3Options.map((o) => OptionTile(
      text: o, selected: _answers['q3'] == o,
      onTap: () => _selectOption('q3', o),
    )).toList()),
  );

  Widget _buildQ4() => _buildQShell(4, "How do you want to feel?", 'want', 'What will make you feel you again?',
    Column(children: _q4Options.map((o) => OptionTile(
      text: o, selected: _answers['q4'] == o,
      onTap: () => _selectOption('q4', o),
    )).toList()),
  );

  Widget _buildQ5() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Question 5 of 5', style: YDYTypography.dmSans(fontSize: 12, color: YDYColors.orange)),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: YDYTypography.bebasNeue(fontSize: 36, color: YDYColors.white),
              children: [
                const TextSpan(text: "Do you need to get "),
                TextSpan(text: 'anything', style: YDYTypography.bebasNeue(fontSize: 36, color: YDYColors.orange)),
                const TextSpan(text: " off your chest?"),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text("You don't have to. But if you want to — write it here. Just for you.", style: YDYTypography.dmSans(fontSize: 13, color: YDYColors.muted, fontWeight: FontWeight.w300)),
          const SizedBox(height: 20),
          TextField(
            controller: _q5Controller,
            maxLines: 6,
            style: YDYTypography.dmSans(fontSize: 14, color: YDYColors.white),
            decoration: const InputDecoration(hintText: "Nobody else sees this. Just say it."),
            onChanged: (v) => setState(() => _answers['q5'] = v),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════
//  SCREEN 4: PROFILE REVEAL
// ═══════════════════════════════════════
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: YDYTypography.dmSans(fontSize: 11, color: YDYColors.muted, letterSpacing: 1.2)),
          const SizedBox(height: 2),
          Text(value.isNotEmpty ? value : 'Not provided yet', style: YDYTypography.dmSans(fontSize: 15, color: YDYColors.white, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final planTitle = appState.planName.isNotEmpty ? appState.planName : 'Standard · 3 months';
    final planPrice = appState.planPriceLabel.isNotEmpty ? appState.planPriceLabel : '£60 total + month 4 free';
    final fullName = '${appState.firstName} ${appState.lastName}'.trim();

    return Scaffold(
      backgroundColor: YDYColors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('YOU DEFINE YOU MEMBER', style: YDYTypography.dmSans(fontSize: 12, color: YDYColors.orange, letterSpacing: 1.8)),
                        const SizedBox(height: 6),
                        Text('Profile', style: YDYTypography.bebasNeue(fontSize: 36, color: YDYColors.white)),
                        if (fullName.isNotEmpty)
                          Text(fullName, style: YDYTypography.dmSans(fontSize: 14, color: YDYColors.muted)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: YDYColors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    YDYCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Account info', style: YDYTypography.dmSans(fontSize: 13, color: YDYColors.orange)),
                          const SizedBox(height: 16),
                          _detailRow('First name', appState.firstName),
                          _detailRow('Last name', appState.lastName),
                          _detailRow('Email', appState.userEmail),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    YDYCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Current plan', style: YDYTypography.dmSans(fontSize: 13, color: YDYColors.orange)),
                          const SizedBox(height: 12),
                          _detailRow('Plan', planTitle),
                          _detailRow('Pricing', planPrice),
                          const SizedBox(height: 10),
                          Text(
                            'The plan you selected ($planTitle) is tied to your profile. '
                            'Keep using the same email + password inside the app to keep your progress synced.',
                            style: YDYTypography.dmSans(fontSize: 13, color: YDYColors.muted, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 54,
                      child: YDYButton(
                        label: 'Log out',
                        onTap: () async {
                          await appState.signOut();
                          if (context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: Text(
                        'Email the team if you need help resetting your password or recovering access.',
                        style: YDYTypography.dmSans(fontSize: 12, color: YDYColors.muted, height: 1.4),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════
//  SCREEN 5: COMMIT / NAME
// ═══════════════════════════════════════
class CommitScreen extends StatefulWidget {
  const CommitScreen({super.key});

  @override
  State<CommitScreen> createState() => _CommitScreenState();
}

class _CommitScreenState extends State<CommitScreen> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final canStart = _nameController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: YDYColors.black,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('One last thing', style: YDYTypography.dmSans(fontSize: 12, color: YDYColors.orange, letterSpacing: 1.5)),
                    const SizedBox(height: 12),
                    RichText(
                      text: TextSpan(
                        style: YDYTypography.bebasNeue(fontSize: 52, color: YDYColors.white, height: 1.05),
                        children: [
                          const TextSpan(text: "You're\nnot "),
                          TextSpan(text: "broken.", style: YDYTypography.bebasNeue(fontSize: 52, color: YDYColors.orange)),
                          const TextSpan(text: "\nNot even\nclose."),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...([
                      "You've already done the hard bit — you showed up and said something's not right.",
                      "Everything from here is tools, not therapy. Practical. Yours to keep.",
                      "The You Define You Mindset Method works. But only if you put the work in.",
                    ].map((s) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 6, height: 6,
                            decoration: const BoxDecoration(color: YDYColors.orange, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(s, style: YDYTypography.dmSans(fontSize: 14, color: YDYColors.white, fontWeight: FontWeight.w300, height: 1.6))),
                        ],
                      ),
                    ))),
                    const SizedBox(height: 28),
                    Text('What do we call you?', style: YDYTypography.dmSans(fontSize: 13, color: YDYColors.muted)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      autofocus: false,
                      textCapitalization: TextCapitalization.words,
                      style: YDYTypography.dmSans(fontSize: 16, color: YDYColors.white),
                      decoration: const InputDecoration(hintText: 'First name'),
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
              child: YDYButton(
                label: "LET'S BUILD SOMETHING →",
                enabled: canStart,
                onTap: canStart ? () {
                  context.read<AppState>().setUserName(_nameController.text.trim());
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
                } : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
