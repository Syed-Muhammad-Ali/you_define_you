import 'package:flutter/material.dart';

import '../../app/constants/app_content.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../controllers/app_controller.dart';
import '../../models/app_models.dart';
import '../../widgets/common/ydy_button.dart';
import '../../widgets/common/ydy_shell.dart';

class OnboardingFlowScreen extends StatelessWidget {
  const OnboardingFlowScreen({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return YdyShell(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: switch (controller.onboardingStage) {
          OnboardingStage.welcome => _WelcomeScreen(controller: controller),
          OnboardingStage.acknowledge => _AcknowledgeScreen(
            controller: controller,
          ),
          OnboardingStage.questions => _QuestionsScreen(controller: controller),
          OnboardingStage.profile => _ProfileScreen(controller: controller),
          OnboardingStage.commitment => _CommitmentScreen(
            controller: controller,
          ),
        },
      ),
    );
  }
}

class _WelcomeScreen extends StatelessWidget {
  const _WelcomeScreen({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const ValueKey('welcome-screen'),
      padding: const EdgeInsets.fromLTRB(32, 28, 32, 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'YOU',
            style: AppTheme.bebas(size: 88, height: 0.92, letterSpacing: 1),
          ),
          Text(
            'DEFINE',
            style: AppTheme.bebas(
              size: 88,
              height: 0.92,
              letterSpacing: 1,
              color: AppColors.orange,
            ),
          ),
          Text(
            'YOU.',
            style: AppTheme.bebas(size: 88, height: 0.92, letterSpacing: 1),
          ),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Text(
              'The You Define You Mindset Method. Built for men who are ready to stop going round the same circle.',
              style: AppTheme.body(
                size: 14,
                color: AppColors.muted,
                height: 1.65,
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.only(left: 16),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: AppColors.orange, width: 2),
              ),
            ),
            child: Text.rich(
              TextSpan(
                text:
                    'If you\'ve landed here, something\'s been eating at you.\n\nMaybe you don\'t even know what it is. ',
                children: [
                  TextSpan(
                    text: 'That\'s exactly the right place to start.',
                    style: AppTheme.body(
                      size: 18,
                      weight: FontWeight.w500,
                      color: AppColors.orange,
                    ),
                  ),
                ],
              ),
              style: AppTheme.body(
                size: 18,
                color: AppColors.white,
                weight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 28),
          YdyButton(
            label: 'I\'m ready — let\'s go →',
            onPressed: () =>
                controller.moveToOnboardingStage(OnboardingStage.acknowledge),
          ),
        ],
      ),
    );
  }
}

