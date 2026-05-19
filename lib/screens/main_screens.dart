import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme.dart';
import '../models/app_state.dart';
import '../widgets/widgets.dart';
import '../data/data.dart';

// ═══════════════════════════════════════
//  HOME / DASHBOARD SCREEN
// ═══════════════════════════════════════
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final name = appState.userName.isEmpty ? 'Mate' : appState.userName;

    return Scaffold(
      backgroundColor: YDYColors.black,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good to have you here,', style: YDYTypography.dmSans(fontSize: 13, color: YDYColors.muted, fontWeight: FontWeight.w300)),
                        Text('$name.', style: YDYTypography.bebasNeue(fontSize: 36, color: YDYColors.white)),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/profile'),
                      child: Tooltip(
                        message: 'Profile',
                        child: Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [YDYColors.orange, Color(0xFFC94F1F)],
                              begin: Alignment.topLeft, end: Alignment.bottomRight,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text('YDY', style: YDYTypography.bebasNeue(fontSize: 13, color: Colors.white, letterSpacing: 1)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Coach message card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: YDYCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('FROM THE YOU DEFINE YOU MINDSET METHOD', style: YDYTypography.dmSans(fontSize: 10, color: YDYColors.orange, letterSpacing: 1.2)),
                      const SizedBox(height: 10),
                      Text(
                        "Right, you're in. That took something — most men don't get this far. Now we get to work.\n\nStart with what I've matched you with below. Do it now, while it's fresh. Five minutes. That's all it takes to get moving.",
                        style: YDYTypography.dmSans(fontSize: 14, color: YDYColors.white, fontWeight: FontWeight.w300, height: 1.65),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/coach'),
                        child: Text('→ Talk to your coach', style: YDYTypography.dmSans(fontSize: 13, color: YDYColors.orange, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Foundation section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionLabel('Foundation Work'),
                    if (!appState.foundationComplete)
                      YDYCard(
                        onTap: () => Navigator.pushNamed(context, '/foundation'),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('📋', style: TextStyle(fontSize: 24)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Before The Tools Come The Foundations', style: YDYTypography.dmSans(fontSize: 14, color: YDYColors.white, fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 4),
                                      Text('Complete 4 steps to unlock your tools', style: YDYTypography.dmSans(fontSize: 12, color: YDYColors.muted)),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios, color: YDYColors.orange, size: 16),
                              ],
                            ),
                            const SizedBox(height: 14),
                            YDYProgressBar(
                              progress: appState.foundationProgress / 4,
                              label: 'Progress',
                              rightLabel: '${appState.foundationProgress} of 4 complete',
                            ),
                          ],
                        ),
                      )
                    else
                      YDYCard(
                        color: YDYColors.orangeDim,
                        child: Row(
                          children: [
                            const Text('🔓', style: TextStyle(fontSize: 24)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Foundation complete. Your tools are unlocked.',
                                style: YDYTypography.dmSans(fontSize: 14, color: YDYColors.white, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Tools section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: const SectionLabel('Your Tools'),
              ),
            ),

            if (!appState.foundationComplete)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: YDYCard(
                    child: Column(
                      children: [
                        const Text('🔒', style: TextStyle(fontSize: 32)),
                        const SizedBox(height: 8),
                        Text('Tools Locked', style: YDYTypography.bebasNeue(fontSize: 22, color: YDYColors.white)),
                        const SizedBox(height: 6),
                        Text(
                          'Complete all 4 foundation steps to unlock your matched tools. This work is the reason the tools actually work.',
                          style: YDYTypography.dmSans(fontSize: 13, color: YDYColors.muted, height: 1.55),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    if (i >= kTools.length) return null;
                    final tool = kTools[i];
                    final toolNum = i + 1;
                    final isComplete = appState.completedTools.contains(toolNum);
                    final isUnlocked = appState.isToolUnlocked(toolNum);
                    final isCurrent = appState.currentTool == toolNum;

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
                      child: _ToolSequenceCard(
                        tool: tool,
                        toolNum: toolNum,
                        isComplete: isComplete,
                        isUnlocked: isUnlocked,
                        isCurrent: isCurrent,
                        onTap: isUnlocked ? () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => ToolSheet(tool: tool, toolNum: toolNum),
                        ) : null,
                      ),
                    );
                  },
                  childCount: kTools.length,
                ),
              ),

            // Thought diary card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionLabel('Daily'),
                    YDYCard(
                      onTap: () => Navigator.pushNamed(context, '/diary'),
                      child: Row(
                        children: [
                          const Text('📓', style: TextStyle(fontSize: 28)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Thought Diary', style: YDYTypography.dmSans(fontSize: 15, color: YDYColors.white, fontWeight: FontWeight.w500)),
                                Text('5 mins every night before bed', style: YDYTypography.dmSans(fontSize: 12, color: YDYColors.muted)),
                              ],
                            ),
                          ),
                          Text('Open →', style: YDYTypography.dmSans(fontSize: 13, color: YDYColors.blue, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
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

class _ToolSequenceCard extends StatelessWidget {
  final ToolData tool;
  final int toolNum;
  final bool isComplete, isUnlocked, isCurrent;
  final VoidCallback? onTap;
  const _ToolSequenceCard({required this.tool, required this.toolNum, required this.isComplete, required this.isUnlocked, required this.isCurrent, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCurrent ? YDYColors.orangeDim : YDYColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isCurrent ? YDYColors.orange : YDYColors.border, width: isCurrent ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isComplete ? YDYColors.green.withOpacity(0.2)
                    : isCurrent ? YDYColors.orange
                    : YDYColors.greyLight,
              ),
              alignment: Alignment.center,
              child: isComplete
                  ? const Icon(Icons.check, color: YDYColors.green, size: 18)
                  : !isUnlocked
                      ? const Icon(Icons.lock, color: YDYColors.muted, size: 16)
                      : Text(tool.icon, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tool.title, style: YDYTypography.dmSans(fontSize: 14, color: isUnlocked ? YDYColors.white : YDYColors.muted, fontWeight: FontWeight.w500)),
                  Text(tool.weekLabel, style: YDYTypography.dmSans(fontSize: 11, color: YDYColors.orange)),
                  const SizedBox(height: 4),
                  Text(tool.desc, style: YDYTypography.dmSans(fontSize: 12, color: YDYColors.muted, height: 1.4)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isComplete ? '✓ Done' : isUnlocked ? 'Start →' : '🔒',
              style: YDYTypography.dmSans(fontSize: 13, color: isComplete ? YDYColors.green : isUnlocked ? YDYColors.orange : YDYColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════
//  TOOL BOTTOM SHEET
// ═══════════════════════════════════════
class ToolSheet extends StatelessWidget {
  final ToolData tool;
  final int toolNum;
  const ToolSheet({super.key, required this.tool, required this.toolNum});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: YDYColors.dark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40, height: 4,
                decoration: BoxDecoration(color: YDYColors.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                children: [
                  Text(tool.title, style: YDYTypography.bebasNeue(fontSize: 28, color: YDYColors.orange, letterSpacing: 1)),
                  const SizedBox(height: 12),
                  Text(tool.intro, style: YDYTypography.dmSans(fontSize: 14, color: YDYColors.muted, fontWeight: FontWeight.w300, height: 1.65)),
                  const SizedBox(height: 20),
                  ...tool.steps.asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28, height: 28,
                          decoration: BoxDecoration(
                            color: YDYColors.orangeDim,
                            shape: BoxShape.circle,
                            border: Border.all(color: YDYColors.orange.withOpacity(0.5)),
                          ),
                          alignment: Alignment.center,
                          child: Text('${e.key + 1}', style: YDYTypography.bebasNeue(fontSize: 14, color: YDYColors.orange)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.value.title, style: YDYTypography.dmSans(fontSize: 14, color: YDYColors.white, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(e.value.body, style: YDYTypography.dmSans(fontSize: 13, color: YDYColors.muted, height: 1.6, fontWeight: FontWeight.w300)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(height: 16),
                  if (toolNum > 0)
                    YDYButton(
                      label: 'MARK WEEK COMPLETE ✓',
                      onTap: () {
                        context.read<AppState>().completeTool(toolNum);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Week complete. Next tool unlocked.', style: YDYTypography.dmSans()),
                            backgroundColor: YDYColors.green,
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════
//  FOUNDATION SCREEN
// ═══════════════════════════════════════
class FoundationScreen extends StatefulWidget {
  const FoundationScreen({super.key});

  @override
  State<FoundationScreen> createState() => _FoundationScreenState();
}

class _FoundationScreenState extends State<FoundationScreen> {
  int _openStep = 0;

  void _openStep_(int step) {
    setState(() => _openStep = step);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    if (_openStep == 1) return _LifeAssessmentScreen(onBack: () => setState(() => _openStep = 0));
    if (_openStep == 2) return _LimitingBeliefsScreen(onBack: () => setState(() => _openStep = 0));
    if (_openStep == 3) return _TimelineScreen(onBack: () => setState(() => _openStep = 0));
    if (_openStep == 4) return _AnxietyChecklistScreen(onBack: () => setState(() => _openStep = 0));

    return Scaffold(
      backgroundColor: YDYColors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: YDYColors.white),
              ),
              const SizedBox(height: 24),
              Text('Foundation Work', style: YDYTypography.dmSans(fontSize: 12, color: YDYColors.orange, letterSpacing: 1.5)),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: YDYTypography.bebasNeue(fontSize: 36, color: YDYColors.white, height: 1.1),
                  children: [
                    const TextSpan(text: 'Before The Tools\nCome The '),
                    TextSpan(text: 'Foundations.', style: YDYTypography.bebasNeue(fontSize: 36, color: YDYColors.orange)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text('Complete these 4 steps in order. Your tools unlock when all 4 are done.', style: YDYTypography.dmSans(fontSize: 13, color: YDYColors.muted, height: 1.55)),
              const SizedBox(height: 20),
              YDYProgressBar(
                progress: appState.foundationProgress / 4,
                label: 'Your progress',
                rightLabel: '${appState.foundationProgress} of 4 complete',
              ),
              const SizedBox(height: 24),
              ...[
                _StepInfo(num: 1, name: 'Life Assessment', desc: 'Score 6 areas of your life out of 10 and note what\'s missing.'),
                _StepInfo(num: 2, name: 'Limiting Beliefs', desc: 'Tick the beliefs that have held you back. The ones you don\'t admit to out loud.'),
                _StepInfo(num: 3, name: 'Your Timeline', desc: 'Map the key moments in your life — high points and low points.'),
                _StepInfo(num: 4, name: 'Anxiety Checklist', desc: 'Identify which triggers show up in your life.'),
              ].asMap().entries.map((entry) {
                final step = entry.value;
                final i = entry.key;
                final done = appState.foundationCompleted[i];
                final unlocked = i == 0 || appState.foundationCompleted[i - 1];
                return GestureDetector(
                  onTap: unlocked ? () => _openStep_(step.num) : null,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: done ? YDYColors.green.withOpacity(0.1) : unlocked ? YDYColors.card : YDYColors.greyLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: done ? YDYColors.green.withOpacity(0.4) : unlocked ? YDYColors.border : YDYColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: done ? YDYColors.green.withOpacity(0.2) : unlocked ? YDYColors.orange : YDYColors.border,
                          ),
                          alignment: Alignment.center,
                          child: done
                              ? const Icon(Icons.check, color: YDYColors.green, size: 18)
                              : !unlocked
                                  ? const Icon(Icons.lock, color: YDYColors.muted, size: 16)
                                  : Text('${step.num}', style: YDYTypography.bebasNeue(fontSize: 16, color: Colors.white)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(step.name, style: YDYTypography.dmSans(fontSize: 15, color: unlocked ? YDYColors.white : YDYColors.muted, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 3),
                              Text(step.desc, style: YDYTypography.dmSans(fontSize: 12, color: YDYColors.muted, height: 1.45)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          done ? '✓ Done' : unlocked ? 'Start' : '🔒',
                          style: YDYTypography.dmSans(fontSize: 13, color: done ? YDYColors.green : unlocked ? YDYColors.orange : YDYColors.muted),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              if (appState.foundationComplete) ...[
                const SizedBox(height: 12),
                YDYCard(
                  color: YDYColors.orangeDim,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FOUNDATION COMPLETE',
                        style: YDYTypography.dmSans(
                          fontSize: 11,
                          color: YDYColors.orange,
                          letterSpacing: 1.4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You\'ve completed all 4 steps. Your dashboard and tools are now unlocked.',
                        style: YDYTypography.dmSans(
                          fontSize: 14,
                          color: YDYColors.white,
                          fontWeight: FontWeight.w400,
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 16),
                      YDYButton(
                        label: 'GO TO DASHBOARD →',
                        onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StepInfo { final int num; final String name; final String desc; const _StepInfo({required this.num, required this.name, required this.desc}); }

// ── STEP 1: LIFE ASSESSMENT ──
class _LifeAssessmentScreen extends StatelessWidget {
  final VoidCallback onBack;
  const _LifeAssessmentScreen({required this.onBack});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      backgroundColor: YDYColors.black,
      body: Column(
        children: [
          ScreenHeader(stepLabel: 'Step 1 of 4', title: 'Life Assessment', onBack: onBack),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  YDYCard(
                    child: Text(
                      'Look at each area of your life and give it an honest score out of 10. Then write a short note on what it would need to get to a 10.\n\nDon\'t overthink it — go with your gut.',
                      style: YDYTypography.dmSans(fontSize: 13, color: YDYColors.muted, height: 1.6),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...kLifeAreas.map((area) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(area, style: YDYTypography.dmSans(fontSize: 15, color: YDYColors.white, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 10),
                        ScoreDots(
                          selected: appState.lifeScores[area],
                          onSelect: (s) => appState.setLifeScore(area, s),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          style: YDYTypography.dmSans(fontSize: 13, color: YDYColors.white),
                          decoration: const InputDecoration(hintText: 'What would get this to a 10?'),
                          onChanged: (v) => appState.setLifeNote(area, v),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
            child: YDYButton(
              label: 'SUBMIT LIFE ASSESSMENT →',
              enabled: appState.step1Valid,
              onTap: appState.step1Valid ? () {
                appState.completeFoundationStep(1);
                onBack();
              } : null,
            ),
          ),
        ],
      ),
    );
  }
}

// ── STEP 2: LIMITING BELIEFS ──
class _LimitingBeliefsScreen extends StatelessWidget {
  final VoidCallback onBack;
  const _LimitingBeliefsScreen({required this.onBack});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      backgroundColor: YDYColors.black,
      body: Column(
        children: [
          ScreenHeader(stepLabel: 'Step 2 of 4', title: 'Limiting Beliefs', onBack: onBack),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  YDYCard(
                    child: Text(
                      'These are beliefs men carry without ever saying out loud. Tick the ones that have held you back — even the ones that are uncomfortable to admit.\n\nThe ones you nearly skipped past are usually the most important.',
                      style: YDYTypography.dmSans(fontSize: 12, color: YDYColors.muted, height: 1.6),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${appState.selectedBeliefs.length} selected',
                    style: YDYTypography.dmSans(fontSize: 11, color: YDYColors.orange),
                  ),
                  const SizedBox(height: 12),
                  ...kBeliefs.asMap().entries.map((e) {
                    final selected = appState.selectedBeliefs.contains(e.key);
                    return GestureDetector(
                      onTap: () => appState.toggleBelief(e.key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: selected ? YDYColors.orangeDim : YDYColors.card,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: selected ? YDYColors.orange : YDYColors.border),
                        ),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: 20, height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: selected ? YDYColors.orange : Colors.transparent,
                                border: Border.all(color: selected ? YDYColors.orange : YDYColors.muted),
                              ),
                              child: selected ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                e.value,
                                style: YDYTypography.dmSans(fontSize: 12, color: selected ? YDYColors.white : YDYColors.muted, fontWeight: FontWeight.w300, height: 1.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
            child: YDYButton(
              label: 'SUBMIT MY BELIEFS →',
              enabled: appState.step2Valid,
              onTap: appState.step2Valid ? () {
                appState.completeFoundationStep(2);
                onBack();
              } : null,
            ),
          ),
        ],
      ),
    );
  }
}

// ── STEP 3: TIMELINE ──
class _TimelineScreen extends StatefulWidget {
  final VoidCallback onBack;
  const _TimelineScreen({required this.onBack});
  @override State<_TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<_TimelineScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      backgroundColor: YDYColors.black,
      body: Column(
        children: [
          ScreenHeader(stepLabel: 'Step 3 of 4', title: 'Your Timeline', onBack: widget.onBack),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  YDYCard(
                    child: Text(
                      'List the key moments in your life — highs and lows. Aim for at least one event every other year. Don\'t skip the difficult ones. They\'re usually the most important.',
                      style: YDYTypography.dmSans(fontSize: 13, color: YDYColors.muted, height: 1.6),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...appState.timeline.asMap().entries.map((entry) {
                    final i = entry.key;
                    final event = Map<String, dynamic>.from(entry.value);
                    return _TimelineEventCard(
                      event: event,
                      onUpdate: (updated) => appState.updateTimelineEvent(i, updated),
                      onRemove: () => appState.removeTimelineEvent(i),
                    );
                  }),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => appState.addTimelineEvent({'year': '', 'event': '', 'type': null}),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: YDYColors.orange.withOpacity(0.5), style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text('+ Add another event', style: YDYTypography.dmSans(fontSize: 14, color: YDYColors.orange, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
            child: YDYButton(
              label: 'SUBMIT MY TIMELINE →',
              enabled: appState.step3Valid,
              onTap: appState.step3Valid ? () {
                appState.completeFoundationStep(3);
                widget.onBack();
              } : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineEventCard extends StatefulWidget {
  final Map<String, dynamic> event;
  final Function(Map<String, dynamic>) onUpdate;
  final VoidCallback onRemove;
  const _TimelineEventCard({required this.event, required this.onUpdate, required this.onRemove});
  @override State<_TimelineEventCard> createState() => _TimelineEventCardState();
}

class _TimelineEventCardState extends State<_TimelineEventCard> {
  late TextEditingController _yearCtrl;
  late TextEditingController _eventCtrl;

  @override
  void initState() {
    super.initState();
    _yearCtrl = TextEditingController(text: widget.event['year']?.toString() ?? '');
    _eventCtrl = TextEditingController(text: widget.event['event']?.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.event['type'];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: YDYColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: YDYColors.border)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _yearCtrl,
                  keyboardType: TextInputType.number,
                  style: YDYTypography.dmSans(fontSize: 14, color: YDYColors.white),
                  decoration: const InputDecoration(hintText: 'Year', contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                  onChanged: (v) => widget.onUpdate({...widget.event, 'year': v}),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 4,
                child: TextField(
                  controller: _eventCtrl,
                  style: YDYTypography.dmSans(fontSize: 14, color: YDYColors.white),
                  decoration: const InputDecoration(hintText: 'What happened?', contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                  onChanged: (v) => widget.onUpdate({...widget.event, 'event': v}),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: widget.onRemove,
                child: const Icon(Icons.close, color: YDYColors.muted, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _TypeBtn(label: '↑ Positive', active: type == 'pos', color: YDYColors.green, onTap: () => widget.onUpdate({...widget.event, 'type': 'pos'})),
              const SizedBox(width: 8),
              _TypeBtn(label: '↓ Negative', active: type == 'neg', color: YDYColors.red, onTap: () => widget.onUpdate({...widget.event, 'type': 'neg'})),
            ],
          ),
        ],
      ),
    );
  }
}

class _TypeBtn extends StatelessWidget {
  final String label; final bool active; final Color color; final VoidCallback onTap;
  const _TypeBtn({required this.label, required this.active, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: active ? color.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: active ? color : YDYColors.border),
      ),
      child: Text(label, style: YDYTypography.dmSans(fontSize: 13, color: active ? color : YDYColors.muted)),
    ),
  );
}

// ── STEP 4: ANXIETY CHECKLIST ──
class _AnxietyChecklistScreen extends StatelessWidget {
  final VoidCallback onBack;
  const _AnxietyChecklistScreen({required this.onBack});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      backgroundColor: YDYColors.black,
      body: Column(
        children: [
          ScreenHeader(stepLabel: 'Step 4 of 4', title: 'Anxiety Checklist', onBack: onBack),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  YDYCard(
                    child: Text(
                      'Anxiety shows up when we feel out of control or when something triggers one of our limiting beliefs. Tick everything that applies to you.\n\nNo judgment. This is just the map.',
                      style: YDYTypography.dmSans(fontSize: 13, color: YDYColors.muted, height: 1.6),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('DAILY TRIGGERS', style: YDYTypography.bebasNeue(fontSize: 14, color: YDYColors.muted, letterSpacing: 2)),
                  const SizedBox(height: 10),
                  ...kDailyTriggers.map((t) => _TriggerTile(
                    trigger: t, keyPrefix: 'daily',
                    selected: appState.selectedTriggers.contains('daily-${t.name}'),
                    onTap: () => appState.toggleTrigger('daily-${t.name}'),
                  )),
                  const SizedBox(height: 20),
                  Text('SPECIFIC TRIGGERS', style: YDYTypography.bebasNeue(fontSize: 14, color: YDYColors.muted, letterSpacing: 2)),
                  const SizedBox(height: 10),
                  ...kSpecificTriggers.map((t) => _TriggerTile(
                    trigger: t, keyPrefix: 'specific',
                    selected: appState.selectedTriggers.contains('specific-${t.name}'),
                    onTap: () => appState.toggleTrigger('specific-${t.name}'),
                  )),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
            child: YDYButton(
              label: 'SUBMIT ANXIETY CHECKLIST →',
              enabled: appState.step4Valid,
              onTap: appState.step4Valid ? () {
                appState.completeFoundationStep(4);
                onBack();
              } : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _TriggerTile extends StatelessWidget {
  final Trigger trigger; final String keyPrefix; final bool selected; final VoidCallback onTap;
  const _TriggerTile({required this.trigger, required this.keyPrefix, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: selected ? YDYColors.orangeDim : YDYColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: selected ? YDYColors.orange : YDYColors.border),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 20, height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: selected ? YDYColors.orange : Colors.transparent,
              border: Border.all(color: selected ? YDYColors.orange : YDYColors.muted),
            ),
            child: selected ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trigger.name, style: YDYTypography.dmSans(fontSize: 14, color: selected ? YDYColors.white : YDYColors.muted, fontWeight: FontWeight.w500)),
                const SizedBox(height: 3),
                Text(trigger.desc, style: YDYTypography.dmSans(fontSize: 12, color: YDYColors.muted, height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
