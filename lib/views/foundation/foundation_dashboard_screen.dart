import 'package:flutter/material.dart';

import '../../app/constants/app_content.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../controllers/app_controller.dart';
import '../../widgets/common/ydy_button.dart';
import '../../widgets/common/ydy_shell.dart';

class FoundationDashboardScreen extends StatefulWidget {
  const FoundationDashboardScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<FoundationDashboardScreen> createState() =>
      _FoundationDashboardScreenState();
}

class _FoundationDashboardScreenState extends State<FoundationDashboardScreen> {
  int? _activeStep;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        if (_activeStep != null) {
          return _FoundationStepScreen(
            controller: widget.controller,
            stepIndex: _activeStep!,
            onBack: () => setState(() => _activeStep = null),
          );
        }

        return YdyShell(
          safeBottom: false,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 40),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Foundation Work',
                      style: AppTheme.body(
                        size: 11,
                        color: AppColors.orangeBright,
                        weight: FontWeight.w500,
                      ).copyWith(letterSpacing: 2),
                    ),
                    const SizedBox(height: 8),
                    Text.rich(
                      TextSpan(
                        text: 'Before The Tools\nCome The Foundations.',
                        children: const [],
                      ),
                      style: AppTheme.bebas(
                        size: 46,
                        height: 1,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Complete these 4 steps in order. Your tools unlock when all 4 are done.',
                      style: AppTheme.body(
                        size: 13,
                        color: const Color(0xFFB07850),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.orangeBright.withValues(alpha: 0.12),
                  border: Border.all(color: AppColors.foundationBorder),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your progress',
                          style: AppTheme.body(
                            size: 11,
                            weight: FontWeight.w500,
                            color: const Color(0xFFB07850),
                          ).copyWith(letterSpacing: 1.6),
                        ),
                        Text(
                          '${widget.controller.completedFoundationCount} of 4 complete',
                          style: AppTheme.body(
                            size: 12,
                            weight: FontWeight.w500,
                            color: AppColors.orangeBright,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        minHeight: 5,
                        value: widget.controller.foundationProgress,
                        backgroundColor: AppColors.orangeBright.withValues(
                          alpha: 0.2,
                        ),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.orangeBright,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: List.generate(4, (index) {
                    final unlocked = widget.controller.isFoundationStepUnlocked(
                      index,
                    );
                    final complete =
                        widget.controller.completedFoundationSteps[index];
                    final active = unlocked && !complete;
                    final title = [
                      'Life Assessment',
                      'Limiting Beliefs',
                      'Your Timeline',
                      'Anxiety Checklist',
                    ][index];
                    final description = [
                      'Score 6 areas of your life out of 10 and note what\'s missing to get each one there.',
                      'Tick the beliefs that have held you back. The ones you don\'t admit to out loud.',
                      'Map the key moments in your life — high points and low points. This is where patterns start.',
                      'Identify which triggers show up in your life and understand what\'s behind each one.',
                    ][index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: unlocked
                            ? () => setState(() => _activeStep = index)
                            : null,
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: complete
                                ? AppColors.successDim
                                : active
                                ? AppColors.orangeBright.withValues(alpha: 0.1)
                                : AppColors.foundationGrey,
                            border: Border.all(
                              color: complete
                                  ? AppColors.success
                                  : active
                                  ? AppColors.orangeBright
                                  : AppColors.foundationBorder,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: complete
                                      ? AppColors.success
                                      : active
                                      ? AppColors.orangeBright
                                      : AppColors.foundationBorder,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  complete ? '✓' : '${index + 1}',
                                  style: AppTheme.bebas(
                                    size: complete ? 18 : 22,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: AppTheme.bebas(
                                        size: 26,
                                        color: AppColors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      description,
                                      style: AppTheme.body(
                                        size: 12,
                                        color: const Color(0xFFB07850),
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                complete
                                    ? 'Done'
                                    : unlocked
                                    ? 'Start'
                                    : 'Locked',
                                style: AppTheme.body(
                                  size: 10,
                                  weight: FontWeight.w600,
                                  color: complete
                                      ? AppColors.success
                                      : unlocked
                                      ? AppColors.orangeBright
                                      : const Color(0xFFB07850),
                                ).copyWith(letterSpacing: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 10),
                child: Text(
                  'Your Tools',
                  style: AppTheme.body(
                    size: 11,
                    weight: FontWeight.w500,
                    color: const Color(0xFFB07850),
                  ).copyWith(letterSpacing: 2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: widget.controller.completedFoundationCount == 4
                        ? AppColors.successDim
                        : AppColors.foundationGrey,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: widget.controller.completedFoundationCount == 4
                          ? AppColors.success
                          : AppColors.foundationBorder,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.controller.completedFoundationCount == 4
                            ? '🔓'
                            : '🔒',
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.controller.completedFoundationCount == 4
                            ? 'Tools Unlocked'
                            : 'Tools Locked',
                        style: AppTheme.bebas(
                          size: 28,
                          color: widget.controller.completedFoundationCount == 4
                              ? AppColors.success
                              : const Color(0xFFB07850),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.controller.completedFoundationCount == 4
                            ? 'Foundation complete. Your matched tools are now unlocked and ready to use.'
                            : 'Complete all 4 foundation steps to unlock your matched tools. This work is the reason the tools actually work.',
                        textAlign: TextAlign.center,
                        style: AppTheme.body(
                          size: 12,
                          color: widget.controller.completedFoundationCount == 4
                              ? AppColors.white
                              : const Color(0xFFB07850),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _DailyToolsSection(controller: widget.controller),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: OutlinedButton(
                  onPressed: widget.controller.resetApp,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: AppColors.white.withValues(alpha: 0.1),
                    ),
                    foregroundColor: AppColors.deepDimText,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Reset app',
                    style: AppTheme.body(
                      size: 12,
                      color: AppColors.deepDimText,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DailyToolsSection extends StatelessWidget {
  const _DailyToolsSection({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF0F0F1A), const Color(0xFF1A0F0F)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.orange.withValues(alpha: 0.25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('🆘', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('In The Moment', style: AppTheme.bebas(size: 30)),
                      Text(
                        'Anxiety hitting hard right now? Use these first.',
                        style: AppTheme.body(
                          size: 11,
                          color: AppColors.orange,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'When the anxiety is live — when your chest is tight, your head is going, you can\'t think straight — the tools aren\'t what you need. These are.',
                style: AppTheme.body(size: 12, color: AppColors.deepDimText),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  _MiniToolChip(label: 'Box Breathing'),
                  _MiniToolChip(label: 'EFT Tapping'),
                  _MiniToolChip(label: 'Cold Water'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text('Thought Diary', style: AppTheme.bebas(size: 30)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF161B22),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.blue.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '5 minutes every night before bed.',
                style: AppTheme.body(
                  size: 13,
                  weight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Score your day, write what happened, name the heaviest thought. After 7 days you\'ll see patterns you couldn\'t see before.',
                style: AppTheme.body(size: 12, color: AppColors.deepDimText),
              ),
              const SizedBox(height: 14),
              YdyButton(
                label: controller.todayDiaryEntry == null
                    ? 'Add tonight\'s entry →'
                    : 'Update tonight\'s entry →',
                onPressed: () async {
                  await showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: AppColors.dark,
                    builder: (context) =>
                        _DiaryBottomSheet(controller: controller),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniToolChip extends StatelessWidget {
  const _MiniToolChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: AppTheme.body(
          size: 12,
          color: AppColors.white,
          weight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _FoundationStepScreen extends StatelessWidget {
  const _FoundationStepScreen({
    required this.controller,
    required this.stepIndex,
    required this.onBack,
  });

  final AppController controller;
  final int stepIndex;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return YdyShell(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 14),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onBack,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.foundationGrey,
                      border: Border.all(color: AppColors.foundationBorder),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.arrow_back,
                      size: 18,
                      color: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Step ${stepIndex + 1} of 4',
                        style: AppTheme.body(
                          size: 11,
                          weight: FontWeight.w500,
                          color: AppColors.orangeBright,
                        ).copyWith(letterSpacing: 1.8),
                      ),
                      Text(
                        [
                          'Life Assessment',
                          'Limiting Beliefs',
                          'Your Timeline',
                          'Anxiety Checklist',
                        ][stepIndex],
                        style: AppTheme.bebas(size: 34),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.foundationBorder, height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _stepIntro(stepIndex),
                const SizedBox(height: 18),
                if (stepIndex == 0) _lifeAssessment(),
                if (stepIndex == 1) _beliefsStep(),
                if (stepIndex == 2) _timelineStep(),
                if (stepIndex == 3) _triggersStep(),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.foundationBorder),
              ),
            ),
            child: YdyButton(
              label: [
                'Submit Life Assessment →',
                'Submit My Beliefs →',
                'Submit My Timeline →',
                'Submit Anxiety Checklist →',
              ][stepIndex],
              enabled: _stepReady(stepIndex),
              onPressed: () async {
                await controller.completeFoundationStep(stepIndex);
                if (context.mounted) onBack();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepIntro(int stepIndex) {
    final intro = switch (stepIndex) {
      0 =>
        'Look at each area of your life and give it an honest score out of 10. Then write a short note on what it would need to get to a 10.',
      1 =>
        'These are beliefs men carry without ever saying out loud. Tick the ones that have held you back — even the ones that are uncomfortable to admit.',
      2 =>
        'List the key moments in your life — highs and lows. Don\'t skip the difficult ones. They\'re usually the most important.',
      _ =>
        'Anxiety shows up when we feel out of control or when something triggers one of our limiting beliefs. Tick everything that applies to you.',
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.orangeBright.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.orangeBright.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        intro,
        style: AppTheme.body(size: 13, color: AppColors.white),
      ),
    );
  }

  Widget _lifeAssessment() {
    return Column(
      children: AppContent.lifeAreas.map((area) {
        final score = controller.lifeScores[area] ?? 0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.foundationGrey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.foundationBorder),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          area,
                          style: AppTheme.body(
                            size: 14,
                            weight: FontWeight.w500,
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          score == 0 ? '—' : '$score',
                          style: AppTheme.bebas(
                            size: 30,
                            color: AppColors.orangeBright,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: List.generate(10, (index) {
                        final value = index + 1;
                        final selected = value == score;
                        final filled = value < score;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                controller.updateLifeScore(area, value),
                            child: Container(
                              margin: EdgeInsets.only(left: index == 0 ? 0 : 4),
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: selected
                                    ? AppColors.orangeBright
                                    : filled
                                    ? AppColors.orangeBright.withValues(
                                        alpha: 0.25,
                                      )
                                    : AppColors.foundationBorder,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$value',
                                style: AppTheme.body(
                                  size: 11,
                                  weight: FontWeight.w600,
                                  color: selected
                                      ? AppColors.white
                                      : filled
                                      ? AppColors.orangeBright
                                      : const Color(0xFFB07850),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller:
                    TextEditingController(
                        text: controller.lifeNotes[area] ?? '',
                      )
                      ..selection = TextSelection.collapsed(
                        offset: (controller.lifeNotes[area] ?? '').length,
                      ),
                onChanged: (value) => controller.updateLifeNote(area, value),
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'What\'s it missing to get to a 10?',
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _beliefsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${controller.selectedBeliefs.length} selected',
          style: AppTheme.body(
            size: 13,
            weight: FontWeight.w700,
            color: controller.selectedBeliefs.length > 5
                ? AppColors.danger
                : controller.selectedBeliefs.isEmpty
                ? AppColors.deepDimText
                : AppColors.orangeBright,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(AppContent.beliefs.length, (index) {
          final selected = controller.selectedBeliefs.contains(index);
          final locked = !selected && controller.selectedBeliefs.length >= 5;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: locked ? null : () => controller.toggleBelief(index),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.orangeBright.withValues(alpha: 0.12)
                      : AppColors.foundationGrey,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: selected
                        ? AppColors.orangeGlowStrong
                        : AppColors.foundationBorder,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: selected
                              ? AppColors.orangeBright
                              : AppColors.foundationBorder,
                          width: 1.5,
                        ),
                        color: selected
                            ? AppColors.orangeBright
                            : Colors.transparent,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        selected ? '✓' : '',
                        style: AppTheme.body(
                          size: 10,
                          weight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppContent.beliefs[index],
                        style: AppTheme.body(
                          size: 13,
                          color: locked
                              ? AppColors.deepDimText
                              : AppColors.white,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _timelineStep() {
    return Column(
      children: [
        ...List.generate(controller.timeline.length, (index) {
          final item = controller.timeline[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.foundationGrey,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.foundationBorder),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 84,
                        child: TextField(
                          controller: TextEditingController(text: item.year)
                            ..selection = TextSelection.collapsed(
                              offset: item.year.length,
                            ),
                          onChanged: (value) =>
                              controller.updateTimelineYear(index, value),
                          decoration: const InputDecoration(hintText: 'Year'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: _TypeChip(
                                label: '+ Positive',
                                active: item.type == 'pos',
                                activeColor: AppColors.success,
                                onTap: () =>
                                    controller.updateTimelineType(index, 'pos'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _TypeChip(
                                label: '− Negative',
                                active: item.type == 'neg',
                                activeColor: AppColors.danger,
                                onTap: () =>
                                    controller.updateTimelineType(index, 'neg'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (controller.timeline.length > 1)
                        IconButton(
                          onPressed: () =>
                              controller.removeTimelineEvent(index),
                          icon: const Icon(
                            Icons.close,
                            color: Color(0xFFB07850),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: TextEditingController(text: item.event)
                      ..selection = TextSelection.collapsed(
                        offset: item.event.length,
                      ),
                    onChanged: (value) =>
                        controller.updateTimelineEvent(index, value),
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'What happened? Keep it brief.',
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: controller.addTimelineEvent,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(
              color: AppColors.foundationBorder,
              style: BorderStyle.solid,
            ),
            foregroundColor: const Color(0xFFB07850),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          ),
          child: Text(
            '+ Add another event',
            style: AppTheme.body(size: 13, color: const Color(0xFFB07850)),
          ),
        ),
      ],
    );
  }

  Widget _triggersStep() {
    final triggerGroups = <String, List<Map<String, String>>>{
      'Daily Triggers': AppContent.dailyTriggers,
      'Specific Triggers': AppContent.specificTriggers,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: triggerGroups.entries.map((group) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(group.key, style: AppTheme.bebas(size: 28)),
              const SizedBox(height: 10),
              ...List.generate(group.value.length, (index) {
                final trigger = group.value[index];
                final key = '${group.key}::$index';
                final selected = controller.selectedTriggers.contains(key);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () => controller.toggleTrigger(key),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.orangeBright.withValues(alpha: 0.12)
                            : AppColors.foundationGrey,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: selected
                              ? AppColors.orangeGlowStrong
                              : AppColors.foundationBorder,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: selected
                                    ? AppColors.orangeBright
                                    : AppColors.foundationBorder,
                                width: 1.5,
                              ),
                              color: selected
                                  ? AppColors.orangeBright
                                  : Colors.transparent,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              selected ? '✓' : '',
                              style: AppTheme.body(
                                size: 10,
                                weight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trigger['name']!,
                                  style: AppTheme.body(
                                    size: 13,
                                    weight: FontWeight.w500,
                                    color: AppColors.white,
                                  ),
                                ),
                                if (selected) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    trigger['desc']!,
                                    style: AppTheme.body(
                                      size: 11,
                                      color: const Color(0xFFB07850),
                                      height: 1.45,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      }).toList(),
    );
  }

  bool _stepReady(int stepIndex) {
    return switch (stepIndex) {
      0 => controller.lifeAssessmentReady,
      1 =>
        controller.selectedBeliefs.isNotEmpty &&
            controller.selectedBeliefs.length <= 5,
      2 => controller.timelineReady,
      _ => controller.triggersReady,
    };
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.active,
    required this.activeColor,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? activeColor.withValues(alpha: 0.15) : AppColors.black,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: active ? activeColor : AppColors.foundationBorder,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTheme.body(
            size: 11,
            weight: FontWeight.w600,
            color: active ? activeColor : const Color(0xFFB07850),
          ),
        ),
      ),
    );
  }
}

class _DiaryBottomSheet extends StatefulWidget {
  const _DiaryBottomSheet({required this.controller});

  final AppController controller;

  @override
  State<_DiaryBottomSheet> createState() => _DiaryBottomSheetState();
}

class _DiaryBottomSheetState extends State<_DiaryBottomSheet> {
  int? score;
  final whyController = TextEditingController();
  final happenedController = TextEditingController();
  final thoughtController = TextEditingController();

  bool get ready =>
      score != null &&
      whyController.text.trim().length > 3 &&
      happenedController.text.trim().length > 5 &&
      thoughtController.text.trim().length > 3;

  @override
  void initState() {
    super.initState();
    final existing = widget.controller.todayDiaryEntry;
    if (existing != null) {
      score = existing.score;
      whyController.text = existing.why;
      happenedController.text = existing.happened;
      thoughtController.text = existing.heaviestThought;
    }
    whyController.addListener(_refresh);
    happenedController.addListener(_refresh);
    thoughtController.addListener(_refresh);
  }

  @override
  void dispose() {
    whyController.dispose();
    happenedController.dispose();
    thoughtController.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Thought Diary', style: AppTheme.bebas(size: 36)),
            const SizedBox(height: 6),
            Text(
              '5 minutes before bed. Score the day, say why, write what happened, name the heaviest thought.',
              style: AppTheme.body(size: 13, color: AppColors.deepDimText),
            ),
            const SizedBox(height: 18),
            Text(
              'Score today 1–10',
              style: AppTheme.body(
                size: 14,
                weight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: List.generate(10, (index) {
                final value = index + 1;
                final selected = score == value;
                return GestureDetector(
                  onTap: () => setState(() => score = value),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.orange
                          : AppColors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selected ? AppColors.orange : AppColors.border,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$value',
                      style: AppTheme.body(
                        size: 14,
                        weight: FontWeight.w600,
                        color: selected ? AppColors.white : AppColors.muted,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: whyController,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Why that score?'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: happenedController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'What happened today?',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: thoughtController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'What\'s the heaviest thought right now?',
              ),
            ),
            const SizedBox(height: 18),
            YdyButton(
              label: 'Save tonight\'s entry →',
              enabled: ready,
              onPressed: () async {
                if (!ready || score == null) return;
                await widget.controller.saveDiaryEntry(
                  score: score!,
                  why: whyController.text.trim(),
                  happened: happenedController.text.trim(),
                  thought: thoughtController.text.trim(),
                );
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