class _AcknowledgeScreen extends StatelessWidget {
  const _AcknowledgeScreen({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const ValueKey('acknowledge-screen'),
      padding: const EdgeInsets.fromLTRB(32, 48, 32, 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Before we start',
            style: AppTheme.body(
              size: 11,
              weight: FontWeight.w500,
              color: AppColors.orange,
            ).copyWith(letterSpacing: 2.5),
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              text: 'What\'s going ',
              children: const [
                TextSpan(
                  text: 'on?',
                  style: TextStyle(color: AppColors.orange),
                ),
              ],
            ),
            style: AppTheme.bebas(size: 52, height: 1),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the answer that fits you. No wrong answers. Nobody\'s watching.',
            style: AppTheme.body(size: 13, color: AppColors.muted),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: AppContent.acknowledgementStatements.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final selected =
                    controller.selectedAcknowledgementIndex == index;
                return GestureDetector(
                  onTap: () => controller.selectAcknowledgement(index),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.orangeDim
                          : AppColors.greyLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? AppColors.orangeGlow
                            : AppColors.border,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected
                                ? AppColors.orange
                                : Colors.transparent,
                            border: Border.all(
                              color: selected
                                  ? AppColors.orange
                                  : AppColors.border,
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Opacity(
                            opacity: selected ? 1 : 0,
                            child: const Icon(
                              Icons.check,
                              size: 14,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            AppContent.acknowledgementStatements[index],
                            style: AppTheme.body(
                              size: 14,
                              color: selected
                                  ? AppColors.white
                                  : AppColors.muted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Nothing you tick here goes anywhere. This is just between you and the app.',
              textAlign: TextAlign.center,
              style: AppTheme.body(
                size: 11,
                color: AppColors.deepDimText,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 20),
          YdyButton(
            label: 'Let\'s keep going →',
            onPressed: () =>
                controller.moveToOnboardingStage(OnboardingStage.questions),
          ),
        ],
      ),
    );
  }
}

class _QuestionsScreen extends StatelessWidget {
  const _QuestionsScreen({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final questionNumber = controller.currentQuestionIndex + 1;
    final questionTitle = switch (controller.currentQuestionIndex) {
      0 => 'What\'s been going on for you?',
      1 => 'When did this start?',
      2 => 'What do you do to manage it?',
      3 => 'How do you want to feel?',
      _ => 'Do you need to get anything off your chest?',
    };
    final questionSubTitle = switch (controller.currentQuestionIndex) {
      0 => 'Pick the one that speaks to you the most.',
      1 => 'Most men find it goes back further than they think.',
      2 => 'No judgment. This is just where most men end up.',
      3 => 'What will make you feel you again?',
      _ =>
        'You don\'t have to. But if you want to — write it here. Just for you.',
    };

    return Column(
      key: const ValueKey('questions-screen'),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 40, 32, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Getting to know you',
                style: AppTheme.body(
                  size: 11,
                  color: AppColors.muted,
                ).copyWith(letterSpacing: 2),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Container(
                    width: 6,
                    height: 6,
                    margin: EdgeInsets.only(left: index == 0 ? 0 : 5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == controller.currentQuestionIndex
                          ? AppColors.orange
                          : index < controller.currentQuestionIndex
                          ? AppColors.teal
                          : AppColors.border,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
            children: [
              Text(
                'Question $questionNumber of 5',
                style: AppTheme.body(
                  size: 12,
                  color: AppColors.white,
                  weight: FontWeight.w500,
                ).copyWith(letterSpacing: 1.8),
              ),
              const SizedBox(height: 10),
              Text(
                questionTitle,
                style: AppTheme.bebas(size: 42, height: 1.05),
              ),
              const SizedBox(height: 6),
              Text(
                questionSubTitle,
                style: AppTheme.body(
                  size: 13,
                  color: AppColors.muted,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 24),
              if (controller.currentQuestionIndex < 4)
                ...controller.currentQuestionOptions.map(
                  (option) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _QuestionOption(
                      label: option,
                      selected:
                          controller.answers['q$questionNumber'] == option,
                      onTap: () => controller.selectQuestionAnswer(option),
                    ),
                  ),
                )
              else
                TextField(
                  controller:
                      TextEditingController(text: controller.freeTextAnswer)
                        ..selection = TextSelection.collapsed(
                          offset: controller.freeTextAnswer.length,
                        ),
                  onChanged: controller.updateFreeTextAnswer,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Nobody else sees this. Just say it.',
                  ),
                ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(32, 18, 32, 32),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: YdyButton(
            label: controller.currentQuestionIndex == 4
                ? 'See my profile →'
                : 'Let\'s keep going →',
            enabled: controller.canAdvanceQuestion,
            onPressed: controller.nextQuestion,
          ),
        ),
      ],
    );
  }
}

class _QuestionOption extends StatelessWidget {
  const _QuestionOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.orangeDim : AppColors.greyLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.orangeGlow : AppColors.border,
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
                shape: BoxShape.circle,
                color: selected ? AppColors.orange : Colors.transparent,
                border: Border.all(
                  color: selected ? AppColors.orange : const Color(0xFF333333),
                  width: 1.5,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppTheme.body(
                  size: 14,
                  color: selected ? AppColors.white : AppColors.muted,
                  weight: selected ? FontWeight.w400 : FontWeight.w300,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final profile = controller.profileData;
    return ListView(
      key: const ValueKey('profile-screen'),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(32, 56, 32, 32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF0D0604), AppColors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Based on what you\'ve told us',
                style: AppTheme.body(
                  size: 11,
                  weight: FontWeight.w500,
                  color: AppColors.orange,
                ).copyWith(letterSpacing: 2.4),
              ),
              const SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: 'I see\n',
                  children: [
                    TextSpan(
                      text: profile['headline'],
                      style: const TextStyle(color: AppColors.orange),
                    ),
                  ],
                ),
                style: AppTheme.bebas(size: 54, height: 1),
              ),
              const SizedBox(height: 10),
              Text(
                profile['recognition']!,
                style: AppTheme.body(
                  size: 14,
                  color: AppColors.muted,
                  height: 1.7,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 28, 32, 42),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What this actually means',
                style: AppTheme.body(
                  size: 10,
                  weight: FontWeight.w500,
                  color: AppColors.teal,
                ).copyWith(letterSpacing: 2.2),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.greyLight,
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(12),
                  ),
                  border: const Border(
                    top: BorderSide(color: AppColors.border),
                    right: BorderSide(color: AppColors.border),
                    bottom: BorderSide(color: AppColors.border),
                    left: BorderSide(color: AppColors.orange, width: 3),
                  ),
                ),
                child: Text(
                  profile['recognition']!,
                  style: AppTheme.body(
                    size: 14,
                    color: AppColors.softText,
                    height: 1.7,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.orangeDim,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.orangeGlow),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'The belief driving this',
                      style: AppTheme.body(
                        size: 10,
                        weight: FontWeight.w500,
                        color: AppColors.orange,
                      ).copyWith(letterSpacing: 2),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      profile['belief']!,
                      style: AppTheme.bebas(size: 32, height: 1.15),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      profile['beliefSub']!,
                      style: AppTheme.body(size: 13, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Your tools',
                style: AppTheme.body(
                  size: 10,
                  weight: FontWeight.w500,
                  color: AppColors.teal,
                ).copyWith(letterSpacing: 2.2),
              ),
              const SizedBox(height: 12),
              ...const [
                (
                  '📊',
                  'Coping Level',
                  'Measures where you\'re at right now so we know exactly what to work on first.',
                ),
                (
                  '🧠',
                  'Self Enquiry',
                  'Gets under the surface of what\'s actually driving the anxiety, burnout, or overwhelm.',
                ),
                (
                  '⚡',
                  'Unwire The Thought',
                  'Breaks the thought pattern before it spirals.',
                ),
                (
                  '🔄',
                  'Reframing',
                  'Shifts the way you see the stuck thought so it stops owning you.',
                ),
                (
                  '🎯',
                  'Problem Solve',
                  'Cuts through the emotion and gets you to one clear next step.',
                ),
                (
                  '💥',
                  'Productivity Superpower',
                  'Finds where your energy is actually going and helps you take it back.',
                ),
              ].asMap().entries.map(
                (entry) => Padding(
                  padding: EdgeInsets.only(bottom: entry.key == 5 ? 0 : 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: entry.key == 0
                          ? AppColors.orangeDim
                          : AppColors.greyLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: entry.key == 0
                            ? AppColors.orangeGlow
                            : AppColors.border,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.value.$1,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.value.$2,
                                style: AppTheme.bebas(size: 24, height: 1),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                entry.value.$3,
                                style: AppTheme.body(
                                  size: 12,
                                  color: AppColors.muted,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              YdyButton(
                label: 'This is me — let\'s go →',
                onPressed: () => controller.moveToOnboardingStage(
                  OnboardingStage.commitment,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CommitmentScreen extends StatelessWidget {
  const _CommitmentScreen({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const ValueKey('commitment-screen'),
      padding: const EdgeInsets.fromLTRB(32, 48, 32, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'One last thing',
            style: AppTheme.body(
              size: 11,
              weight: FontWeight.w500,
              color: AppColors.orange,
            ).copyWith(letterSpacing: 2.2),
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              text: 'You\'re\nnot ',
              children: const [
                TextSpan(
                  text: 'broken.',
                  style: TextStyle(color: AppColors.orange),
                ),
                TextSpan(text: '\nNot even\nclose.'),
              ],
            ),
            style: AppTheme.bebas(size: 62, height: 0.95),
          ),
          const SizedBox(height: 28),
          ...const [
            'You\'ve already done the hard bit — you showed up and said something\'s not right.',
            'Everything from here is tools, not therapy. Practical. Yours to keep.',
            'The You Define You Mindset Method works. But only if you put the work in.',
          ].map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: AppTheme.body(
                        size: 14,
                        color: AppColors.muted,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'What do we call you?',
            style: AppTheme.body(
              size: 11,
              color: AppColors.muted,
            ).copyWith(letterSpacing: 2),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: TextEditingController(text: controller.commitName)
              ..selection = TextSelection.collapsed(
                offset: controller.commitName.length,
              ),
            onChanged: controller.updateCommitName,
            decoration: const InputDecoration(hintText: 'First name'),
          ),
          const Spacer(),
          YdyButton(
            label: 'Let\'s build something →',
            enabled: controller.canEnterFoundation,
            onPressed: controller.enterFoundation,
          ),
        ],
      ),
    );
  }
}
