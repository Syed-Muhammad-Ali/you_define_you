import 'package:flutter/material.dart';

import '../../app/constants/app_content.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../controllers/app_controller.dart';
import '../../models/app_models.dart';
import '../../widgets/common/ydy_button.dart';
import '../../widgets/common/ydy_shell.dart';

InputDecoration _onboardingInputDecoration({required String hintText}) {
  return InputDecoration(
    hintText: hintText,
    filled: true,
    fillColor: AppColors.foundationGrey,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    hintStyle: AppTheme.body(
      size: 13,
      color: AppColors.foundationMuted.withValues(alpha: 0.55),
      fontStyle: FontStyle.italic,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.foundationBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.orangeGlowStrong),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.foundationBorder),
    ),
  );
}

const _onboardingKeyboardScrollPadding = EdgeInsets.fromLTRB(20, 20, 20, 120);

class OnboardingFlowScreen extends StatelessWidget {
  const OnboardingFlowScreen({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return YdyShell(
      safeTop: true,
      safeBottom: false,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: switch (controller.onboardingStage) {
            OnboardingStage.welcome => _WelcomeScreen(controller: controller),
            OnboardingStage.acknowledge => _AcknowledgeScreen(
              controller: controller,
            ),
            OnboardingStage.questions => _QuestionsScreen(
              controller: controller,
            ),
            OnboardingStage.profile => _ProfileScreen(controller: controller),
            OnboardingStage.commitment => _CommitmentScreen(
              controller: controller,
            ),
          },
        ),
      ),
    );
  }
}

