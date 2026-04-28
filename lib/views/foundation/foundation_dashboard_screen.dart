import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/constants/app_content.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../controllers/app_controller.dart';
import '../../models/app_models.dart';
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
  final ScrollController _dashboardScrollController = ScrollController();
  final GlobalKey _toolsKey = GlobalKey();
  int? _activeStep;
  int _currentTool = 1;
  bool _showFoundationCoach = false;
  _ExitView? _exitView;
  final Set<int> _completedTools = <int>{};
  final List<_SimpleWorkEntry> _enquiryEntries = <_SimpleWorkEntry>[];
  final List<_SimpleWorkEntry> _unwireEntries = <_SimpleWorkEntry>[];

  bool get _foundationComplete =>
      widget.controller.completedFoundationCount == 4;

  @override
  void dispose() {
    _dashboardScrollController.dispose();
    super.dispose();
  }

  void _handleFoundationStepFinished(bool showCoach) {
    setState(() {
      _activeStep = null;
      _showFoundationCoach = showCoach;
    });
  }

  void _dismissFoundationCoach() {
    setState(() => _showFoundationCoach = false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final toolsContext = _toolsKey.currentContext;
      if (toolsContext == null) return;
      Scrollable.ensureVisible(
        toolsContext,
        duration: const Duration(milliseconds: 480),
        curve: Curves.easeOutCubic,
        alignment: 0.04,
      );
    });
  }

  void _completeTool(int toolNum) {
    setState(() {
      _completedTools.add(toolNum);
      if (_currentTool == toolNum && toolNum < 5) {
        _currentTool = toolNum + 1;
      }
    });
  }

  Future<void> _openDiarySheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.black,
      builder: (context) => _DiaryBottomSheet(controller: widget.controller),
    );
  }

  Future<void> _openWeeklyTool(int toolNum) async {
    if (toolNum != _currentTool || _completedTools.contains(toolNum)) return;

    if (toolNum == 1) {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.black,
        builder: (context) => _EnquiryToolSheet(
          controller: widget.controller,
          entries: _enquiryEntries,
          onSave: (entry) => setState(() => _enquiryEntries.add(entry)),
          onComplete: () => _completeTool(1),
        ),
      );
      return;
    }

    if (toolNum == 2) {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.black,
        builder: (context) => _UnwireToolSheet(
          controller: widget.controller,
          sourceEntries: _enquiryEntries,
          entries: _unwireEntries,
          onSave: (entry) => setState(() => _unwireEntries.add(entry)),
          onComplete: () => _completeTool(2),
        ),
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.black,
      builder: (context) => _SimpleWeeklyToolSheet(
        toolNum: toolNum,
        title: _weeklyToolTitle(toolNum),
        subtitle: _weeklyToolSubtitle(toolNum),
        onComplete: () => _completeTool(toolNum),
      ),
    );
  }

  void _showExitScreen() {
    setState(() => _exitView = _ExitView.leaving);
  }

  void _dismissExitScreen() {
    setState(() => _exitView = null);
  }

  void _showLeaveConfirm() {
    setState(() => _exitView = _ExitView.confirm);
  }

  void _showDeleteConfirm() {
    setState(() => _exitView = _ExitView.delete);
  }

  Future<void> _deleteAllData() async {
    await widget.controller.resetApp();
  }

  Future<void> _confirmLeave() async {
    setState(() => _exitView = null);
    await SystemNavigator.pop();
  }

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
            onFinished: _handleFoundationStepFinished,
          );
        }

        if (_showFoundationCoach) {
          return _FoundationCoachScreen(onContinue: _dismissFoundationCoach);
        }

        return YdyShell(
          safeBottom: false,
          showGlow: false,
          child: Stack(
            children: [
              ListView(
                controller: _dashboardScrollController,
                padding: const EdgeInsets.only(bottom: 40),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 44, 24, 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FOUNDATION WORK',
                          style: AppTheme.body(
                            size: 11,
                            color: AppColors.orangeBright,
                            weight: FontWeight.w500,
                          ).copyWith(letterSpacing: 2),
                        ),
                        const SizedBox(height: 8),
                        Text.rich(
                          const TextSpan(
                            text: 'Before The Tools\n',
                            children: [
                              TextSpan(
                                text: 'Come The Foundations.',
                                style: TextStyle(color: AppColors.orangeBright),
                              ),
                            ],
                          ),
                          style: AppTheme.bebas(
                            size: 40,
                            height: 1,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Complete these 4 steps in order. Your tools unlock when all 4 are done.',
                          style: AppTheme.body(
                            size: 13,
                            color: AppColors.foundationMuted,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.orangeBright.withValues(alpha: 0.12),
                      border: const Border.symmetric(
                        horizontal: BorderSide(
                          color: AppColors.foundationBorder,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'YOUR PROGRESS',
                              style: AppTheme.body(
                                size: 11,
                                weight: FontWeight.w500,
                                color: AppColors.foundationMuted,
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
                        final unlocked = widget.controller
                            .isFoundationStepUnlocked(index);
                        final complete =
                            widget.controller.completedFoundationSteps[index];
                        final active = unlocked && !complete;
                        final title = [
                          'LIFE ASSESSMENT',
                          'LIMITING BELIEFS',
                          'YOUR TIMELINE',
                          'ANXIETY CHECKLIST',
                        ][index];
                        final description = [
                          'Score 6 areas of your life out of 10 and note what\'s missing to get each one there.',
                          'Tick the beliefs that have held you back. The ones you don\'t admit to out loud.',
                          'Map the key moments in your life — high points and low points. This is where patterns start.',
                          'Identify which triggers show up in your life and understand what\'s behind each one.',
                        ][index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _FoundationStepTile(
                            number: index + 1,
                            title: title,
                            description: description,
                            active: active,
                            complete: complete,
                            locked: !unlocked,
                            onTap: unlocked
                                ? () => setState(() => _activeStep = index)
                                : null,
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 10),
                    child: Text(
                      'YOUR TOOLS',
                      style: AppTheme.body(
                        size: 11,
                        weight: FontWeight.w500,
                        color: AppColors.foundationMuted,
                      ).copyWith(letterSpacing: 2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _ToolsLockCard(unlocked: _foundationComplete),
                  ),
                  if (_foundationComplete) ...[
                    const SizedBox(height: 16),
                    KeyedSubtree(
                      key: _toolsKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _CopingCheckinCard(
                          controller: widget.controller,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _DailyToolsSection(controller: widget.controller),
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _WeeklyToolsSection(
                        currentTool: _currentTool,
                        completedTools: _completedTools,
                        enquiryEntries: _enquiryEntries,
                        unwireEntries: _unwireEntries,
                        onOpenTool: _openWeeklyTool,
                        onOpenDiary: () => _openDiarySheet(context),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _FoundationFooter(onLeave: _showExitScreen),
                    ),
                  ],
                ],
              ),
              if (_exitView != null)
                Positioned.fill(
                  child: _ExitScreen(
                    view: _exitView!,
                    controller: widget.controller,
                    completedToolCount: _completedTools.length,
                    onStay: _dismissExitScreen,
                    onLeaveForNow: _showLeaveConfirm,
                    onConfirmLeave: _confirmLeave,
                    onDeleteData: _showDeleteConfirm,
                    onCancelDelete: _showLeaveConfirm,
                    onConfirmDelete: _deleteAllData,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

enum _ExitView { leaving, confirm, delete }

class _ExitScreen extends StatelessWidget {
  const _ExitScreen({
    required this.view,
    required this.controller,
    required this.completedToolCount,
    required this.onStay,
    required this.onLeaveForNow,
    required this.onConfirmLeave,
    required this.onDeleteData,
    required this.onCancelDelete,
    required this.onConfirmDelete,
  });

  final _ExitView view;
  final AppController controller;
  final int completedToolCount;
  final VoidCallback onStay;
  final VoidCallback onLeaveForNow;
  final VoidCallback onConfirmLeave;
  final VoidCallback onDeleteData;
  final VoidCallback onCancelDelete;
  final VoidCallback onConfirmDelete;

  int get _daysIn {
    final joinedAt = controller.joinData?.joinedAtEpochMs ?? 0;
    if (joinedAt <= 0) return 1;

    final joinedDate = DateTime.fromMillisecondsSinceEpoch(joinedAt);
    final days = DateTime.now().difference(joinedDate).inDays + 1;
    return days < 1 ? 1 : days;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.black),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: switch (view) {
          _ExitView.leaving => _LeavingView(
            key: const ValueKey('exit-leaving'),
            daysIn: _daysIn,
            completedToolCount: completedToolCount,
            diaryCount: controller.diaryEntries.length,
            onStay: onStay,
            onLeaveForNow: onLeaveForNow,
          ),
          _ExitView.confirm => _LeaveConfirmView(
            key: const ValueKey('exit-confirm'),
            name: controller.primaryName,
            onStay: onStay,
            onTakeMeOut: onConfirmLeave,
            onDeleteData: onDeleteData,
          ),
          _ExitView.delete => _DeleteConfirmView(
            key: const ValueKey('exit-delete'),
            onConfirmDelete: onConfirmDelete,
            onGoBack: onCancelDelete,
          ),
        },
      ),
    );
  }
}

class _LeavingView extends StatelessWidget {
  const _LeavingView({
    super.key,
    required this.daysIn,
    required this.completedToolCount,
    required this.diaryCount,
    required this.onStay,
    required this.onLeaveForNow,
  });

  final int daysIn;
  final int completedToolCount;
  final int diaryCount;
  final VoidCallback onStay;
  final VoidCallback onLeaveForNow;

  @override
  Widget build(BuildContext context) {
    final stats = <_ExitStat>[
      _ExitStat('$daysIn', 'days on this'),
      if (completedToolCount > 0)
        _ExitStat('$completedToolCount', 'tools completed'),
      if (diaryCount > 0) _ExitStat('$diaryCount', 'diary entries'),
    ];

    return _ExitLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _ExitIcon(icon: '🏆'),
          const SizedBox(height: 18),
          Text.rich(
            const TextSpan(
              text: 'Look how far\nyou\'ve ',
              children: [
                TextSpan(
                  text: 'come.',
                  style: TextStyle(color: AppColors.orangeBright),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            style: AppTheme.bebas(size: 33, height: 1.03, letterSpacing: 1),
          ),
          const SizedBox(height: 14),
          _ExitStats(stats: stats),
          const SizedBox(height: 16),
          Text(
            'Fall down seven times, get up eight. It doesn\'t matter how many times you fall — it\'s how many times you get back up and keep going.',
            textAlign: TextAlign.center,
            style: AppTheme.body(
              size: 11,
              color: AppColors.white.withValues(alpha: 0.58),
              height: 1.65,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'The work you\'ve done here doesn\'t disappear. It\'s waiting for you. You\'re welcome back any time — no questions, no judgement.',
            textAlign: TextAlign.center,
            style: AppTheme.body(
              size: 11,
              color: AppColors.white.withValues(alpha: 0.58),
              height: 1.65,
            ),
          ),
          const SizedBox(height: 20),
          const _ReturnNote(),
          const SizedBox(height: 14),
          YdyButton(label: 'Stay — keep going →', onPressed: onStay),
          const SizedBox(height: 10),
          _ExitGhostButton(label: 'Leave for now', onPressed: onLeaveForNow),
        ],
      ),
    );
  }
}

class _LeaveConfirmView extends StatelessWidget {
  const _LeaveConfirmView({
    super.key,
    required this.name,
    required this.onStay,
    required this.onTakeMeOut,
    required this.onDeleteData,
  });

  final String name;
  final VoidCallback onStay;
  final VoidCallback onTakeMeOut;
  final VoidCallback onDeleteData;

  @override
  Widget build(BuildContext context) {
    final displayName = name.trim().isEmpty ? 'mate' : name.trim();

    return _ExitLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _ExitIcon(icon: '👋'),
          const SizedBox(height: 18),
          Text.rich(
            TextSpan(
              text: 'Until next time,\n',
              children: [
                TextSpan(
                  text: '$displayName.',
                  style: const TextStyle(color: AppColors.orangeBright),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            style: AppTheme.bebas(size: 33, height: 1.03, letterSpacing: 1),
          ),
          const SizedBox(height: 24),
          Text(
            'You did something today that most men never do — you worked on yourself. That matters. Come back when you\'re ready. The door\'s always open.',
            textAlign: TextAlign.center,
            style: AppTheme.body(
              size: 11,
              color: AppColors.white.withValues(alpha: 0.58),
              height: 1.7,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            '"Fall down seven times. Get up eight."',
            textAlign: TextAlign.center,
            style: AppTheme.bebas(
              size: 19,
              color: AppColors.orangeBright,
              height: 1.1,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '— Steven Jackson, You Define You',
            textAlign: TextAlign.center,
            style: AppTheme.body(
              size: 9,
              color: AppColors.white.withValues(alpha: 0.22),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          YdyButton(label: 'Actually — I\'ll keep going →', onPressed: onStay),
          const SizedBox(height: 10),
          _ExitGhostButton(label: 'Take me out', onPressed: onTakeMeOut),
          const SizedBox(height: 15),
          TextButton(
            onPressed: onDeleteData,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.white.withValues(alpha: 0.2),
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Delete my data',
              style: AppTheme.body(
                size: 10,
                color: AppColors.white.withValues(alpha: 0.2),
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeleteConfirmView extends StatelessWidget {
  const _DeleteConfirmView({
    super.key,
    required this.onConfirmDelete,
    required this.onGoBack,
  });

  final VoidCallback onConfirmDelete;
  final VoidCallback onGoBack;

  @override
  Widget build(BuildContext context) {
    return _ExitLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _ExitIcon(icon: '🗑'),
          const SizedBox(height: 18),
          Text.rich(
            const TextSpan(
              text: 'Delete\nyour ',
              children: [
                TextSpan(
                  text: 'data?',
                  style: TextStyle(color: AppColors.orangeBright),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            style: AppTheme.bebas(size: 33, height: 1.03, letterSpacing: 1),
          ),
          const SizedBox(height: 20),
          Text(
            'This will permanently remove everything — your diary entries, tool answers, beliefs, and account details. This cannot be undone.',
            textAlign: TextAlign.center,
            style: AppTheme.body(
              size: 11,
              color: AppColors.white.withValues(alpha: 0.58),
              height: 1.65,
            ),
          ),
          const SizedBox(height: 22),
          const _GdprRightsCard(),
          const SizedBox(height: 15),
          _DangerButton(
            label: 'Yes — delete everything',
            onPressed: onConfirmDelete,
          ),
          const SizedBox(height: 10),
          YdyButton(label: 'No — go back', onPressed: onGoBack),
        ],
      ),
    );
  }
}

class _ExitLayout extends StatelessWidget {
  const _ExitLayout({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 34, 20, 34),
        child: child,
      ),
    );
  }
}

class _ExitIcon extends StatelessWidget {
  const _ExitIcon({required this.icon});

  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.orange.withValues(alpha: 0.1),
        border: Border.all(color: AppColors.orange.withValues(alpha: 0.32)),
      ),
      alignment: Alignment.center,
      child: Text(icon, style: const TextStyle(fontSize: 24)),
    );
  }
}

class _ExitStat {
  const _ExitStat(this.value, this.label);

  final String value;
  final String label;
}

class _ExitStats extends StatelessWidget {
  const _ExitStats({required this.stats});

  final List<_ExitStat> stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < stats.length; i++) ...[
            if (i > 0)
              Container(
                width: 1,
                height: 35,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: AppColors.white.withValues(alpha: 0.08),
              ),
            _ExitStatColumn(stat: stats[i]),
          ],
        ],
      ),
    );
  }
}

class _ExitStatColumn extends StatelessWidget {
  const _ExitStatColumn({required this.stat});

  final _ExitStat stat;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          stat.value,
          style: AppTheme.bebas(
            size: 26,
            color: AppColors.orangeBright,
            height: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          stat.label.toUpperCase(),
          textAlign: TextAlign.center,
          style: AppTheme.body(
            size: 8.5,
            color: AppColors.white.withValues(alpha: 0.3),
            weight: FontWeight.w700,
            height: 1.1,
          ).copyWith(letterSpacing: 0.8),
        ),
      ],
    );
  }
}

class _ReturnNote extends StatelessWidget {
  const _ReturnNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.orange.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.orange.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🔄', style: TextStyle(fontSize: 15)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Come back on any device. Your progress will be here — use the same email and we\'ll pick up exactly where you left off.',
              style: AppTheme.body(
                size: 10,
                color: AppColors.white.withValues(alpha: 0.5),
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExitGhostButton extends StatelessWidget {
  const _ExitGhostButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.white.withValues(alpha: 0.45),
          side: BorderSide(color: AppColors.white.withValues(alpha: 0.15)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: AppTheme.body(
            size: 11,
            color: AppColors.white.withValues(alpha: 0.45),
            weight: FontWeight.w500,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _DangerButton extends StatelessWidget {
  const _DangerButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.danger,
          backgroundColor: AppColors.danger.withValues(alpha: 0.15),
          side: BorderSide(color: AppColors.danger.withValues(alpha: 0.4)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: AppTheme.body(
            size: 11,
            color: AppColors.danger,
            weight: FontWeight.w500,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _GdprRightsCard extends StatelessWidget {
  const _GdprRightsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'YOUR GDPR RIGHTS',
            style: AppTheme.body(
              size: 8.8,
              color: AppColors.white.withValues(alpha: 0.25),
              weight: FontWeight.w800,
              height: 1.2,
            ).copyWith(letterSpacing: 1.2),
          ),
          const SizedBox(height: 10),
          const _GdprItem(
            'You have the right to erasure ("right to be forgotten") under UK GDPR Article 17.',
          ),
          const _GdprItem(
            'Deleting here removes all locally stored data immediately and permanently.',
          ),
          const _GdprItem(
            'If we hold any email records, contact us at hello@youdefineyou.co.uk for removal.',
          ),
        ],
      ),
    );
  }
}

class _GdprItem extends StatelessWidget {
  const _GdprItem(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: AppColors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Text(
        text,
        style: AppTheme.body(
          size: 10,
          color: AppColors.white.withValues(alpha: 0.4),
          height: 1.55,
        ),
      ),
    );
  }
}

class _FoundationCoachScreen extends StatelessWidget {
  const _FoundationCoachScreen({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return YdyShell(
      safeBottom: false,
      showGlow: false,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 54, 24, 26),
              children: [
                Text(
                  'FROM STEVEN JACKSON · YOU DEFINE YOU',
                  style: AppTheme.body(
                    size: 9.5,
                    color: AppColors.orangeBright,
                    weight: FontWeight.w700,
                  ).copyWith(letterSpacing: 1.7),
                ),
                const SizedBox(height: 18),
                Text.rich(
                  const TextSpan(
                    text: 'Right.\nThat took\n',
                    children: [
                      TextSpan(
                        text: 'Guts.',
                        style: TextStyle(color: AppColors.orangeBright),
                      ),
                    ],
                  ),
                  style: AppTheme.bebas(
                    size: 46,
                    height: 0.95,
                    color: AppColors.white,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 26),
                _CoachParagraph(
                  children: const [
                    TextSpan(
                      text:
                          'Most men who download this app never get this far. They open it, have a look, and close it again. ',
                    ),
                    TextSpan(
                      text: 'You didn\'t do that.',
                      style: TextStyle(color: AppColors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                _CoachParagraph(
                  children: const [
                    TextSpan(
                      text:
                          'You\'ve just done something most men spend their whole lives avoiding — ',
                    ),
                    TextSpan(
                      text: 'you looked at it honestly.',
                      style: TextStyle(
                        color: AppColors.orangeBright,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' Your life scores. The beliefs you\'ve been carrying. The moments that shaped you. The things that set you off.',
                    ),
                  ],
                ),
                const _CoachDivider(),
                _CoachParagraph(
                  children: const [
                    TextSpan(
                      text:
                          'That\'s not small. That\'s the bit that makes everything else actually work.',
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                _CoachParagraph(
                  children: const [
                    TextSpan(
                      text:
                          'Here\'s what I want you to understand before you go any further — ',
                    ),
                    TextSpan(
                      text: 'none of what you wrote down makes you broken.',
                      style: TextStyle(
                        color: AppColors.orangeBright,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' It makes you human. And it makes you someone who now has a map of what\'s been running in the background.',
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                _CoachParagraph(
                  children: const [
                    TextSpan(
                      text:
                          'The tools that are now unlocked were built specifically for what you\'re carrying. They\'re not generic. They work because of the foundation work you\'ve just done.',
                    ),
                  ],
                ),
                const _CoachDivider(),
                _CoachParagraph(
                  children: const [
                    TextSpan(
                      text: 'Start with the first tool in your list. ',
                      style: TextStyle(
                        color: AppColors.orangeBright,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          'Don\'t skip ahead. Little things do the bigger things — that\'s how this works.',
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                _CoachParagraph(
                  children: const [
                    TextSpan(
                      text:
                          'Fall down seven times. Get up eight. It doesn\'t matter how many times you fall — it\'s how many times you get back up and keep going.',
                      style: TextStyle(
                        color: AppColors.orangeBright,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Text(
                  'WHAT\'S UNLOCKED FOR YOU',
                  style: AppTheme.body(
                    size: 9.5,
                    color: AppColors.foundationMuted,
                    weight: FontWeight.w700,
                  ).copyWith(letterSpacing: 1.6),
                ),
                const SizedBox(height: 10),
                const _CoachUnlockItem(
                  icon: '📊',
                  text: 'Your matched tools — ready to use, in the right order',
                ),
                const SizedBox(height: 8),
                const _CoachUnlockItem(
                  icon: '💬',
                  text:
                      'Your personal coach — knows your profile and your answers',
                ),
                const SizedBox(height: 8),
                const _CoachUnlockItem(
                  icon: '📈',
                  text:
                      'Progress tracking — so you can see how far you\'ve come',
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
            decoration: const BoxDecoration(
              color: Color(0xFF0F0800),
              border: Border(
                top: BorderSide(color: AppColors.foundationBorder),
              ),
            ),
            child: YdyButton(
              label: 'Take Me To My Tools →',
              onPressed: onContinue,
            ),
          ),
        ],
      ),
    );
  }
}

class _CoachParagraph extends StatelessWidget {
  const _CoachParagraph({required this.children});

  final List<InlineSpan> children;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(children: children),
      style: AppTheme.body(size: 12.5, color: AppColors.white, height: 1.74),
    );
  }
}

class _CoachDivider extends StatelessWidget {
  const _CoachDivider();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 42,
        height: 2,
        margin: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.orangeBright,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _CoachUnlockItem extends StatelessWidget {
  const _CoachUnlockItem({required this.icon, required this.text});

  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.foundationGrey,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.foundationBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.orangeBright.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(icon, style: const TextStyle(fontSize: 15)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTheme.body(
                size: 11.5,
                color: AppColors.white,
                weight: FontWeight.w500,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolsLockCard extends StatelessWidget {
  const _ToolsLockCard({required this.unlocked});

  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: unlocked ? AppColors.successDim : AppColors.foundationGrey,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: unlocked ? AppColors.success : AppColors.foundationBorder,
        ),
      ),
      child: Column(
        children: [
          Text(unlocked ? '🔓' : '🔒', style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            unlocked ? 'Tools Unlocked' : 'Tools Locked',
            style: AppTheme.bebas(
              size: 28,
              color: unlocked ? AppColors.success : AppColors.foundationMuted,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            unlocked
                ? 'Foundation complete. Your matched tools are now unlocked and ready to use.'
                : 'Complete all 4 foundation steps to unlock your matched tools. This work is the reason the tools actually work.',
            textAlign: TextAlign.center,
            style: AppTheme.body(
              size: 12,
              color: unlocked ? AppColors.white : AppColors.foundationMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _FoundationStepTile extends StatelessWidget {
  const _FoundationStepTile({
    required this.number,
    required this.title,
    required this.description,
    required this.active,
    required this.complete,
    required this.locked,
    required this.onTap,
  });

  final int number;
  final String title;
  final String description;
  final bool active;
  final bool complete;
  final bool locked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = complete
        ? AppColors.success
        : active
        ? AppColors.orangeBright
        : AppColors.foundationBorder.withValues(alpha: 0.8);
    final fillColor = complete
        ? AppColors.successDim
        : active
        ? AppColors.orangeBright.withValues(alpha: 0.08)
        : AppColors.foundationGrey.withValues(alpha: 0.42);
    final titleColor = locked
        ? AppColors.foundationMuted.withValues(alpha: 0.43)
        : AppColors.white;
    final descriptionColor = locked
        ? AppColors.foundationMuted.withValues(alpha: 0.34)
        : AppColors.foundationMuted;
    final badgeText = complete
        ? 'DONE'
        : active
        ? 'START'
        : 'LOCKED';
    final badgeColor = complete
        ? AppColors.success
        : active
        ? AppColors.orangeBright
        : AppColors.foundationMuted.withValues(alpha: 0.42);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
        decoration: BoxDecoration(
          color: fillColor,
          border: Border.all(color: borderColor, width: active ? 1.4 : 1),
          borderRadius: BorderRadius.circular(10),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: AppColors.orangeBright.withValues(alpha: 0.11),
                    blurRadius: 18,
                  ),
                ]
              : null,
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
                    : AppColors.black.withValues(alpha: 0.52),
                border: Border.all(
                  color: complete
                      ? AppColors.success
                      : active
                      ? AppColors.orangeBright
                      : AppColors.foundationBorder,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                complete ? '✓' : '$number',
                style: AppTheme.bebas(
                  size: complete ? 16 : 20,
                  color: locked
                      ? AppColors.foundationMuted.withValues(alpha: 0.45)
                      : AppColors.white,
                  letterSpacing: 0.5,
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
                      size: 21,
                      color: titleColor,
                      height: 1,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTheme.body(
                      size: 11.5,
                      color: descriptionColor,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: active ? 0.14 : 0.08),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: badgeColor.withValues(alpha: 0.42)),
              ),
              child: Text(
                badgeText,
                style: AppTheme.body(
                  size: 8.5,
                  weight: FontWeight.w800,
                  color: badgeColor,
                  height: 1,
                ).copyWith(letterSpacing: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CopingCheckinCard extends StatelessWidget {
  const _CopingCheckinCard({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final latest = controller.copingEntries.isEmpty
        ? null
        : controller.copingEntries.last;
    final daysLeft = _copingDaysUntilNext(latest);
    final badgeColor = latest == null || daysLeft == 0
        ? AppColors.amber
        : AppColors.white.withValues(alpha: 0.38);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 13),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A14),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.amber.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.amber.withValues(alpha: 0.12),
                  border: Border.all(
                    color: AppColors.amber.withValues(alpha: 0.3),
                  ),
                ),
                alignment: Alignment.center,
                child: const Text('📊', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Coping Level Check-In',
                      style: AppTheme.body(
                        size: 13,
                        weight: FontWeight.w700,
                        color: AppColors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _copingBadgeText(latest),
                      style: AppTheme.body(
                        size: 10.5,
                        color: badgeColor,
                        weight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: AppColors.black,
                  builder: (context) =>
                      _CopingBottomSheet(controller: controller),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: AppColors.amber,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: AppColors.amber.withValues(alpha: 0.42),
                    ),
                  ),
                ),
                child: Text(
                  'Check in →',
                  style: AppTheme.body(
                    size: 10.5,
                    weight: FontWeight.w800,
                    color: AppColors.amber,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Text(
            'Your coping threshold — what is pushing you down and what builds you back up. Do this once now, then every two weeks on a morning between 6 and 9am.',
            style: AppTheme.body(
              size: 11.2,
              color: AppColors.white.withValues(alpha: 0.38),
              height: 1.46,
            ),
          ),
          if (controller.copingEntries.isNotEmpty) ...[
            const SizedBox(height: 10),
            _CopingHistoryChart(entries: controller.copingEntries),
          ],
        ],
      ),
    );
  }
}

class _CopingHistoryChart extends StatelessWidget {
  const _CopingHistoryChart({required this.entries});

  final List<CopingCheckinEntry> entries;

  @override
  Widget build(BuildContext context) {
    final visibleEntries = entries.length > 6
        ? entries.sublist(entries.length - 6)
        : entries;

    return Container(
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.only(top: 7),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.white.withValues(alpha: 0.06)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: visibleEntries.map((entry) {
          final color = _copingScoreColor(entry.score);
          return Padding(
            padding: const EdgeInsets.only(right: 7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 20,
                  height: (entry.score * 4.1).clamp(5, 41).toDouble(),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${entry.score}',
                  style: AppTheme.body(
                    size: 9.5,
                    weight: FontWeight.w800,
                    color: color,
                    height: 1,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

Color _copingScoreColor(int score) {
  if (score >= 8) return AppColors.success;
  if (score >= 5) return AppColors.amber;
  return AppColors.danger;
}

int _copingDaysUntilNext(CopingCheckinEntry? latest) {
  if (latest == null || latest.createdAtEpochMs <= 0) return 0;
  final elapsed = DateTime.now().difference(
    DateTime.fromMillisecondsSinceEpoch(latest.createdAtEpochMs),
  );
  final remainingMs =
      const Duration(days: 14).inMilliseconds - elapsed.inMilliseconds;
  if (remainingMs <= 0) return 0;
  return (remainingMs / const Duration(days: 1).inMilliseconds).ceil();
}

bool _isCopingMorningWindow() {
  final hour = DateTime.now().hour;
  return hour >= 6 && hour < 9;
}

String _copingBadgeText(CopingCheckinEntry? latest) {
  if (latest == null) return 'First check-in · Complete now';

  final daysLeft = _copingDaysUntilNext(latest);
  if (daysLeft > 0) {
    return 'Next check-in in $daysLeft day${daysLeft == 1 ? '' : 's'} · 6-9am';
  }

  return _isCopingMorningWindow()
      ? 'Check-in available · 6-9am'
      : 'Available tomorrow morning · 6-9am';
}

class _WeeklyToolsSection extends StatelessWidget {
  const _WeeklyToolsSection({
    required this.currentTool,
    required this.completedTools,
    required this.enquiryEntries,
    required this.unwireEntries,
    required this.onOpenTool,
    required this.onOpenDiary,
  });

  final int currentTool;
  final Set<int> completedTools;
  final List<_SimpleWorkEntry> enquiryEntries;
  final List<_SimpleWorkEntry> unwireEntries;
  final ValueChanged<int> onOpenTool;
  final VoidCallback onOpenDiary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your Tools', style: AppTheme.bebas(size: 24)),
        const SizedBox(height: 3),
        Text(
          'Each tool takes one week. Complete one before the next unlocks. This is the order they work in.',
          style: AppTheme.body(
            size: 12,
            color: AppColors.white.withValues(alpha: 0.45),
            height: 1.45,
          ),
        ),
        const SizedBox(height: 14),
        ...List.generate(5, (index) {
          final toolNum = index + 1;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _WeeklyToolCard(
              toolNum: toolNum,
              title: _weeklyToolTitle(toolNum),
              subtitle: _weeklyToolSubtitle(toolNum),
              active: currentTool == toolNum,
              complete: completedTools.contains(toolNum),
              locked:
                  currentTool < toolNum && !completedTools.contains(toolNum),
              onTap: () => onOpenTool(toolNum),
            ),
          );
        }),
        const SizedBox(height: 2),
        GestureDetector(
          onTap: onOpenDiary,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF161B22),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.blue.withValues(alpha: 0.35)),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.blue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.blue.withValues(alpha: 0.35),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text('📓', style: TextStyle(fontSize: 15)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thought Diary',
                        style: AppTheme.body(
                          size: 14,
                          weight: FontWeight.w700,
                          color: AppColors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Daily · runs throughout',
                        style: AppTheme.body(
                          size: 11,
                          weight: FontWeight.w600,
                          color: AppColors.blue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '5 minutes every night at your chosen time. Score your day, write what happened, name the heaviest thought.',
                        style: AppTheme.body(
                          size: 11.5,
                          color: AppColors.white.withValues(alpha: 0.45),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Open →',
                  style: AppTheme.body(
                    size: 11,
                    color: AppColors.blue,
                    weight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WeeklyToolCard extends StatelessWidget {
  const _WeeklyToolCard({
    required this.toolNum,
    required this.title,
    required this.subtitle,
    required this.active,
    required this.complete,
    required this.locked,
    required this.onTap,
  });

  final int toolNum;
  final String title;
  final String subtitle;
  final bool active;
  final bool complete;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = complete
        ? AppColors.success.withValues(alpha: 0.35)
        : active
        ? AppColors.orangeBright
        : AppColors.foundationBorder;
    final fg = locked
        ? AppColors.white.withValues(alpha: 0.32)
        : complete
        ? AppColors.success
        : AppColors.orangeBright;

    return GestureDetector(
      onTap: locked ? null : onTap,
      child: Opacity(
        opacity: locked ? 0.45 : 1,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: complete
                ? const Color(0xFF161E16)
                : active
                ? const Color(0xFF1E1A16)
                : AppColors.toolCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: fg.withValues(alpha: 0.13),
                  border: Border.all(color: fg.withValues(alpha: 0.35)),
                ),
                alignment: Alignment.center,
                child: Text(
                  complete ? '✓' : '$toolNum',
                  style: AppTheme.body(
                    size: 13,
                    weight: FontWeight.w800,
                    color: fg,
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
                      style: AppTheme.body(
                        size: 14,
                        weight: FontWeight.w700,
                        color: locked
                            ? AppColors.white.withValues(alpha: 0.5)
                            : AppColors.white,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Week $toolNum',
                      style: AppTheme.body(
                        size: 11,
                        weight: FontWeight.w600,
                        color: fg,
                      ),
                    ),
                    if (!locked) ...[
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: AppTheme.body(
                          size: 11.5,
                          color: AppColors.white.withValues(alpha: 0.45),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                complete
                    ? 'Done ✓'
                    : active
                    ? 'Start →'
                    : '🔒',
                style: AppTheme.body(
                  size: 11,
                  weight: FontWeight.w700,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FoundationFooter extends StatelessWidget {
  const _FoundationFooter({required this.onLeave});

  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 30),
          decoration: BoxDecoration(
            color: AppColors.toolCard,
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: AppColors.foundationBorder),
          ),
          child: Column(
            children: [
              Text(
                'These tools work\nwhen you do.',
                textAlign: TextAlign.center,
                style: AppTheme.bebas(
                  size: 36,
                  height: 1.05,
                  color: const Color(0xFFF0ECE4),
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Fall down seven times. Get up eight. It doesn\'t matter how many times you fall — it\'s how many times you get back up and keep going. The men who see real change come back. Use this when things get heavy.',
                textAlign: TextAlign.center,
                style: AppTheme.body(
                  size: 12,
                  color: AppColors.foundationMuted,
                  height: 1.7,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
          decoration: const BoxDecoration(
            color: AppColors.black,
            border: Border(top: BorderSide(color: AppColors.foundationBorder)),
          ),
          child: Column(
            children: [
              Text.rich(
                const TextSpan(
                  text: 'You ',
                  children: [
                    TextSpan(
                      text: 'Define',
                      style: TextStyle(color: AppColors.orangeBright),
                    ),
                    TextSpan(text: ' You'),
                  ],
                ),
                style: AppTheme.bebas(
                  size: 25,
                  color: const Color(0xFFF0ECE4),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Men\'s Mental Health · You Define You Mindset',
                textAlign: TextAlign.center,
                style: AppTheme.body(
                  size: 9.5,
                  color: AppColors.foundationMuted,
                  weight: FontWeight.w600,
                ).copyWith(letterSpacing: 1.7),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: 150,
                child: OutlinedButton(
                  onPressed: onLeave,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: AppColors.white.withValues(alpha: 0.1),
                    ),
                    foregroundColor: AppColors.white.withValues(alpha: 0.25),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Leave app',
                    style: AppTheme.body(
                      size: 10.5,
                      color: AppColors.white.withValues(alpha: 0.25),
                      weight: FontWeight.w500,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum _ReliefTool { breathing, tapping, coldWater }

class _DailyToolsSection extends StatefulWidget {
  const _DailyToolsSection({required this.controller});

  final AppController controller;

  @override
  State<_DailyToolsSection> createState() => _DailyToolsSectionState();
}

class _DailyToolsSectionState extends State<_DailyToolsSection> {
  static const int _totalBreathRounds = 4;
  static const List<_BreathPhase> _breathPhases = [
    _BreathPhase(
      label: 'BREATHE IN',
      seconds: 4,
      color: AppColors.success,
      state: _BreathVisualState.expanding,
    ),
    _BreathPhase(
      label: 'HOLD',
      seconds: 4,
      color: AppColors.amber,
      state: _BreathVisualState.holding,
    ),
    _BreathPhase(
      label: 'BREATHE OUT',
      seconds: 4,
      color: Color(0xFF2196F3),
      state: _BreathVisualState.contracting,
    ),
    _BreathPhase(
      label: 'HOLD',
      seconds: 4,
      color: AppColors.amber,
      state: _BreathVisualState.holding,
    ),
  ];

  _ReliefTool _activeTool = _ReliefTool.breathing;
  Timer? _breathTimer;
  bool _breathActive = false;
  bool _breathFinished = false;
  int _breathPhaseIndex = 0;
  int _breathSecond = 0;
  int _breathRound = 0;
  int? _activeTapPoint;

  @override
  void dispose() {
    _breathTimer?.cancel();
    super.dispose();
  }

  void _switchTool(_ReliefTool tool) {
    if (_activeTool == tool) return;
    setState(() {
      _activeTool = tool;
      if (tool != _ReliefTool.tapping) _activeTapPoint = null;
    });
    if (tool != _ReliefTool.breathing) {
      _resetBreathing(clearFinished: true);
    }
  }

  void _toggleBreathing() {
    if (_breathActive) {
      _resetBreathing(clearFinished: true);
      return;
    }

    _breathTimer?.cancel();
    setState(() {
      _breathActive = true;
      _breathFinished = false;
      _breathPhaseIndex = 0;
      _breathSecond = 0;
      _breathRound = 1;
    });

    _breathTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _tickBreathing(),
    );
  }

  void _tickBreathing() {
    if (!mounted) return;

    setState(() {
      _breathSecond++;
      final phase = _breathPhases[_breathPhaseIndex];
      if (_breathSecond < phase.seconds) return;

      _breathSecond = 0;
      _breathPhaseIndex++;

      if (_breathPhaseIndex < _breathPhases.length) return;

      _breathPhaseIndex = 0;
      _breathRound++;

      if (_breathRound <= _totalBreathRounds) return;

      _breathTimer?.cancel();
      _breathTimer = null;
      _breathActive = false;
      _breathFinished = true;
      _breathRound = _totalBreathRounds;
      _breathSecond = 0;
      _breathPhaseIndex = 0;
    });
  }

  void _resetBreathing({required bool clearFinished}) {
    _breathTimer?.cancel();
    _breathTimer = null;
    if (!mounted) return;
    setState(() {
      _breathActive = false;
      _breathPhaseIndex = 0;
      _breathSecond = 0;
      _breathRound = 0;
      if (clearFinished) _breathFinished = false;
    });
  }

  String get _breathButtonLabel {
    if (_breathActive) return 'Stop';
    if (_breathFinished) return 'Start Again →';
    return 'Start Breathing →';
  }

  String get _breathRoundText {
    if (_breathFinished) return '4 rounds complete. Notice the difference.';
    if (_breathActive) return 'Round $_breathRound of $_totalBreathRounds';
    return '';
  }

  _BreathPhase get _currentBreathPhase => _breathPhases[_breathPhaseIndex];

  int get _remainingBreathSeconds {
    if (!_breathActive) return 0;
    return _currentBreathPhase.seconds - _breathSecond;
  }

  double get _breathProgress {
    if (!_breathActive) return 0;
    return _breathSecond / _currentBreathPhase.seconds;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F0F1A), Color(0xFF1A0F0F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.orange.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SosBadge(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('In The Moment', style: AppTheme.bebas(size: 30)),
                    const SizedBox(height: 2),
                    Text(
                      'Anxiety hitting hard right now? Use these first.',
                      style: AppTheme.body(
                        size: 11,
                        color: AppColors.orange,
                        weight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'When the anxiety is live — when your chest is tight, your head is going, you can\'t think straight — the tools aren\'t what you need. These are. They work directly on your nervous system. Use them first, think second.',
            style: AppTheme.body(
              size: 12,
              color: AppColors.white.withValues(alpha: 0.45),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          _ReliefTabs(activeTool: _activeTool, onChanged: _switchTool),
          const SizedBox(height: 18),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: switch (_activeTool) {
              _ReliefTool.breathing => _BreathingReliefPanel(
                key: const ValueKey('breathing'),
                active: _breathActive,
                finished: _breathFinished,
                phase: _currentBreathPhase,
                remainingSeconds: _remainingBreathSeconds,
                progress: _breathProgress,
                roundText: _breathRoundText,
                buttonLabel: _breathButtonLabel,
                onToggle: _toggleBreathing,
              ),
              _ReliefTool.tapping => _TappingReliefPanel(
                key: const ValueKey('tapping'),
                activeIndex: _activeTapPoint,
                onPointTap: (index) => setState(() => _activeTapPoint = index),
              ),
              _ReliefTool.coldWater => const _ColdWaterReliefPanel(
                key: ValueKey('cold-water'),
              ),
            },
          ),
        ],
      ),
    );
  }
}

class _SosBadge extends StatelessWidget {
  const _SosBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AppColors.danger,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: AppColors.danger.withValues(alpha: 0.22),
            blurRadius: 12,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        'SOS',
        style: AppTheme.body(
          size: 8,
          color: AppColors.white,
          weight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

class _ReliefTabs extends StatelessWidget {
  const _ReliefTabs({required this.activeTool, required this.onChanged});

  final _ReliefTool activeTool;
  final ValueChanged<_ReliefTool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _ReliefTabButton(
            label: 'Box Breathing',
            active: activeTool == _ReliefTool.breathing,
            onTap: () => onChanged(_ReliefTool.breathing),
          ),
          _ReliefTabButton(
            label: 'EFT Tapping',
            active: activeTool == _ReliefTool.tapping,
            onTap: () => onChanged(_ReliefTool.tapping),
          ),
          _ReliefTabButton(
            label: 'Cold Water',
            active: activeTool == _ReliefTool.coldWater,
            onTap: () => onChanged(_ReliefTool.coldWater),
          ),
        ],
      ),
    );
  }
}

class _ReliefTabButton extends StatelessWidget {
  const _ReliefTabButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
          decoration: BoxDecoration(
            color: active ? AppColors.orangeBright : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.body(
              size: 10.5,
              color: active
                  ? AppColors.white
                  : AppColors.white.withValues(alpha: 0.42),
              weight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _TechniqueIntro extends StatelessWidget {
  const _TechniqueIntro({required this.children});

  final List<String> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.white.withValues(alpha: 0.07)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WHY IT WORKS',
            style: AppTheme.body(
              size: 9.5,
              color: AppColors.orangeBright,
              weight: FontWeight.w800,
              height: 1.2,
            ).copyWith(letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),
          ...children.map(
            (text) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                text,
                style: AppTheme.body(
                  size: 11.5,
                  color: AppColors.white.withValues(alpha: 0.5),
                  height: 1.62,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BreathingReliefPanel extends StatelessWidget {
  const _BreathingReliefPanel({
    super.key,
    required this.active,
    required this.finished,
    required this.phase,
    required this.remainingSeconds,
    required this.progress,
    required this.roundText,
    required this.buttonLabel,
    required this.onToggle,
  });

  final bool active;
  final bool finished;
  final _BreathPhase phase;
  final int remainingSeconds;
  final double progress;
  final String roundText;
  final String buttonLabel;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _TechniqueIntro(
          children: [
            'Box breathing directly activates your parasympathetic nervous system — the one that tells your body it\'s safe. Navy SEALs use this before combat. You can use it before anything. Four seconds in, four hold, four out, four hold. The box. Do four rounds and you will feel different.',
          ],
        ),
        const SizedBox(height: 20),
        _BreathGuide(
          active: active,
          finished: finished,
          phase: phase,
          remainingSeconds: remainingSeconds,
          progress: progress,
          roundText: roundText,
          buttonLabel: buttonLabel,
          onToggle: onToggle,
        ),
        const SizedBox(height: 18),
        Text(
          'HOW IT WORKS — FOLLOW ALONG OR READ BELOW',
          style: AppTheme.body(
            size: 10,
            color: AppColors.white.withValues(alpha: 0.25),
            weight: FontWeight.w800,
          ).copyWith(letterSpacing: 1.1),
        ),
        const SizedBox(height: 12),
        const _ReliefStep(
          badge: '4s',
          color: AppColors.success,
          title: 'Breathe IN through your nose',
          text:
              'Slow and steady. Fill from the bottom of your lungs first, then up. Count 1, 2, 3, 4.',
        ),
        const _ReliefStep(
          badge: '4s',
          color: AppColors.amber,
          title: 'HOLD — don\'t breathe',
          text:
              'Lungs full. Hold it. Count 1, 2, 3, 4. This is where the regulation happens.',
        ),
        const _ReliefStep(
          badge: '4s',
          color: Color(0xFF2196F3),
          title: 'Breathe OUT through your mouth',
          text:
              'Slow, controlled exhale. Longer than the inhale if you can. Count 1, 2, 3, 4.',
        ),
        const _ReliefStep(
          badge: '4s',
          color: AppColors.amber,
          title: 'HOLD — empty lungs',
          text: 'Lungs empty. Hold. Count 1, 2, 3, 4. Then start again.',
        ),
        const _ReliefNote(
          'Do 4 complete rounds. Takes under 2 minutes. Do it before you try to think about anything.',
        ),
      ],
    );
  }
}

class _BreathGuide extends StatelessWidget {
  const _BreathGuide({
    required this.active,
    required this.finished,
    required this.phase,
    required this.remainingSeconds,
    required this.progress,
    required this.roundText,
    required this.buttonLabel,
    required this.onToggle,
  });

  final bool active;
  final bool finished;
  final _BreathPhase phase;
  final int remainingSeconds;
  final double progress;
  final String roundText;
  final String buttonLabel;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final displayLabel = active
        ? phase.label
        : finished
        ? 'DONE'
        : 'TAP TO START';
    final displayCount = active
        ? '$remainingSeconds'
        : finished
        ? '✓'
        : '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.white.withValues(alpha: 0.06)),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _BreathRingPainter(
                      color: active ? phase.color : AppColors.orange,
                      progress: active ? progress : 0,
                    ),
                  ),
                ),
                AnimatedScale(
                  scale: switch (phase.state) {
                    _BreathVisualState.expanding when active => 1.12,
                    _BreathVisualState.contracting when active => 0.88,
                    _ => 1,
                  },
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeInOutCubic,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 700),
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (active ? phase.color : AppColors.orange)
                          .withValues(alpha: 0.1),
                      border: Border.all(
                        color: (active ? phase.color : AppColors.orange)
                            .withValues(alpha: active ? 0.48 : 0.25),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          displayLabel,
                          textAlign: TextAlign.center,
                          style: AppTheme.body(
                            size: 10,
                            color: AppColors.white,
                            weight: FontWeight.w900,
                            height: 1,
                          ).copyWith(letterSpacing: 1.1),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          displayCount,
                          style: AppTheme.bebas(
                            size: 32,
                            color: AppColors.orangeBright,
                            height: 0.9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: onToggle,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppColors.orangeBright,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              buttonLabel,
              style: AppTheme.bebas(
                size: 16,
                color: AppColors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 18,
            child: Text(
              roundText,
              textAlign: TextAlign.center,
              style: AppTheme.body(
                size: 10.5,
                color: AppColors.white.withValues(alpha: 0.35),
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BreathRingPainter extends CustomPainter {
  const _BreathRingPainter({required this.color, required this.progress});

  final Color color;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2 - 5;
    final backgroundPaint = Paint()
      ..color = AppColors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: [color.withValues(alpha: 0.35), color],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -1.5708,
        6.28318 * progress.clamp(0, 1),
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BreathRingPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.progress != progress;
  }
}

class _ReliefStep extends StatelessWidget {
  const _ReliefStep({
    required this.badge,
    required this.color,
    required this.title,
    required this.text,
  });

  final String badge;
  final Color color;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.15),
              border: Border.all(color: color.withValues(alpha: 0.4), width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              badge,
              style: AppTheme.bebas(size: 14, color: color, height: 1),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.body(
                    size: 12.5,
                    color: AppColors.white,
                    weight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: AppTheme.body(
                    size: 11,
                    color: AppColors.white.withValues(alpha: 0.45),
                    height: 1.45,
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

class _ReliefNote extends StatelessWidget {
  const _ReliefNote(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.orange.withValues(alpha: 0.36),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTheme.body(
                size: 11,
                color: AppColors.white.withValues(alpha: 0.32),
                fontStyle: FontStyle.italic,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TappingReliefPanel extends StatelessWidget {
  const _TappingReliefPanel({
    super.key,
    required this.activeIndex,
    required this.onPointTap,
  });

  static const List<_TapPointData> _points = [
    _TapPointData(
      name: 'Top of the Head',
      where: 'Crown — centre of the top of your skull',
      phrase: '"This anxiety / this overwhelm / this pressure I\'m carrying"',
      emoji: '👆',
      color: Color(0xFFE53935),
    ),
    _TapPointData(
      name: 'Eyebrow',
      where: 'Inner corner, where eyebrow meets nose bridge',
      phrase: '"All this stress I\'ve been holding"',
      emoji: '😤',
      color: Color(0xFFE67E22),
    ),
    _TapPointData(
      name: 'Side of Eye',
      where: 'Outer corner of the eye, on the bone',
      phrase: '"My mind won\'t slow down"',
      emoji: '👁',
      color: Color(0xFFF39C12),
    ),
    _TapPointData(
      name: 'Under Eye',
      where: 'Directly below the eye, on the cheekbone',
      phrase: '"Everything feels too much right now"',
      emoji: '😟',
      color: Color(0xFF27AE60),
    ),
    _TapPointData(
      name: 'Under Nose',
      where: 'Between nose and upper lip',
      phrase: '"I can\'t stop these thoughts"',
      emoji: '👃',
      color: Color(0xFF16A085),
    ),
    _TapPointData(
      name: 'Chin',
      where: 'Midpoint between lower lip and chin',
      phrase: '"This fear / this worry that won\'t leave me alone"',
      emoji: '🫤',
      color: Color(0xFF2980B9),
    ),
    _TapPointData(
      name: 'Collarbone',
      where: 'Just below where collar meets chest — either side',
      phrase: '"Even with all of this — I\'m still here"',
      emoji: '💪',
      color: Color(0xFF8E44AD),
    ),
    _TapPointData(
      name: 'Under Arm',
      where: 'Side of ribcage, about 4 inches below armpit',
      phrase: '"I\'m dealing with a lot — and I\'m still standing"',
      emoji: '🤜',
      color: Color(0xFFC0392B),
    ),
  ];

  final int? activeIndex;
  final ValueChanged<int> onPointTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _TechniqueIntro(
          children: [
            'EFT (Emotional Freedom Technique) works by tapping specific acupressure points on the body while naming what you\'re feeling. It interrupts the stress response at a physical level — the tapping sends calming signals to the amygdala, the part of your brain that fires the panic response. It looks strange. It works.',
            'You say the problem out loud while you tap. This isn\'t therapy — it\'s reprogramming your nervous system\'s reaction to the thought.',
          ],
        ),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.orange.withValues(alpha: 0.07),
            border: Border.all(color: AppColors.orange.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'START HERE — SAY THIS OUT LOUD (OR IN YOUR HEAD)',
                style: AppTheme.body(
                  size: 9.5,
                  color: AppColors.orangeBright,
                  weight: FontWeight.w800,
                ).copyWith(letterSpacing: 1),
              ),
              const SizedBox(height: 8),
              Text(
                '"Even though I feel [anxious / overwhelmed / stressed right now], I completely accept myself."',
                style: AppTheme.body(
                  size: 12.5,
                  color: AppColors.white,
                  weight: FontWeight.w800,
                  fontStyle: FontStyle.italic,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Say it three times while tapping the side of your hand (the karate chop point). You don\'t have to believe it. Just say it.',
                style: AppTheme.body(
                  size: 10.5,
                  color: AppColors.white.withValues(alpha: 0.4),
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'THEN TAP EACH POINT 5-7 TIMES, IN ORDER',
          style: AppTheme.body(
            size: 10,
            color: AppColors.white.withValues(alpha: 0.25),
            weight: FontWeight.w800,
          ).copyWith(letterSpacing: 1),
        ),
        const SizedBox(height: 10),
        ...List.generate(
          _points.length,
          (index) => _TapPointCard(
            index: index,
            point: _points[index],
            active: activeIndex == index,
            onTap: () => onPointTap(index),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.03),
            border: Border.all(color: AppColors.white.withValues(alpha: 0.08)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FINISH WITH THIS',
                style: AppTheme.body(
                  size: 9.5,
                  color: AppColors.white.withValues(alpha: 0.3),
                  weight: FontWeight.w800,
                ).copyWith(letterSpacing: 1),
              ),
              const SizedBox(height: 8),
              Text(
                '"I choose to release this anxiety. I choose to feel calm. I\'m safe right now."',
                style: AppTheme.body(
                  size: 12,
                  color: AppColors.white,
                  weight: FontWeight.w800,
                  fontStyle: FontStyle.italic,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Tap the top of your head while you say this. Take a deep breath. Notice the difference.',
                style: AppTheme.body(
                  size: 10.5,
                  color: AppColors.white.withValues(alpha: 0.35),
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        const _ReliefNote(
          'Do two full rounds — takes about 3 minutes. Most men notice a physical shift by the end of the first round.',
        ),
      ],
    );
  }
}

class _TapPointCard extends StatelessWidget {
  const _TapPointCard({
    required this.index,
    required this.point,
    required this.active,
    required this.onTap,
  });

  final int index;
  final _TapPointData point;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: active
              ? AppColors.orange.withValues(alpha: 0.08)
              : AppColors.white.withValues(alpha: 0.02),
          border: Border.all(
            color: active
                ? AppColors.orangeBright
                : AppColors.white.withValues(alpha: 0.07),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: point.color,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${index + 1}',
                    style: AppTheme.body(
                      size: 10,
                      color: AppColors.white,
                      weight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        point.name,
                        style: AppTheme.body(
                          size: 12.2,
                          color: AppColors.white,
                          weight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        point.where,
                        style: AppTheme.body(
                          size: 10,
                          color: AppColors.white.withValues(alpha: 0.35),
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(point.emoji, style: const TextStyle(fontSize: 17)),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Text(
                point.phrase,
                style: AppTheme.body(
                  size: 10.8,
                  color: AppColors.white.withValues(alpha: active ? 0.75 : 0.5),
                  fontStyle: FontStyle.italic,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColdWaterReliefPanel extends StatelessWidget {
  const _ColdWaterReliefPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _TechniqueIntro(
          children: [
            'Cold water triggers the mammalian dive reflex — an evolutionary mechanism that immediately slows your heart rate and shifts your nervous system from fight-or-flight to a calmer state. It\'s one of the fastest physiological resets available to you. No kit, no app, no prescription. Just cold water.',
            'When anxiety is acute — when you\'re shaking, chest tight, can\'t think — this cuts through in under 30 seconds.',
          ],
        ),
        const SizedBox(height: 18),
        const _ColdOptionCard(
          badge: 'OPTION A',
          badgeColor: Color(0xFF64B5F6),
          title: 'Face in Cold Water — Fastest',
          time: '~30 seconds',
          steps: [
            'Fill a bowl or sink with cold water. As cold as you can get it. Add ice if you have it.',
            'Take a deep breath and hold it.',
            'Submerge your face — forehead, eyes, cheeks. Hold for 15–30 seconds.',
            'Come up. Breathe slowly. You will feel the shift immediately.',
          ],
          why:
              'This directly activates the dive reflex. Heart rate drops 10-25% within seconds. The panic response doesn\'t survive it.',
        ),
        const _ColdOptionCard(
          badge: 'OPTION B',
          badgeColor: Color(0xFF4DD0E1),
          title: 'Cold Wrists & Neck — Anywhere',
          time: '~60 seconds',
          steps: [
            'Run cold water over the inside of both wrists for 30 seconds. These are pulse points — blood cools fast here.',
            'Then hold a cold, wet cloth to the back of your neck for 30 seconds.',
            'Breathe slowly throughout. In through nose, out through mouth.',
          ],
          why:
              'Works anywhere — office bathroom, public toilet, gym. No one needs to know what you\'re doing.',
        ),
        const _ColdOptionCard(
          badge: 'OPTION C',
          badgeColor: Color(0xFF7986CB),
          title: 'Cold Shower — Full Reset',
          time: '2-3 minutes',
          steps: [
            'Normal shower first if you want. Last 60-90 seconds: turn it cold. As cold as it goes.',
            'Don\'t thrash around. Stand in it. Breathe deliberately — this is the practice.',
            'After: you will not feel anxious. The body cannot maintain the stress response and tolerate cold at the same time.',
          ],
          why:
              'Regular cold exposure (3x per week) builds long-term stress resilience. Short term: immediate anxiety relief. This is one of the most evidence-backed techniques available.',
        ),
        const _ReliefNote(
          'These aren\'t coping strategies that mask the anxiety. They physically interrupt the stress response at the nervous system level. Use them when you\'re in it — then come back to the tools.',
        ),
      ],
    );
  }
}

class _ColdOptionCard extends StatelessWidget {
  const _ColdOptionCard({
    required this.badge,
    required this.badgeColor,
    required this.title,
    required this.time,
    required this.steps,
    required this.why,
  });

  final String badge;
  final Color badgeColor;
  final String title;
  final String time;
  final List<String> steps;
  final String why;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.white.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.04),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badge,
                    style: AppTheme.body(
                      size: 8.5,
                      color: badgeColor,
                      weight: FontWeight.w900,
                      height: 1,
                    ).copyWith(letterSpacing: 0.8),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: AppTheme.body(
                      size: 12,
                      color: AppColors.white,
                      weight: FontWeight.w800,
                      height: 1.25,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  time,
                  style: AppTheme.body(
                    size: 9.5,
                    color: AppColors.white.withValues(alpha: 0.3),
                    weight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(13),
            child: Column(
              children: [
                ...List.generate(
                  steps.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: badgeColor.withValues(alpha: 0.15),
                            border: Border.all(
                              color: badgeColor.withValues(alpha: 0.3),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${index + 1}',
                            style: AppTheme.body(
                              size: 9,
                              color: badgeColor,
                              weight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            steps[index],
                            style: AppTheme.body(
                              size: 11,
                              color: AppColors.white.withValues(alpha: 0.55),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 9),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: AppColors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                  child: Text(
                    why,
                    style: AppTheme.body(
                      size: 10.5,
                      color: badgeColor.withValues(alpha: 0.75),
                      fontStyle: FontStyle.italic,
                      height: 1.45,
                    ),
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

enum _BreathVisualState { expanding, holding, contracting }

class _BreathPhase {
  const _BreathPhase({
    required this.label,
    required this.seconds,
    required this.color,
    required this.state,
  });

  final String label;
  final int seconds;
  final Color color;
  final _BreathVisualState state;
}

class _TapPointData {
  const _TapPointData({
    required this.name,
    required this.where,
    required this.phrase,
    required this.emoji,
    required this.color,
  });

  final String name;
  final String where;
  final String phrase;
  final String emoji;
  final Color color;
}

class _FoundationSubmitButton extends StatelessWidget {
  const _FoundationSubmitButton({
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.orangeBright,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.orangeBright.withValues(
            alpha: 0.23,
          ),
          disabledForegroundColor: AppColors.orangeBright.withValues(
            alpha: 0.45,
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          label,
          style: AppTheme.bebas(
            size: 17,
            color: enabled
                ? AppColors.white
                : AppColors.orangeBright.withValues(alpha: 0.45),
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

class _FoundationTextField extends StatelessWidget {
  const _FoundationTextField({
    required this.controller,
    required this.onChanged,
    required this.hintText,
    this.maxLines = 1,
    this.compact = false,
    this.textAlign = TextAlign.start,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;
  final int maxLines;
  final bool compact;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: maxLines,
      textAlign: textAlign,
      style: AppTheme.body(
        size: compact ? 11 : 12,
        color: AppColors.white,
        height: 1.45,
      ),
      cursorColor: AppColors.orangeBright,
      decoration: InputDecoration(
        hintText: hintText,
        isDense: true,
        filled: true,
        fillColor: AppColors.foundationGrey,
        contentPadding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 12,
          vertical: compact ? 11 : 13,
        ),
        hintStyle: AppTheme.body(
          size: compact ? 10.5 : 11.5,
          color: AppColors.foundationMuted.withValues(alpha: 0.58),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.foundationBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.orangeBright),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.foundationBorder),
        ),
      ),
    );
  }
}

class _IntroLine extends StatelessWidget {
  const _IntroLine(
    this.text, {
    this.color = AppColors.white,
    this.weight = FontWeight.w700,
  });

  final String text;
  final Color color;
  final FontWeight weight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTheme.body(
        size: 12,
        color: color,
        weight: weight,
        height: 1.42,
      ),
    );
  }
}

class _IntroGap extends StatelessWidget {
  const _IntroGap(this.height);

  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}

class _FoundationStepScreen extends StatelessWidget {
  const _FoundationStepScreen({
    required this.controller,
    required this.stepIndex,
    required this.onBack,
    required this.onFinished,
  });

  final AppController controller;
  final int stepIndex;
  final VoidCallback onBack;
  final ValueChanged<bool> onFinished;

  @override
  Widget build(BuildContext context) {
    return YdyShell(
      safeBottom: false,
      showGlow: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 44, 24, 16),
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
                        'STEP ${stepIndex + 1} OF 4',
                        style: AppTheme.body(
                          size: 9.5,
                          weight: FontWeight.w500,
                          color: AppColors.orangeBright,
                        ).copyWith(letterSpacing: 1.7),
                      ),
                      Text(
                        [
                          'LIFE ASSESSMENT',
                          'LIMITING BELIEFS',
                          'YOUR TIMELINE',
                          'ANXIETY CHECKLIST',
                        ][stepIndex],
                        style: AppTheme.bebas(size: 26, letterSpacing: 1),
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
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
              children: [
                _stepIntro(stepIndex),
                const SizedBox(height: 18),
                if (stepIndex == 0) _lifeAssessment(),
                if (stepIndex == 1) _beliefsStep(),
                if (stepIndex == 2) _timelineStep(context),
                if (stepIndex == 3) _triggersStep(),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
            decoration: const BoxDecoration(
              color: Color(0xFF0F0800),
              border: Border(
                top: BorderSide(color: AppColors.foundationBorder),
              ),
            ),
            child: _FoundationSubmitButton(
              label: [
                'Submit Life Assessment →',
                'Submit My Beliefs →',
                'Submit My Timeline →',
                'Submit Anxiety Checklist →',
              ][stepIndex],
              enabled: _stepReady(stepIndex),
              onPressed: () async {
                final wasFoundationComplete =
                    controller.completedFoundationCount == 4;
                await controller.completeFoundationStep(stepIndex);
                final allComplete = controller.completedFoundationCount == 4;
                if (context.mounted) {
                  await showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    barrierColor: Colors.black.withValues(alpha: 0.88),
                    builder: (context) => _FoundationCompleteDialog(
                      stepIndex: stepIndex,
                      allComplete: allComplete,
                    ),
                  );
                }
                if (context.mounted) {
                  onFinished(allComplete && !wasFoundationComplete);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepIntro(int stepIndex) {
    final children = switch (stepIndex) {
      0 => const [
        _IntroLine(
          'How to use this tool:',
          color: AppColors.orangeBright,
          weight: FontWeight.w800,
        ),
        _IntroGap(8),
        _IntroLine(
          'Look at each area of your life and give it an honest score out of 10 by tapping the number that feels right. Then write a short note on what it would need to get to a 10.',
        ),
        _IntroGap(8),
        _IntroLine(
          'Don\'t overthink it — go with your gut. There are no right or wrong answers, just honest ones.',
        ),
        _IntroGap(10),
        _IntroLine(
          '1 = As bad as it gets. This area of your life is causing real pain.',
        ),
        _IntroGap(5),
        _IntroLine('5 = It\'s ok. Not great, not awful. You\'re getting by.'),
        _IntroGap(5),
        _IntroLine(
          '10 = Couldn\'t be better. You genuinely couldn\'t ask for more here.',
        ),
        _IntroGap(10),
        _IntroLine(
          '⚠ This step must be completed before you can move to the next section.',
          color: AppColors.orangeBright,
          weight: FontWeight.w800,
        ),
      ],
      1 => const [
        _IntroLine(
          'These are beliefs men carry without ever saying out loud. Tick the ones that have held you back — even the ones that are uncomfortable to admit.',
        ),
        _IntroGap(10),
        _IntroLine(
          'The ones you nearly skipped past are usually the most important.',
        ),
      ],
      2 => const [
        _IntroLine(
          'How to use this tool:',
          color: AppColors.orangeBright,
          weight: FontWeight.w800,
        ),
        _IntroGap(8),
        _IntroLine(
          'List the key moments in your life — highs and lows. If you\'re 40, aim for 15 to 20 events. There should be something at least every other year.',
        ),
        _IntroGap(8),
        _IntroLine(
          'Don\'t skip the difficult ones. They\'re usually the most important.',
        ),
        _IntroGap(10),
        _IntroLine(
          '⚠ This step must be completed before you can move to the next section.',
          color: AppColors.orangeBright,
          weight: FontWeight.w800,
        ),
      ],
      _ => const [
        _IntroLine(
          'Anxiety shows up when we feel out of control or when something triggers one of our limiting beliefs. Tick everything that applies to you.',
        ),
        _IntroGap(10),
        _IntroLine('No judgment. This is just the map.'),
      ],
    };

    return ClipRRect(
      borderRadius: BorderRadius.circular(9),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 15, 15, 15),
            decoration: BoxDecoration(
              color: const Color(0xFF21140D),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: AppColors.orangeBright.withValues(alpha: 0.72),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(width: 5, color: AppColors.orangeBright),
          ),
        ],
      ),
    );
  }

  Widget _lifeAssessment() {
    return Column(
      children: AppContent.lifeAreas.map((area) {
        final score = controller.lifeScores[area] ?? 0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(14, 13, 14, 15),
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
                            size: 12.5,
                            weight: FontWeight.w500,
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          score == 0 ? '—' : '$score',
                          style: AppTheme.bebas(
                            size: 24,
                            color: AppColors.orangeBright,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
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
                              height: 23,
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
                                  size: 9,
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
              _FoundationTextField(
                controller:
                    TextEditingController(
                        text: controller.lifeNotes[area] ?? '',
                      )
                      ..selection = TextSelection.collapsed(
                        offset: (controller.lifeNotes[area] ?? '').length,
                      ),
                onChanged: (value) => controller.updateLifeNote(area, value),
                maxLines: 3,
                hintText: 'What\'s it missing to get to a 10?',
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
        Row(
          children: [
            Text(
              '${controller.selectedBeliefs.length} selected',
              style: AppTheme.body(
                size: 11,
                weight: FontWeight.w800,
                color: controller.selectedBeliefs.isEmpty
                    ? AppColors.foundationMuted.withValues(alpha: 0.5)
                    : AppColors.orangeBright,
              ),
            ),
            const Spacer(),
            Text(
              'Select up to 5 to start with',
              style: AppTheme.body(
                size: 10,
                weight: FontWeight.w500,
                color: AppColors.foundationMuted.withValues(alpha: 0.58),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Tick everything that applies to you',
          style: AppTheme.body(
            size: 10,
            weight: FontWeight.w800,
            color: AppColors.foundationMuted,
          ).copyWith(letterSpacing: 1.3),
        ),
        const SizedBox(height: 9),
        ...List.generate(AppContent.beliefs.length, (index) {
          final selected = controller.selectedBeliefs.contains(index);
          final locked = !selected && controller.selectedBeliefs.length >= 5;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: locked ? null : () => controller.toggleBelief(index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
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
                          size: 12,
                          color: locked
                              ? AppColors.deepDimText
                              : AppColors.white,
                          height: 1.25,
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

  Widget _timelineStep(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => showDialog<void>(
              context: context,
              builder: (context) => const _TimelineExampleDialog(),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: AppColors.orangeBright.withValues(alpha: 0.45),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              foregroundColor: AppColors.orangeBright,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
            ),
            child: Text(
              '⊕ See an example timeline',
              style: AppTheme.body(
                size: 11,
                weight: FontWeight.w700,
                color: AppColors.orangeBright,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        ...List.generate(controller.timeline.length, (index) {
          final item = controller.timeline[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 13),
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
                        width: 62,
                        child: _FoundationTextField(
                          controller: TextEditingController(text: item.year)
                            ..selection = TextSelection.collapsed(
                              offset: item.year.length,
                            ),
                          onChanged: (value) =>
                              controller.updateTimelineYear(index, value),
                          hintText: 'Year',
                          maxLines: 1,
                          compact: true,
                          textAlign: TextAlign.center,
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
                          style: IconButton.styleFrom(
                            minimumSize: const Size(30, 30),
                            fixedSize: const Size(30, 30),
                            padding: EdgeInsets.zero,
                            side: const BorderSide(
                              color: AppColors.foundationBorder,
                            ),
                          ),
                          icon: const Icon(
                            Icons.close,
                            size: 14,
                            color: AppColors.foundationMuted,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _FoundationTextField(
                    controller: TextEditingController(text: item.event)
                      ..selection = TextSelection.collapsed(
                        offset: item.event.length,
                      ),
                    onChanged: (value) =>
                        controller.updateTimelineEvent(index, value),
                    maxLines: 3,
                    hintText: 'What happened? Keep it brief.',
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: controller.addTimelineEvent,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: AppColors.foundationBorder.withValues(alpha: 0.85),
              ),
              foregroundColor: AppColors.foundationMuted,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            ),
            child: Text(
              '+ Add another event',
              style: AppTheme.body(size: 12, color: AppColors.foundationMuted),
            ),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
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
                                    size: 12.5,
                                    weight: FontWeight.w500,
                                    color: AppColors.white,
                                  ),
                                ),
                                if (selected) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    trigger['desc']!,
                                    style: AppTheme.body(
                                      size: 10.5,
                                      color: AppColors.foundationMuted,
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
        padding: const EdgeInsets.symmetric(vertical: 9),
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
            size: 10,
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
  bool _editingToday = false;

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
    } else {
      _editingToday = true;
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
    return _ToolSheetFrame(
      title: 'Thought Diary',
      child: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          final todayEntry = widget.controller.todayDiaryEntry;
          final entries = widget.controller.diaryEntries;
          final showForm = todayEntry == null || _editingToday;

          return ListView(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              MediaQuery.of(context).viewInsets.bottom + 28,
            ),
            children: [
              _DiaryGuideCard(showNudge: entries.isEmpty),
              const SizedBox(height: 18),
              _DiarySectionHeader(
                label: 'Tonight\'s Entry',
                trailing:
                    todayEntry?.dateLabel ?? _diaryDateLabel(DateTime.now()),
              ),
              const SizedBox(height: 10),
              if (!showForm)
                _DiarySavedEntryCard(
                  entry: todayEntry,
                  onEdit: () => setState(() => _editingToday = true),
                )
              else
                _buildEntryForm(),
              if (entries.isNotEmpty) ...[
                const SizedBox(height: 24),
                const _DiarySectionHeader(
                  label: 'Your Week at a Glance',
                  trailing: '',
                ),
                const SizedBox(height: 5),
                Text(
                  'Green = good day (8-10) · Amber = tough day (5-7) · Red = hard day (1-4)',
                  style: AppTheme.body(
                    size: 10,
                    color: AppColors.white.withValues(alpha: 0.25),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                _DiaryWeekChart(entries: entries),
                const SizedBox(height: 24),
                const _DiarySectionHeader(
                  label: 'Recent Entries',
                  trailing: '',
                ),
                const SizedBox(height: 10),
                ..._recentDiaryEntries(entries).map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _DiaryEntryCard(entry: entry),
                  ),
                ),
              ],
              if (entries.length >= 7) ...[
                const SizedBox(height: 16),
                _DiaryWeeklyBreakdown(entries: entries),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildEntryForm() {
    return Column(
      children: [
        _DiaryFormStep(
          step: '1',
          title: 'Score today 1-10',
          hint:
              'Gut number. Don\'t overthink it. 1 = couldn\'t function. 10 = genuinely thriving.',
          child: _DiaryScoreSelector(
            selectedScore: score,
            onSelected: (value) => setState(() => score = value),
          ),
        ),
        if (score != null) ...[
          _DiaryFormStep(
            step: '2',
            title: _diaryWhyTitle(score!),
            hint: _diaryWhyHint(score!),
            child: _DiaryTextArea(
              controller: whyController,
              hint: _diaryWhyPlaceholder(score!),
              maxLines: 3,
            ),
          ),
          _DiaryFormStep(
            step: '3',
            title: 'What happened today?',
            hint:
                'The events that shaped the day. Two or three honest sentences — raw is better than polished.',
            child: _DiaryTextArea(
              controller: happenedController,
              hint: 'What happened — the good and the hard...',
              maxLines: 4,
            ),
          ),
          _DiaryFormStep(
            step: '4',
            title: 'What\'s the heaviest thought right now?',
            hint:
                'Write it down and park it. You\'re not solving it tonight — you\'re emptying your head so your brain can rest.',
            child: _DiaryTextArea(
              controller: thoughtController,
              hint: 'The thought sitting with you as you go to sleep...',
              maxLines: 3,
            ),
          ),
          const SizedBox(height: 6),
          YdyButton(
            label: 'Save Tonight\'s Entry →',
            enabled: ready,
            onPressed: ready
                ? () async {
                    await widget.controller.saveDiaryEntry(
                      score: score!,
                      why: whyController.text.trim(),
                      happened: happenedController.text.trim(),
                      thought: thoughtController.text.trim(),
                    );
                    if (!mounted) return;
                    FocusScope.of(context).unfocus();
                    setState(() => _editingToday = false);
                  }
                : null,
          ),
        ],
      ],
    );
  }
}

class _DiaryGuideCard extends StatelessWidget {
  const _DiaryGuideCard({required this.showNudge});

  final bool showNudge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: AppColors.orange.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.orange.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HOW THE THOUGHT DIARY WORKS',
            style: AppTheme.body(
              size: 9.5,
              weight: FontWeight.w800,
              color: AppColors.orange,
              height: 1,
            ).copyWith(letterSpacing: 1.25),
          ),
          const SizedBox(height: 9),
          Text(
            '5 minutes every night before you go to sleep. That\'s all. Score your day, write what happened, name the thought that\'s sitting heaviest. Do it consistently and after 7 days you\'ll see your week in a way you never have — the dips, the triggers, the patterns. That\'s the intel that lets you prepare instead of just react.',
            style: AppTheme.body(
              size: 11.5,
              color: AppColors.white.withValues(alpha: 0.5),
              height: 1.55,
            ),
          ),
          const SizedBox(height: 12),
          const _DiaryGuideStep(
            step: '1',
            title: 'Score your day 1-10',
            text:
                'Gut number — don\'t overthink it. 1 = couldn\'t function. 10 = genuinely thriving. Be honest.',
          ),
          const _DiaryGuideStep(
            step: '2',
            title: 'Tell us why — what pushed it up or down?',
            text:
                'A score without a reason is just a number. What happened today that shaped it?',
          ),
          const _DiaryGuideStep(
            step: '3',
            title: 'Write what happened',
            text:
                'The events of the day. Don\'t dress it up. What actually happened — the stuff that affected you?',
          ),
          const _DiaryGuideStep(
            step: '4',
            title: 'Name the heaviest thought',
            text:
                'Write it down and park it. Getting it on paper breaks the loop so your head can rest.',
          ),
          if (showNudge) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Even on a good day — fill it in. The good entries are just as important as the hard ones.',
                style: AppTheme.body(
                  size: 10.5,
                  color: AppColors.white.withValues(alpha: 0.35),
                  height: 1.45,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DiaryGuideStep extends StatelessWidget {
  const _DiaryGuideStep({
    required this.step,
    required this.title,
    required this.text,
  });

  final String step;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.orange.withValues(alpha: 0.15),
              border: Border.all(
                color: AppColors.orange.withValues(alpha: 0.3),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              step,
              style: AppTheme.body(
                size: 9.5,
                weight: FontWeight.w800,
                color: AppColors.orange,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.body(
                    size: 11.5,
                    weight: FontWeight.w800,
                    color: AppColors.white,
                    height: 1.22,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  text,
                  style: AppTheme.body(
                    size: 10.5,
                    color: AppColors.white.withValues(alpha: 0.42),
                    height: 1.42,
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

class _DiarySectionHeader extends StatelessWidget {
  const _DiarySectionHeader({required this.label, required this.trailing});

  final String label;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label.toUpperCase(),
            style: AppTheme.body(
              size: 10.5,
              weight: FontWeight.w800,
              color: AppColors.white.withValues(alpha: 0.32),
              height: 1,
            ).copyWith(letterSpacing: 1.45),
          ),
        ),
        if (trailing.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Text(
              trailing,
              style: AppTheme.body(
                size: 10,
                weight: FontWeight.w600,
                color: AppColors.white.withValues(alpha: 0.34),
                height: 1,
              ),
            ),
          ),
      ],
    );
  }
}

class _DiaryFormStep extends StatelessWidget {
  const _DiaryFormStep({
    required this.step,
    required this.title,
    required this.hint,
    required this.child,
  });

  final String step;
  final String title;
  final String hint;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.orange.withValues(alpha: 0.12),
              border: Border.all(
                color: AppColors.orange.withValues(alpha: 0.32),
                width: 1.4,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              step,
              style: AppTheme.bebas(
                size: 18,
                color: AppColors.orange,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.body(
                    size: 12.5,
                    weight: FontWeight.w800,
                    color: AppColors.white,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  hint,
                  style: AppTheme.body(
                    size: 10.5,
                    color: AppColors.white.withValues(alpha: 0.35),
                    height: 1.42,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 9),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DiaryScoreSelector extends StatelessWidget {
  const _DiaryScoreSelector({
    required this.selectedScore,
    required this.onSelected,
  });

  final int? selectedScore;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 7,
      children: List.generate(10, (index) {
        final value = index + 1;
        final selected = selectedScore == value;

        return GestureDetector(
          onTap: () => onSelected(value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 34,
            height: 34,
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
                size: 12,
                weight: FontWeight.w800,
                color: selected
                    ? AppColors.white
                    : AppColors.white.withValues(alpha: 0.48),
                height: 1,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _DiaryTextArea extends StatelessWidget {
  const _DiaryTextArea({
    required this.controller,
    required this.hint,
    required this.maxLines,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: AppTheme.body(size: 12, color: AppColors.white, height: 1.48),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.white.withValues(alpha: 0.05),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 12,
        ),
        hintStyle: AppTheme.body(
          size: 11.5,
          color: AppColors.white.withValues(alpha: 0.2),
          height: 1.4,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.foundationBorder.withValues(alpha: 0.84),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.orange.withValues(alpha: 0.5),
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _DiarySavedEntryCard extends StatelessWidget {
  const _DiarySavedEntryCard({required this.entry, required this.onEdit});

  final ThoughtDiaryEntry entry;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final color = _diaryScoreColor(entry.score);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 54,
                child: Column(
                  children: [
                    Text(
                      '${entry.score}',
                      style: AppTheme.bebas(size: 46, color: color, height: 1),
                    ),
                    Text(
                      'out of 10',
                      style: AppTheme.body(
                        size: 9,
                        color: AppColors.white.withValues(alpha: 0.3),
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DiaryMiniLine(label: 'Why', text: entry.why),
                    const SizedBox(height: 8),
                    Text(
                      entry.happened,
                      style: AppTheme.body(
                        size: 11.5,
                        color: AppColors.white.withValues(alpha: 0.58),
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Thought: ${entry.heaviestThought}',
                      style: AppTheme.body(
                        size: 11,
                        color: AppColors.white.withValues(alpha: 0.35),
                        height: 1.42,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onEdit,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              foregroundColor: AppColors.white.withValues(alpha: 0.42),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: AppColors.white.withValues(alpha: 0.11),
                ),
              ),
            ),
            child: Text(
              'Edit tonight\'s entry',
              style: AppTheme.body(
                size: 10.5,
                weight: FontWeight.w600,
                color: AppColors.white.withValues(alpha: 0.42),
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiaryMiniLine extends StatelessWidget {
  const _DiaryMiniLine({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: '$label: ',
        style: const TextStyle(fontWeight: FontWeight.w800),
        children: [
          TextSpan(
            text: text,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ],
      ),
      style: AppTheme.body(
        size: 11.5,
        color: AppColors.white.withValues(alpha: 0.58),
        height: 1.42,
      ),
    );
  }
}

class _DiaryWeekChart extends StatelessWidget {
  const _DiaryWeekChart({required this.entries});

  final List<ThoughtDiaryEntry> entries;

  @override
  Widget build(BuildContext context) {
    final last7 = _lastDiaryEntries(entries, 7);

    return SizedBox(
      height: 112,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: last7.map((entry) {
          final color = _diaryScoreColor(entry.score);

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 260),
                        width: double.infinity,
                        height: (entry.score * 8.2).clamp(6, 82).toDouble(),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${entry.score}',
                    style: AppTheme.body(
                      size: 10.5,
                      weight: FontWeight.w800,
                      color: color,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _diaryDayShort(entry.dateLabel),
                    style: AppTheme.body(
                      size: 9.5,
                      weight: FontWeight.w700,
                      color: AppColors.white.withValues(alpha: 0.3),
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _DiaryEntryCard extends StatelessWidget {
  const _DiaryEntryCard({required this.entry});

  final ThoughtDiaryEntry entry;

  @override
  Widget build(BuildContext context) {
    final color = _diaryScoreColor(entry.score);

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  entry.dateLabel,
                  style: AppTheme.body(
                    size: 10.5,
                    weight: FontWeight.w700,
                    color: AppColors.white.withValues(alpha: 0.4),
                    height: 1,
                  ),
                ),
              ),
              Text(
                '${entry.score}/10',
                style: AppTheme.body(
                  size: 11,
                  weight: FontWeight.w900,
                  color: color,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Text(
            'Why: ${entry.why}',
            style: AppTheme.body(
              size: 11,
              color: AppColors.white.withValues(alpha: 0.45),
              height: 1.42,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            entry.happened,
            style: AppTheme.body(
              size: 11.5,
              color: AppColors.white.withValues(alpha: 0.62),
              height: 1.45,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 9),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.white.withValues(alpha: 0.06)),
              ),
            ),
            child: Text(
              'Thought: ${entry.heaviestThought}',
              style: AppTheme.body(
                size: 10.5,
                color: AppColors.white.withValues(alpha: 0.35),
                height: 1.42,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiaryWeeklyBreakdown extends StatelessWidget {
  const _DiaryWeeklyBreakdown({required this.entries});

  final List<ThoughtDiaryEntry> entries;

  @override
  Widget build(BuildContext context) {
    final last7 = _lastDiaryEntries(entries, 7);
    final average =
        last7.fold<int>(0, (sum, entry) => sum + entry.score) / last7.length;
    final averageColor = _diaryScoreColor(average.round());
    final best = last7.reduce((a, b) => a.score >= b.score ? a : b);
    final worst = last7.reduce((a, b) => a.score <= b.score ? a : b);
    final belowAverage = last7.where((entry) => entry.score < average).toList();

    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.orange.withValues(alpha: 0.15)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _DiarySectionHeader(label: 'Weekly Breakdown', trailing: ''),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      average.toStringAsFixed(1),
                      style: AppTheme.bebas(
                        size: 46,
                        color: averageColor,
                        height: 1,
                      ),
                    ),
                    Text(
                      'weekly average',
                      style: AppTheme.body(
                        size: 9,
                        color: AppColors.white.withValues(alpha: 0.3),
                        height: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        average >= 8
                            ? 'Strong week'
                            : average >= 5
                            ? 'Mixed week'
                            : 'Tough week',
                        style: AppTheme.body(
                          size: 13,
                          weight: FontWeight.w800,
                          color: averageColor,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Based on ${last7.length} entries. The number matters less than the pattern behind it.',
                        style: AppTheme.body(
                          size: 10.5,
                          color: AppColors.white.withValues(alpha: 0.45),
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _DiaryBestWorstCard(
                  title: 'Best Day',
                  entry: best,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DiaryBestWorstCard(
                  title: 'Hardest Day',
                  entry: worst,
                  color: AppColors.danger,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.06),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WHAT THE WEEK IS TELLING YOU',
                  style: AppTheme.body(
                    size: 9.5,
                    weight: FontWeight.w800,
                    color: AppColors.white.withValues(alpha: 0.28),
                    height: 1,
                  ).copyWith(letterSpacing: 1.25),
                ),
                const SizedBox(height: 9),
                Text(
                  belowAverage.isEmpty
                      ? 'No days fell below your average. Look at what supported those scores and repeat more of it.'
                      : 'Days below your average: ${belowAverage.map((entry) => '${entry.dateLabel} (${entry.score}/10)').join(' · ')}',
                  style: AppTheme.body(
                    size: 10.8,
                    color: AppColors.white.withValues(alpha: 0.42),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Review questions',
                  style: AppTheme.body(
                    size: 10.5,
                    weight: FontWeight.w800,
                    color: AppColors.orange,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                const _DiaryReviewQuestion(
                  text: 'What was consistently pulling your score down?',
                ),
                const _DiaryReviewQuestion(
                  text: 'What did your best day have that your worst did not?',
                ),
                const _DiaryReviewQuestion(
                  text: 'What is one thing you will do differently next week?',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DiaryBestWorstCard extends StatelessWidget {
  const _DiaryBestWorstCard({
    required this.title,
    required this.entry,
    required this.color,
  });

  final String title;
  final ThoughtDiaryEntry entry;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: AppTheme.body(
              size: 9,
              weight: FontWeight.w900,
              color: color,
              height: 1,
            ).copyWith(letterSpacing: 1),
          ),
          const SizedBox(height: 7),
          Text(
            entry.dateLabel,
            style: AppTheme.body(
              size: 10,
              color: AppColors.white.withValues(alpha: 0.36),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${entry.score}/10',
            style: AppTheme.bebas(size: 28, color: color, height: 1),
          ),
          const SizedBox(height: 5),
          Text(
            entry.why,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.body(
              size: 10,
              color: AppColors.white.withValues(alpha: 0.4),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _DiaryReviewQuestion extends StatelessWidget {
  const _DiaryReviewQuestion({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        '→ $text',
        style: AppTheme.body(
          size: 10.5,
          color: AppColors.white.withValues(alpha: 0.46),
          height: 1.4,
        ),
      ),
    );
  }
}

Color _diaryScoreColor(int score) {
  if (score >= 8) return AppColors.success;
  if (score >= 5) return AppColors.amber;
  return AppColors.danger;
}

String _diaryWhyTitle(int score) {
  if (score <= 3) return 'That\'s a tough one — what made today so hard?';
  if (score <= 6) return 'What held it back from being better?';
  if (score <= 8) return 'What made today a $score?';
  return 'A $score — what made today that good?';
}

String _diaryWhyHint(int score) {
  if (score <= 3) {
    return 'What happened that pushed it down to a $score? Be honest.';
  }
  if (score <= 6) {
    return 'A $score means something got in the way. What was it?';
  }
  if (score <= 8) return 'Good day — what contributed to that?';
  return 'Take note of this. What were you doing differently?';
}

String _diaryWhyPlaceholder(int score) {
  if (score <= 3) return 'What brought you down to a $score today...';
  if (score <= 6) return 'What stopped today being a 7 or 8...';
  if (score <= 8) {
    return 'What went well and what could have made it even better...';
  }
  return 'What made today a strong day — capture it...';
}

String _diaryDateLabel(DateTime date) {
  const days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
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
  return '${days[date.weekday - 1]} ${date.day} ${months[date.month - 1]}';
}

String _diaryDayShort(String dateLabel) {
  if (dateLabel.trim().isEmpty) return '';
  final first = dateLabel.split(' ').first;
  return first.length <= 3 ? first : first.substring(0, 3);
}

List<ThoughtDiaryEntry> _lastDiaryEntries(
  List<ThoughtDiaryEntry> entries,
  int count,
) {
  if (entries.length <= count) return List<ThoughtDiaryEntry>.from(entries);
  return entries.sublist(entries.length - count);
}

List<ThoughtDiaryEntry> _recentDiaryEntries(List<ThoughtDiaryEntry> entries) {
  return _lastDiaryEntries(entries, 7).reversed.toList();
}

String _weeklyToolTitle(int toolNum) {
  return switch (toolNum) {
    1 => 'Self Enquiry',
    2 => 'Unwire The Thought',
    3 => 'Reframing',
    4 => 'Problem Solve',
    _ => 'Productivity Superpower',
  };
}

String _weeklyToolSubtitle(int toolNum) {
  return switch (toolNum) {
    1 =>
      'Separate what is real from what is perceived. This is where you start finding out what has been running underneath.',
    2 =>
      'Trace the belief back to where it started, then replace it with who you actually are now.',
    3 =>
      'Take a stuck thought and turn it into something that gives you a next move.',
    4 => 'Strip the emotion out of a problem and get to one clear action.',
    _ =>
      'Get everything out of your head, sort it, and block the week so your mind can rest.',
  };
}

List<int> _selectedBeliefIndexes(AppController controller) {
  if (controller.selectedBeliefs.isNotEmpty) {
    return controller.selectedBeliefs.take(5).toList();
  }
  return const [0, 3];
}

String _shortDate() {
  final now = DateTime.now();
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
  return '${now.day} ${months[now.month - 1]}';
}

class _SimpleWorkEntry {
  const _SimpleWorkEntry({
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
}

class _ToolSheetFrame extends StatelessWidget {
  const _ToolSheetFrame({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: FractionallySizedBox(
        heightFactor: 0.95,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.black,
            border: Border(top: BorderSide(color: AppColors.orangeBright)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title.toUpperCase(),
                        style: AppTheme.bebas(size: 24, letterSpacing: 1),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white.withValues(alpha: 0.06),
                          border: Border.all(
                            color: AppColors.white.withValues(alpha: 0.15),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: AppColors.border, height: 1),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class _EnquiryToolSheet extends StatefulWidget {
  const _EnquiryToolSheet({
    required this.controller,
    required this.entries,
    required this.onSave,
    required this.onComplete,
  });

  final AppController controller;
  final List<_SimpleWorkEntry> entries;
  final ValueChanged<_SimpleWorkEntry> onSave;
  final VoidCallback onComplete;

  @override
  State<_EnquiryToolSheet> createState() => _EnquiryToolSheetState();
}

class _EnquiryToolSheetState extends State<_EnquiryToolSheet> {
  final thoughtController = TextEditingController();
  final responseController = TextEditingController();
  final actionController = TextEditingController();
  String? type;

  @override
  void initState() {
    super.initState();
    thoughtController.addListener(_refresh);
    responseController.addListener(_refresh);
    actionController.addListener(_refresh);
  }

  @override
  void dispose() {
    thoughtController.dispose();
    responseController.dispose();
    actionController.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  bool get ready =>
      thoughtController.text.trim().length > 3 &&
      responseController.text.trim().length > 3 &&
      actionController.text.trim().length > 3 &&
      type != null;

  @override
  Widget build(BuildContext context) {
    final source = _selectedBeliefIndexes(widget.controller);
    final worked = source
        .where(
          (index) => widget.entries.any((entry) => entry.beliefIndex == index),
        )
        .toList();
    final remaining = source
        .where(
          (index) => !widget.entries.any((entry) => entry.beliefIndex == index),
        )
        .toList();
    final allDone = source.isNotEmpty && remaining.isEmpty;
    final current = allDone ? null : remaining.first;
    final pct = source.isEmpty ? 0.0 : worked.length / source.length;

    return _ToolSheetFrame(
      title: 'Self Enquiry — Week 1',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
        children: [
          _ProgressHeader(
            label:
                '${worked.length} of ${source.length} beliefs worked through',
            value: pct,
          ),
          const SizedBox(height: 14),
          if (allDone)
            _ToolCompleteBlock(
              title: 'You\'ve worked through all beliefs.',
              text: 'That took guts. Review your work below.',
              buttonLabel: 'Complete Week 1 — Self Enquiry Done ✓',
              onPressed: () {
                Navigator.of(context).pop();
                widget.onComplete();
              },
            )
          else ...[
            _CurrentBeliefCard(
              label: 'Belief ${worked.length + 1} of ${source.length}',
              belief: AppContent.beliefs[current!],
            ),
            const SizedBox(height: 12),
            const _ExplainerCard(
              title: 'How Self Enquiry works',
              text:
                  'You work through each belief one at a time. Write how it shows up, then decide: is this TRUE, or PERCEIVED? True beliefs get problem-solved. Perceived beliefs get challenged and replaced.',
            ),
            const SizedBox(height: 12),
            _ToolStepBlock(
              step: '1',
              title: 'Write it exactly as it shows up',
              child: TextField(
                controller: thoughtController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Write it exactly as it sounds in your head...',
                ),
              ),
            ),
            _ToolStepBlock(
              step: '2',
              title: 'Is this TRUE or PERCEIVED?',
              child: Row(
                children: [
                  Expanded(
                    child: _ChoicePill(
                      title: 'TRUE',
                      subtitle: 'This is real, provable',
                      selected: type == 'TRUE',
                      color: AppColors.danger,
                      onTap: () => setState(() => type = 'TRUE'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ChoicePill(
                      title: 'PERCEIVED',
                      subtitle: 'This is a story',
                      selected: type == 'PERCEIVED',
                      color: AppColors.orangeBright,
                      onTap: () => setState(() => type = 'PERCEIVED'),
                    ),
                  ),
                ],
              ),
            ),
            if (type != null)
              _ToolStepBlock(
                step: '3',
                title: type == 'TRUE'
                    ? 'Right, so what are we doing about it?'
                    : 'It\'s a story. Time to stop running it.',
                badge: type == 'TRUE' ? 'TRUE PATH' : 'PERCEIVED PATH',
                child: TextField(
                  controller: responseController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: type == 'TRUE'
                        ? 'What can you learn, and what is the goal on the other side?'
                        : 'Where is the proof? Who would you be without this thought? What is the reframe?',
                  ),
                ),
              ),
            _ToolStepBlock(
              step: '4',
              title: 'One action. Today.',
              child: Column(
                children: [
                  TextField(
                    controller: actionController,
                    maxLines: 3,
                    decoration: const InputDecoration(hintText: 'I will...'),
                  ),
                  const SizedBox(height: 12),
                  YdyButton(
                    label: remaining.length > 1
                        ? 'Save this belief → Next belief'
                        : 'Save this belief → Review your week',
                    enabled: ready,
                    onPressed: ready
                        ? () {
                            widget.onSave(
                              _SimpleWorkEntry(
                                beliefIndex: current,
                                belief: AppContent.beliefs[current],
                                type: type!,
                                response: responseController.text.trim(),
                                action: actionController.text.trim(),
                                date: _shortDate(),
                              ),
                            );
                            thoughtController.clear();
                            responseController.clear();
                            actionController.clear();
                            setState(() => type = null);
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ],
          if (widget.entries.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'All Entries',
              style: AppTheme.body(
                size: 11,
                weight: FontWeight.w600,
                color: AppColors.foundationMuted,
              ).copyWith(letterSpacing: 1.8),
            ),
            const SizedBox(height: 10),
            ...widget.entries.map((entry) => _WorkEntryCard(entry: entry)),
          ],
        ],
      ),
    );
  }
}

class _UnwireToolSheet extends StatefulWidget {
  const _UnwireToolSheet({
    required this.controller,
    required this.sourceEntries,
    required this.entries,
    required this.onSave,
    required this.onComplete,
  });

  final AppController controller;
  final List<_SimpleWorkEntry> sourceEntries;
  final List<_SimpleWorkEntry> entries;
  final ValueChanged<_SimpleWorkEntry> onSave;
  final VoidCallback onComplete;

  @override
  State<_UnwireToolSheet> createState() => _UnwireToolSheetState();
}

class _UnwireToolSheetState extends State<_UnwireToolSheet> {
  final memoryController = TextEditingController();
  final evidenceController = TextEditingController();
  final identityController = TextEditingController();
  final commitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    memoryController.addListener(_refresh);
    evidenceController.addListener(_refresh);
    identityController.addListener(_refresh);
    commitController.addListener(_refresh);
  }

  @override
  void dispose() {
    memoryController.dispose();
    evidenceController.dispose();
    identityController.dispose();
    commitController.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  bool get ready =>
      memoryController.text.trim().length > 3 &&
      evidenceController.text.trim().length > 3 &&
      identityController.text.trim().length > 3 &&
      commitController.text.trim().length > 3;

  @override
  Widget build(BuildContext context) {
    final source = widget.sourceEntries.isNotEmpty
        ? widget.sourceEntries
        : _selectedBeliefIndexes(widget.controller)
              .map(
                (index) => _SimpleWorkEntry(
                  beliefIndex: index,
                  belief: AppContent.beliefs[index],
                  type: 'BELIEF',
                  response: '',
                  action: '',
                  date: _shortDate(),
                ),
              )
              .toList();
    final worked = source
        .where(
          (entry) =>
              widget.entries.any((u) => u.beliefIndex == entry.beliefIndex),
        )
        .toList();
    final remaining = source
        .where(
          (entry) =>
              !widget.entries.any((u) => u.beliefIndex == entry.beliefIndex),
        )
        .toList();
    final allDone = source.isNotEmpty && remaining.isEmpty;
    final current = allDone ? null : remaining.first;
    final pct = source.isEmpty ? 0.0 : worked.length / source.length;

    return _ToolSheetFrame(
      title: 'Unwire The Thought — Week 2',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
        children: [
          _ProgressHeader(
            label: '${worked.length} of ${source.length} beliefs unwired',
            value: pct,
          ),
          const SizedBox(height: 14),
          if (allDone)
            _ToolCompleteBlock(
              title: 'Every belief unwired.',
              text: 'That is serious work. Review below.',
              buttonLabel: 'Complete Week 2 — Unwired ✓',
              onPressed: () {
                Navigator.of(context).pop();
                widget.onComplete();
              },
            )
          else ...[
            _CurrentBeliefCard(
              label: 'Belief ${worked.length + 1} of ${source.length}',
              belief: current!.belief,
              subLabel: current.response.isEmpty
                  ? null
                  : 'Carried over from Self Enquiry',
            ),
            const SizedBox(height: 12),
            const _ExplainerCard(
              title: 'Trace it. Challenge it. Replace it.',
              text:
                  'Every limiting belief started somewhere. Find the root, separate the story from the facts, and write who you actually are now.',
            ),
            const SizedBox(height: 12),
            _ToolStepBlock(
              step: '1',
              title: 'Trace it — earliest memory of this feeling',
              child: TextField(
                controller: memoryController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'I was about __ years old. What happened was...',
                ),
              ),
            ),
            _ToolStepBlock(
              step: '2',
              title: 'Why are you NOT this belief? Write the evidence.',
              child: TextField(
                controller: evidenceController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText:
                      'Evidence from your life that proves this is not who you are...',
                ),
              ),
            ),
            _ToolStepBlock(
              step: '3',
              title: 'Who are you, actually?',
              child: TextField(
                controller: identityController,
                maxLines: 4,
                decoration: const InputDecoration(hintText: 'I am...'),
              ),
            ),
            _ToolStepBlock(
              step: '4',
              title: 'What I\'m committing to',
              child: Column(
                children: [
                  TextField(
                    controller: commitController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'I am... I do... I commit to...',
                    ),
                  ),
                  const SizedBox(height: 12),
                  YdyButton(
                    label: remaining.length > 1
                        ? 'Save this belief → Next belief'
                        : 'Save this belief → Review your week',
                    enabled: ready,
                    onPressed: ready
                        ? () {
                            widget.onSave(
                              _SimpleWorkEntry(
                                beliefIndex: current.beliefIndex,
                                belief: current.belief,
                                type: 'UNWIRED',
                                response:
                                    'Evidence: ${evidenceController.text.trim()}\nWho I am now: ${identityController.text.trim()}',
                                action: commitController.text.trim(),
                                date: _shortDate(),
                              ),
                            );
                            memoryController.clear();
                            evidenceController.clear();
                            identityController.clear();
                            commitController.clear();
                            setState(() {});
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ],
          if (widget.entries.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Your Work This Week',
              style: AppTheme.body(
                size: 11,
                weight: FontWeight.w600,
                color: AppColors.foundationMuted,
              ).copyWith(letterSpacing: 1.8),
            ),
            const SizedBox(height: 10),
            ...widget.entries.map((entry) => _WorkEntryCard(entry: entry)),
          ],
        ],
      ),
    );
  }
}

class _SimpleWeeklyToolSheet extends StatefulWidget {
  const _SimpleWeeklyToolSheet({
    required this.toolNum,
    required this.title,
    required this.subtitle,
    required this.onComplete,
  });

  final int toolNum;
  final String title;
  final String subtitle;
  final VoidCallback onComplete;

  @override
  State<_SimpleWeeklyToolSheet> createState() => _SimpleWeeklyToolSheetState();
}

class _SimpleWeeklyToolSheetState extends State<_SimpleWeeklyToolSheet> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ToolSheetFrame(
      title: '${widget.title} — Week ${widget.toolNum}',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
        children: [
          _ExplainerCard(title: widget.title, text: widget.subtitle),
          const SizedBox(height: 12),
          _ToolStepBlock(
            step: '1',
            title: 'Do the work in writing',
            child: TextField(
              controller: controller,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: 'Write the honest version here...',
              ),
            ),
          ),
          YdyButton(
            label: 'Complete Week ✓',
            enabled: controller.text.trim().length > 6,
            onPressed: controller.text.trim().length > 6
                ? () {
                    Navigator.of(context).pop();
                    widget.onComplete();
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

class _CopingBottomSheet extends StatefulWidget {
  const _CopingBottomSheet({required this.controller});

  final AppController controller;

  @override
  State<_CopingBottomSheet> createState() => _CopingBottomSheetState();
}

class _CopingBottomSheetState extends State<_CopingBottomSheet> {
  int? score;
  final downController = TextEditingController();
  final upController = TextEditingController();
  final actionController = TextEditingController();
  final changeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    downController.addListener(_refresh);
    upController.addListener(_refresh);
    actionController.addListener(_refresh);
    changeController.addListener(_refresh);
  }

  @override
  void dispose() {
    downController.dispose();
    upController.dispose();
    actionController.dispose();
    changeController.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  bool get ready =>
      score != null &&
      downController.text.trim().length > 3 &&
      upController.text.trim().length > 3 &&
      actionController.text.trim().length > 3;

  @override
  Widget build(BuildContext context) {
    final latest = widget.controller.copingEntries.isEmpty
        ? null
        : widget.controller.copingEntries.last;
    final hasPrevious = latest != null;
    final daysLeft = _copingDaysUntilNext(latest);
    final tooSoon = hasPrevious && daysLeft > 0;
    final wrongTime = hasPrevious && daysLeft == 0 && !_isCopingMorningWindow();

    if (tooSoon) {
      return _ToolSheetFrame(
        title: 'Come Back In $daysLeft Day${daysLeft == 1 ? '' : 's'}',
        child: _CopingLockedMessage(
          icon: '⏰',
          text:
              'Your next check-in opens in $daysLeft day${daysLeft == 1 ? '' : 's'}. The 2-week gap is intentional — it gives the work time to take effect. Come back on a morning between 6 and 9am.',
        ),
      );
    }

    if (wrongTime) {
      return const _ToolSheetFrame(
        title: 'Morning Check-In Only',
        child: _CopingLockedMessage(
          icon: '⏰',
          text:
              'This check-in is designed for the morning — between 6am and 9am, before the day takes over. Come back tomorrow morning and do it then. That timing is part of why it works.',
        ),
      );
    }

    return _ToolSheetFrame(
      title: 'Coping Level Check-In',
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              children: [
                _CopingIntroNotice(
                  text: hasPrevious
                      ? 'Two weeks on. Same tool, fresh eyes. How much has shifted? Be honest — better or worse, it all counts as data.'
                      : 'Your first coping check-in. This is your baseline — be completely honest. Nobody sees this but you.',
                ),
                if (latest != null) ...[
                  const SizedBox(height: 14),
                  _CopingPreviousScoreCard(entry: latest),
                ],
                const SizedBox(height: 16),
                _CopingQuestionBlock(
                  step: '1',
                  title: 'Rate your coping level right now — 1 to 10',
                  hint:
                      '1 = completely overwhelmed. 10 = genuinely thriving. Gut number, no middle ground.',
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: List.generate(10, (index) {
                      final value = index + 1;
                      final selected = score == value;
                      return GestureDetector(
                        onTap: () => setState(() => score = value),
                        child: Container(
                          width: 33,
                          height: 33,
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.orangeBright
                                : AppColors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              color: selected
                                  ? AppColors.orangeBright
                                  : AppColors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$value',
                            style: AppTheme.body(
                              size: 12,
                              weight: FontWeight.w800,
                              color: selected
                                  ? AppColors.white
                                  : AppColors.white.withValues(alpha: 0.48),
                              height: 1,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                _CopingQuestionBlock(
                  step: '2',
                  title: 'What\'s pushing you DOWN right now?',
                  hint:
                      'Every stressor, unresolved problem, fear, uncertainty. Get it all out — this is data not wallowing.',
                  child: _CopingTextArea(
                    controller: downController,
                    hint: 'List everything weighing on you...',
                    maxLines: 4,
                  ),
                ),
                _CopingQuestionBlock(
                  step: '3',
                  title: 'What builds you UP?',
                  hint:
                      'Sleep, exercise, connection, purpose. Which of these have you actually done this week?',
                  child: _CopingTextArea(
                    controller: upController,
                    hint:
                        'What fills your tank, and which have you done this week...',
                    maxLines: 4,
                  ),
                ),
                _CopingQuestionBlock(
                  step: '4',
                  title:
                      'One UP action you\'ll do today — write it as a commitment',
                  hint:
                      'Not eventually. Today. Even something small shifts the balance.',
                  highlight: true,
                  child: _CopingTextArea(
                    controller: actionController,
                    hint: 'I will...',
                    maxLines: 3,
                  ),
                ),
                if (hasPrevious)
                  _CopingQuestionBlock(
                    step: '5',
                    title: 'What\'s changed since your last check-in?',
                    hint:
                        'Name the shifts — better or worse — since two weeks ago.',
                    child: _CopingTextArea(
                      controller: changeController,
                      hint: 'What feels different since your last check-in...',
                      maxLines: 3,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
            decoration: const BoxDecoration(
              color: AppColors.black,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: YdyButton(
              label: 'Save Check-In →',
              enabled: ready,
              onPressed: ready
                  ? () async {
                      await widget.controller.saveCopingEntry(
                        score: score!,
                        down: downController.text.trim(),
                        up: upController.text.trim(),
                        action: actionController.text.trim(),
                        change: changeController.text.trim(),
                      );
                      if (context.mounted) Navigator.of(context).pop();
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _CopingLockedMessage extends StatelessWidget {
  const _CopingLockedMessage({required this.icon, required this.text});

  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 96),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 24),
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppTheme.body(
                size: 12,
                color: AppColors.white.withValues(alpha: 0.58),
                height: 1.58,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CopingIntroNotice extends StatelessWidget {
  const _CopingIntroNotice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.orangeBright.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: AppColors.orangeBright.withValues(alpha: 0.26),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                color: AppColors.orangeBright.withValues(alpha: 0.9),
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(8),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 12, 10),
            child: Text(
              text,
              style: AppTheme.body(
                size: 11.5,
                color: AppColors.white.withValues(alpha: 0.72),
                height: 1.52,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CopingPreviousScoreCard extends StatelessWidget {
  const _CopingPreviousScoreCard({required this.entry});

  final CopingCheckinEntry entry;

  @override
  Widget build(BuildContext context) {
    final color = _copingScoreColor(entry.score);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.foundationBorder),
      ),
      child: Row(
        children: [
          Text(
            'LAST CHECK-IN',
            style: AppTheme.body(
              size: 10,
              weight: FontWeight.w800,
              color: AppColors.white.withValues(alpha: 0.3),
              height: 1,
            ).copyWith(letterSpacing: 1),
          ),
          const Spacer(),
          Text(
            '${entry.score}/10',
            style: AppTheme.bebas(size: 26, color: color),
          ),
          const SizedBox(width: 10),
          Text(
            entry.dateLabel,
            style: AppTheme.body(
              size: 10.5,
              weight: FontWeight.w600,
              color: AppColors.white.withValues(alpha: 0.3),
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _CopingQuestionBlock extends StatelessWidget {
  const _CopingQuestionBlock({
    required this.step,
    required this.title,
    required this.hint,
    required this.child,
    this.highlight = false,
  });

  final String step;
  final String title;
  final String hint;
  final Widget child;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final titleColor = highlight ? AppColors.orangeBright : AppColors.white;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.orangeBright.withValues(alpha: 0.12),
                  border: Border.all(
                    color: AppColors.orangeBright.withValues(alpha: 0.35),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  step,
                  style: AppTheme.body(
                    size: 9.5,
                    weight: FontWeight.w800,
                    color: AppColors.orangeBright,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.body(
                        size: 11.7,
                        weight: FontWeight.w800,
                        color: titleColor,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hint,
                      style: AppTheme.body(
                        size: 10.2,
                        color: AppColors.white.withValues(alpha: 0.38),
                        height: 1.38,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _CopingTextArea extends StatelessWidget {
  const _CopingTextArea({
    required this.controller,
    required this.hint,
    required this.maxLines,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: AppTheme.body(size: 12, color: AppColors.white, height: 1.45),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.white.withValues(alpha: 0.045),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 12,
        ),
        hintStyle: AppTheme.body(
          size: 11.5,
          color: AppColors.white.withValues(alpha: 0.2),
          height: 1.4,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.foundationBorder.withValues(alpha: 0.82),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.orangeBright.withValues(alpha: 0.55),
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTheme.body(
            size: 10,
            weight: FontWeight.w600,
            color: AppColors.foundationMuted,
          ).copyWith(letterSpacing: 1.5),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            minHeight: 5,
            value: value,
            backgroundColor: AppColors.white.withValues(alpha: 0.08),
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.orangeBright,
            ),
          ),
        ),
      ],
    );
  }
}

class _CurrentBeliefCard extends StatelessWidget {
  const _CurrentBeliefCard({
    required this.label,
    required this.belief,
    this.subLabel,
  });

  final String label;
  final String belief;
  final String? subLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.orangeBright.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.orangeBright.withValues(alpha: 0.28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTheme.body(
              size: 10,
              weight: FontWeight.w700,
              color: AppColors.orangeBright,
            ).copyWith(letterSpacing: 1.2),
          ),
          const SizedBox(height: 6),
          Text(
            '"$belief"',
            style: AppTheme.body(
              size: 13,
              weight: FontWeight.w600,
              color: AppColors.white,
              height: 1.45,
            ),
          ),
          if (subLabel != null) ...[
            const SizedBox(height: 6),
            Text(
              subLabel!,
              style: AppTheme.body(
                size: 11,
                weight: FontWeight.w600,
                color: AppColors.orangeBright,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ExplainerCard extends StatelessWidget {
  const _ExplainerCard({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.foundationGrey,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.foundationBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: AppTheme.body(
              size: 10,
              weight: FontWeight.w800,
              color: AppColors.orangeBright,
            ).copyWith(letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: AppTheme.body(
              size: 12.5,
              color: AppColors.white.withValues(alpha: 0.66),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolStepBlock extends StatelessWidget {
  const _ToolStepBlock({
    required this.step,
    required this.title,
    required this.child,
    this.badge,
  });

  final String step;
  final String title;
  final Widget child;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: badge == null
              ? AppColors.foundationBorder
              : AppColors.orangeBright.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 13, 14, 10),
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.orangeBright,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    step,
                    style: AppTheme.body(
                      size: 11,
                      weight: FontWeight.w800,
                      color: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: AppTheme.body(
                      size: 13,
                      weight: FontWeight.w700,
                      color: AppColors.white,
                      height: 1.25,
                    ),
                  ),
                ),
                if (badge != null)
                  Text(
                    badge!,
                    style: AppTheme.body(
                      size: 9.5,
                      weight: FontWeight.w800,
                      color: AppColors.orangeBright,
                    ).copyWith(letterSpacing: 1.1),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? color : AppColors.white.withValues(alpha: 0.12),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Text('✓', style: AppTheme.bebas(size: 20, color: color)),
            const SizedBox(height: 2),
            Text(title, style: AppTheme.bebas(size: 22, color: color)),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTheme.body(
                size: 10.5,
                color: AppColors.white.withValues(alpha: 0.45),
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolCompleteBlock extends StatelessWidget {
  const _ToolCompleteBlock({
    required this.title,
    required this.text,
    required this.buttonLabel,
    required this.onPressed,
  });

  final String title;
  final String text;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.successDim,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.35)),
      ),
      child: Column(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.success),
            ),
            alignment: Alignment.center,
            child: const Text('✓', style: TextStyle(color: AppColors.success)),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTheme.body(
              size: 13,
              weight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            textAlign: TextAlign.center,
            style: AppTheme.body(
              size: 12,
              color: AppColors.white.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 14),
          YdyButton(label: buttonLabel, onPressed: onPressed),
        ],
      ),
    );
  }
}

class _WorkEntryCard extends StatelessWidget {
  const _WorkEntryCard({required this.entry});

  final _SimpleWorkEntry entry;

  @override
  Widget build(BuildContext context) {
    final perceived = entry.type == 'PERCEIVED';
    final color = perceived ? AppColors.orangeBright : AppColors.danger;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.foundationBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '"${entry.belief}"',
                  style: AppTheme.body(
                    size: 12,
                    weight: FontWeight.w600,
                    color: AppColors.white,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  entry.type,
                  style: AppTheme.body(
                    size: 9,
                    weight: FontWeight.w800,
                    color: color,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            entry.response,
            style: AppTheme.body(
              size: 11.5,
              color: AppColors.white.withValues(alpha: 0.58),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '→ ${entry.action}',
            style: AppTheme.body(
              size: 11.5,
              color: AppColors.orangeBright,
              weight: FontWeight.w600,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            entry.date,
            style: AppTheme.body(
              size: 10,
              color: AppColors.white.withValues(alpha: 0.25),
            ),
          ),
        ],
      ),
    );
  }
}

class _FoundationCompleteDialog extends StatelessWidget {
  const _FoundationCompleteDialog({
    required this.stepIndex,
    required this.allComplete,
  });

  final int stepIndex;
  final bool allComplete;

  @override
  Widget build(BuildContext context) {
    final titles = [
      'Life Assessment\nComplete.',
      'Limiting Beliefs\nLogged.',
      'Timeline Complete.',
      'Foundation Complete.',
    ];
    final text = allComplete
        ? 'All 4 steps done. Your tools are now unlocked. This is where the real work starts.'
        : [
            'You\'ve scored 6 areas of your life honestly. That takes guts. On to step 2.',
            'The ones you ticked — they\'ve been running in the background for years. Now they\'re named.',
            'You\'ve mapped where you\'ve been. The patterns are already there if you look. One more step.',
          ][stepIndex];

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 26),
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
        decoration: BoxDecoration(
          color: AppColors.foundationGrey,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.success, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.success.withValues(alpha: 0.18),
              blurRadius: 30,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('✓', style: TextStyle(fontSize: 34)),
            const SizedBox(height: 12),
            Text(
              titles[stepIndex],
              textAlign: TextAlign.center,
              style: AppTheme.bebas(
                size: 29,
                height: 1,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppTheme.body(
                size: 12.5,
                color: AppColors.foundationMuted,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: AppColors.white,
                elevation: 0,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                allComplete ? 'Continue →' : 'Continue →',
                style: AppTheme.bebas(
                  size: 18,
                  color: AppColors.white,
                  letterSpacing: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineExampleDialog extends StatelessWidget {
  const _TimelineExampleDialog();

  @override
  Widget build(BuildContext context) {
    const events = [
      (
        'AGE 8 · 1990',
        'Bullied at school',
        'Started being picked on for being quiet. I learned to stay under the radar. Stopped putting my hand up in class.',
        false,
      ),
      (
        'AGE 15 · 1997',
        'Parents separated',
        'Dad left. Became the "man of the house" overnight. Started carrying things I had no tools for.',
        false,
      ),
      (
        'AGE 18 · 2000',
        'Found football',
        'Joined a local team. First place I felt like I belonged. Gave me confidence I didn\'t have anywhere else.',
        true,
      ),
      (
        'AGE 19 · 2001',
        'Failed first year at college',
        'Couldn\'t keep up. Felt thick. Confirmed what I already believed about myself — that I wasn\'t smart enough.',
        false,
      ),
      (
        'AGE 22 · 2004',
        'First proper job',
        'Got a sales role. Turned out I was good at it. First time I felt capable at something professional.',
        true,
      ),
      (
        'AGE 25 · 2007',
        'Relationship breakdown',
        'Long-term relationship ended. I didn\'t handle it well. Drank too much, isolated myself for about a year.',
        false,
      ),
      (
        'AGE 28 · 2010',
        'Met my partner',
        'First relationship where I actually felt safe enough to be honest. Changed how I saw myself with other people.',
        true,
      ),
      (
        'AGE 32 · 2014',
        'Promoted to manager',
        'Wasn\'t expecting it. Imposter syndrome hit hard. But it made me step up in ways I didn\'t know I could.',
        true,
      ),
      (
        'AGE 33 · 2015',
        'Dad passed away',
        'We\'d never really sorted things out. A lot of unfinished stuff. Grief hit differently than I expected — more anger than sadness.',
        false,
      ),
      (
        'AGE 35 · 2017',
        'Son born',
        'Changed everything. Became the most important thing in my life overnight.',
        true,
      ),
      (
        'AGE 38 · 2020',
        'Burnout hits',
        'Pandemic, work pressure, no outlet. Stopped sleeping properly. Realised I\'d been running on empty for years.',
        false,
      ),
      (
        'AGE 40 · 2022',
        'Started working on myself',
        'First time I actually asked for help. Coaching. Realised most of what I was carrying had been there since I was a kid.',
        true,
      ),
    ];

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 22),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 440,
          maxHeight: MediaQuery.of(context).size.height * 0.92,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.foundationPanel,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.foundationBorder),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Example Timeline — Mark\'s Life',
                        style: AppTheme.bebas(
                          size: 18,
                          color: AppColors.orangeBright,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.foundationGrey,
                          border: Border.all(color: AppColors.foundationBorder),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.close,
                          size: 13,
                          color: AppColors.foundationMuted,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Stack(
                  children: [
                    Positioned(
                      left: 15,
                      top: 20,
                      bottom: 42,
                      child: Container(
                        width: 2,
                        color: AppColors.foundationBorder,
                      ),
                    ),
                    Column(
                      children: [
                        ...events.map((event) {
                          final positive = event.$4;
                          final color = positive
                              ? AppColors.success
                              : AppColors.danger;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 11),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 31,
                                  height: 31,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.foundationPanel,
                                    border: Border.all(color: color, width: 2),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    positive ? '+' : '−',
                                    style: AppTheme.body(
                                      size: 12,
                                      weight: FontWeight.w800,
                                      color: color,
                                      height: 1,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(
                                      12,
                                      10,
                                      12,
                                      11,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.foundationGrey,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppColors.foundationBorder,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          event.$1,
                                          style: AppTheme.body(
                                            size: 9,
                                            weight: FontWeight.w700,
                                            color: AppColors.foundationMuted,
                                            height: 1.2,
                                          ).copyWith(letterSpacing: 1),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          event.$2,
                                          style: AppTheme.body(
                                            size: 12,
                                            weight: FontWeight.w800,
                                            color: color,
                                            height: 1.2,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          event.$3,
                                          style: AppTheme.body(
                                            size: 10.5,
                                            color: AppColors.foundationMuted,
                                            height: 1.35,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.black,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.foundationBorder,
                            ),
                          ),
                          child: Text(
                            'This is Mark\'s example. Yours will be different — but the format is the same. Year, event, whether it was positive or negative, and a line or two about why it mattered.',
                            style: AppTheme.body(
                              size: 11,
                              color: AppColors.white,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