class _WelcomeScreen extends StatelessWidget {
  const _WelcomeScreen({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      key: const ValueKey('welcome-screen'),
      builder: (context, constraints) {
        final brandSize = (constraints.maxWidth * 0.14)
            .clamp(56.0, 88.0)
            .toDouble();

        return Padding(
          padding: const EdgeInsets.fromLTRB(32, 52, 32, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'YOU',
                style: AppTheme.bebas(
                  size: brandSize,
                  height: 0.92,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                'DEFINE',
                style: AppTheme.bebas(
                  size: brandSize,
                  height: 0.92,
                  letterSpacing: 0.8,
                  color: AppColors.orange,
                ),
              ),
              Text(
                'YOU.',
                style: AppTheme.bebas(
                  size: brandSize,
                  height: 0.92,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Text(
                  'The You Define You Mindset Method. Built for men who are ready to stop going round the same circle.',
                  style: AppTheme.body(
                    size: 14,
                    color: AppColors.foundationMuted,
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
                          size: 16,
                          weight: FontWeight.w500,
                          color: AppColors.orange,
                        ),
                      ),
                    ],
                  ),
                  style: AppTheme.body(
                    size: 16,
                    color: AppColors.white,
                    weight: FontWeight.w400,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              YdyButton(
                label: 'I\'m ready — let\'s go →',
                onPressed: () => controller.moveToOnboardingStage(
                  OnboardingStage.acknowledge,
                ),
              ),
            ],
          ),
        );
      },
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
            'BEFORE WE START',
            style: AppTheme.body(
              size: 10,
              weight: FontWeight.w700,
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
            style: AppTheme.body(size: 13, color: AppColors.foundationMuted),
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
                          : AppColors.foundationGrey,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? AppColors.orangeGlow
                            : AppColors.foundationBorder,
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
                                  : AppColors.foundationBorder,
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
                                  : AppColors.foundationMuted,
                              height: 1.55,
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
                color: AppColors.foundationMuted.withValues(alpha: 0.55),
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
                'GETTING TO KNOW YOU',
                style: AppTheme.body(
                  size: 9,
                  weight: FontWeight.w500,
                  color: AppColors.foundationMuted,
                ).copyWith(letterSpacing: 2.2),
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
                          : AppColors.foundationBorder,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
            children: [
              Text(
                'QUESTION $questionNumber OF 5',
                style: AppTheme.body(
                  size: 10,
                  color: AppColors.white,
                  weight: FontWeight.w500,
                ).copyWith(letterSpacing: 1.8),
              ),
              const SizedBox(height: 10),
              _QuestionTitle(index: controller.currentQuestionIndex),
              const SizedBox(height: 6),
              Text(
                questionSubTitle,
                style: AppTheme.body(
                  size: 13,
                  color: AppColors.foundationMuted,
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
                  scrollPadding: _onboardingKeyboardScrollPadding,
                  onTapOutside: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  decoration: _onboardingInputDecoration(
                    hintText: 'Nobody else sees this. Just say it.',
                  ),
                ),
            ],
          ),
        ),
        AnimatedOpacity(
          opacity: controller.canAdvanceQuestion ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 250),
          child: IgnorePointer(
            ignoring: !controller.canAdvanceQuestion,
            child: Container(
              padding: const EdgeInsets.fromLTRB(32, 18, 32, 32),
              decoration: const BoxDecoration(
                border:
                    Border(top: BorderSide(color: AppColors.foundationBorder)),
              ),
              child: YdyButton(
                label: controller.currentQuestionIndex == 4
                    ? 'See my profile →'
                    : 'Let\'s keep going →',
                onPressed: controller.nextQuestion,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuestionTitle extends StatelessWidget {
  const _QuestionTitle({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final style = AppTheme.bebas(size: 42, height: 1.05, letterSpacing: 0.8);
    final orangeStyle = style.copyWith(color: AppColors.orange);

    final span = switch (index) {
      0 => TextSpan(
        text: 'What\'s been ',
        style: style,
        children: [
          TextSpan(text: 'going on', style: orangeStyle),
          const TextSpan(text: ' for\nyou?'),
        ],
      ),
      1 => TextSpan(
        text: 'When did this ',
        style: style,
        children: [TextSpan(text: 'start?', style: orangeStyle)],
      ),
      2 => TextSpan(
        text: 'What do you do to\n',
        style: style,
        children: [
          TextSpan(text: 'manage', style: orangeStyle),
          const TextSpan(text: ' it?'),
        ],
      ),
      3 => TextSpan(
        text: 'How do you ',
        style: style,
        children: [
          TextSpan(text: 'want', style: orangeStyle),
          const TextSpan(text: ' to feel?'),
        ],
      ),
      _ => TextSpan(
        text: 'Do you need to get\n',
        style: style,
        children: [
          TextSpan(text: 'anything', style: orangeStyle),
          const TextSpan(text: ' off your chest?'),
        ],
      ),
    };

    return Text.rich(span);
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
          color: selected ? AppColors.orangeDim : AppColors.foundationGrey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.orangeGlow : AppColors.foundationBorder,
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
                  color: selected
                      ? AppColors.orange
                      : AppColors.foundationBorder,
                  width: 1.5,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: AppColors.orangeGlow.withValues(alpha: 0.45),
                          blurRadius: 7,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppTheme.body(
                  size: 14,
                  color: selected ? AppColors.white : AppColors.foundationMuted,
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
    final toolItems = _profileToolItems(profile['headline'] ?? 'Anxiety.');
    return ListView(
      key: const ValueKey('profile-screen'),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(32, 64, 32, 40),
          constraints: const BoxConstraints(minHeight: 200),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF0D0604), AppColors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border(
              bottom: BorderSide(color: AppColors.foundationBorder),
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -60,
                right: -60,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.orangeGlow.withValues(alpha: 0.34),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'BASED ON WHAT YOU\'VE TOLD US',
                    style: AppTheme.body(
                      size: 9.5,
                      weight: FontWeight.w500,
                      color: AppColors.orange,
                    ).copyWith(letterSpacing: 2.35),
                  ),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      text: 'I SEE\n',
                      children: [
                        TextSpan(
                          text: profile['headline']!.toUpperCase(),
                          style: const TextStyle(color: AppColors.orange),
                        ),
                      ],
                    ),
                    style: AppTheme.bebas(
                      size: 36,
                      height: 1.05,
                      letterSpacing: 0.7,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 32, 32, 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'WHAT THIS ACTUALLY MEANS',
                style: AppTheme.body(
                  size: 9,
                  weight: FontWeight.w500,
                  color: AppColors.teal,
                ).copyWith(letterSpacing: 2.2),
              ),
              const SizedBox(height: 14),

              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Stack(
                  children: [
                    Container(
                      // padding: const EdgeInsets.fromLTRB(18, 22, 20, 22),
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
                      child: _ProfileRecognitionText(
                        text: profile['recognition']!,
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
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.orangeDim,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.orangeGlow),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'THE BELIEF DRIVING THIS',
                      style: AppTheme.body(
                        size: 9,
                        weight: FontWeight.w500,
                        color: AppColors.orange,
                      ).copyWith(letterSpacing: 2),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      profile['belief']!,
                      style: AppTheme.bebas(
                        size: 22,
                        height: 1.2,
                        letterSpacing: 0.65,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      profile['beliefSub']!,
                      style: AppTheme.body(
                        size: 12.5,
                        color: AppColors.foundationMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'YOUR TOOLS',
                style: AppTheme.body(
                  size: 9,
                  weight: FontWeight.w500,
                  color: AppColors.teal,
                ).copyWith(letterSpacing: 2.2),
              ),
              const SizedBox(height: 12),
              ...toolItems.asMap().entries.map(
                (entry) => Padding(
                  padding: EdgeInsets.only(bottom: entry.key == 5 ? 0 : 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: entry.key == 0
                          ? AppColors.orangeDim
                          : AppColors.foundationGrey,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: entry.key == 0
                            ? AppColors.orangeGlow
                            : AppColors.foundationBorder,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.value.icon,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.value.title,
                                style: AppTheme.bebas(
                                  size: 16,
                                  height: 1.1,
                                  letterSpacing: 0.65,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                entry.value.description,
                                style: AppTheme.body(
                                  size: 12,
                                  color: AppColors.foundationMuted,
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

class _ProfileRecognitionText extends StatelessWidget {
  const _ProfileRecognitionText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final paragraphs = text.split('\n\n');
    final secondParagraph = paragraphs.length > 1 ? paragraphs[1] : '';
    final strongStart = secondParagraph.indexOf('You define you');
    final strongEnd = secondParagraph.indexOf(' That changes now.');

    final baseStyle = AppTheme.body(
      size: 14,
      color: const Color(0xFFD4CFCA),
      weight: FontWeight.w500,
      height: 1.72,
    );

    final spans = <InlineSpan>[TextSpan(text: paragraphs.first)];

    if (secondParagraph.isNotEmpty) {
      spans.add(const TextSpan(text: '\n\n'));
      if (strongStart >= 0 && strongEnd > strongStart) {
        spans
          ..add(TextSpan(text: secondParagraph.substring(0, strongStart)))
          ..add(
            TextSpan(
              text: secondParagraph.substring(strongStart, strongEnd),
              style: baseStyle.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          )
          ..add(TextSpan(text: secondParagraph.substring(strongEnd)));
      } else {
        spans.add(TextSpan(text: secondParagraph));
      }
    }

    return Text.rich(TextSpan(children: spans), style: baseStyle);
  }
}

List<_ProfileToolItem> _profileToolItems(String headline) {
  final normalised = headline.toLowerCase();
  final isBurnout = normalised.contains('burnout');
  final isOverwhelm = normalised.contains('overwhelm');

  final reframeDescription = isBurnout
      ? 'Shifts how you see the situation so it stops owning you.'
      : isOverwhelm
      ? 'Shifts how you see the load so it stops feeling impossible.'
      : 'Takes the thought that\'s eating at you and shifts how you see it.';

  final problemDescription = isOverwhelm
      ? 'Cuts through and gets you to one clear next step.'
      : 'Cuts through the noise and gets you to a clear next step.';

  final productivityDescription = isOverwhelm
      ? 'Finds where your energy is going and helps you take it back.'
      : 'Finds where your energy is actually going and helps you take it back.';

  return [
    const _ProfileToolItem(
      icon: '📊',
      title: 'Coping Level',
      description:
          'Measures where you\'re at right now so we know exactly what to work on first.',
    ),
    const _ProfileToolItem(
      icon: '🧠',
      title: 'Self Enquiry',
      description:
          'Gets under the surface of what\'s actually driving the anxiety, burnout, or overwhelm.',
    ),
    const _ProfileToolItem(
      icon: '⚡',
      title: 'Unwire The Thought',
      description: 'Breaks the thought pattern before it spirals.',
    ),
    _ProfileToolItem(
      icon: '🔄',
      title: 'Reframing',
      description: reframeDescription,
    ),
    _ProfileToolItem(
      icon: '🎯',
      title: 'Problem Solve',
      description: problemDescription,
    ),
    _ProfileToolItem(
      icon: '💥',
      title: 'Productivity Superpower',
      description: productivityDescription,
    ),
  ];
}

class _ProfileToolItem {
  const _ProfileToolItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final String icon;
  final String title;
  final String description;
}

class _CommitmentScreen extends StatelessWidget {
  const _CommitmentScreen({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const ValueKey('commitment-screen'),
      padding: const EdgeInsets.fromLTRB(32, 52, 32, 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ONE LAST THING',
                      style: AppTheme.body(
                        size: 9,
                        weight: FontWeight.w700,
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
                      style: AppTheme.bebas(size: 56, height: 0.95),
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
                                  size: 13,
                                  color: AppColors.foundationMuted,
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
                      'WHAT DO WE CALL YOU?',
                      style: AppTheme.body(
                        size: 9,
                        color: AppColors.foundationMuted,
                        weight: FontWeight.w500,
                      ).copyWith(letterSpacing: 2),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller:
                          TextEditingController(text: controller.commitName)
                            ..selection = TextSelection.collapsed(
                              offset: controller.commitName.length,
                            ),
                      onChanged: controller.updateCommitName,
                      scrollPadding: _onboardingKeyboardScrollPadding,
                      onTapOutside: (_) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      decoration: _onboardingInputDecoration(
                        hintText: 'First name',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
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
