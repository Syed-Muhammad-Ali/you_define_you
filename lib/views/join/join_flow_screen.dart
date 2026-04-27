import 'package:flutter/material.dart';

import '../../app/constants/app_content.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../controllers/app_controller.dart';
import '../../widgets/common/ydy_shell.dart';

class JoinFlowScreen extends StatelessWidget {
  const JoinFlowScreen({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return YdyShell(
      safeTop: false,
      safeBottom: false,
      showGlow: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth < 480
              ? constraints.maxWidth
              : 480.0;

          return Center(
            child: SizedBox(
              width: width,
              height: constraints.maxHeight,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: switch (controller.joinStep) {
                  1 => _JoinWelcomeStep(controller: controller),
                  2 => _JoinWhatStep(controller: controller),
                  3 => _JoinSeenStep(controller: controller),
                  _ => _JoinConsentStep(controller: controller),
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _JoinStepScaffold extends StatelessWidget {
  const _JoinStepScaffold({required this.valueKey, required this.children});

  final String valueKey;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      key: ValueKey(valueKey),
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 56, 32, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _JoinWelcomeStep extends StatelessWidget {
  const _JoinWelcomeStep({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return _JoinStepScaffold(
      valueKey: 'join-1',
      children: [
        const _JoinLogo(),
        const SizedBox(height: 8),
        const _JoinTagline(),
        const SizedBox(height: 32),
        const Spacer(),
        _JoinHeadline(
          spans: const [
            TextSpan(text: 'You\'ve been\ncarrying this\n'),
            TextSpan(
              text: 'long enough.',
              style: TextStyle(color: AppColors.orange),
            ),
          ],
          size: 48,
          height: 1.0,
        ),
        const SizedBox(height: 20),
        const _JoinParagraph(
          'This is a space built for men. Not a therapy app. Not a meditation app. A method. The You Define You Mindset Method — built to help you understand what\'s going on, where it came from, and what to do about it.',
        ),
        const SizedBox(height: 14),
        const _JoinParagraph(
          'It\'s going to take some honest work. And it\'s going to be worth it.',
        ),
        const SizedBox(height: 30),
        _JoinButton(
          label: 'I\'m ready — show me more →',
          onPressed: () => controller.advanceJoinStep(2),
        ),
        const SizedBox(height: 12),
        const _JoinPrivacy('Free to use. No judgement. No nonsense.'),
      ],
    );
  }
}

class _JoinWhatStep extends StatelessWidget {
  const _JoinWhatStep({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return _JoinStepScaffold(
      valueKey: 'join-2',
      children: [
        _BackLink(onTap: () => controller.advanceJoinStep(1)),
        const SizedBox(height: 24),
        const _JoinEyebrow('What you\'re walking into'),
        const SizedBox(height: 10),
        _JoinHeadline(
          spans: const [
            TextSpan(text: 'This isn\'t about '),
            TextSpan(
              text: 'talking',
              style: TextStyle(color: AppColors.orange),
            ),
            TextSpan(text: ' about it.\nIt\'s about '),
            TextSpan(
              text: 'changing',
              style: TextStyle(color: AppColors.orange),
            ),
            TextSpan(text: ' it.'),
          ],
          size: 38,
          height: 1.1,
        ),
        const SizedBox(height: 24),
        ...List.generate(AppContent.joinStepTwo.length, (index) {
          final parts = AppContent.joinStepTwo[index].split('\n');
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == AppContent.joinStepTwo.length - 1 ? 0 : 14,
            ),
            child: _JoinWhatCard(
              icon: AppContent.joinStepTwoIcons[index],
              title: parts.first,
              text: parts.length > 1 ? parts.sublist(1).join('\n') : '',
            ),
          );
        }),
        const SizedBox(height: 24),
        const Spacer(),
        _JoinButton(
          label: 'This is what I need →',
          onPressed: () => controller.advanceJoinStep(3),
        ),
      ],
    );
  }
}

class _JoinSeenStep extends StatelessWidget {
  const _JoinSeenStep({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return _JoinStepScaffold(
      valueKey: 'join-3',
      children: [
        _BackLink(onTap: () => controller.advanceJoinStep(2)),
        const SizedBox(height: 24),
        const _JoinEyebrow('Before we go any further'),
        const SizedBox(height: 10),
        _JoinHeadline(
          spans: const [
            TextSpan(text: 'We want you to know\nwe '),
            TextSpan(
              text: 'see',
              style: TextStyle(color: AppColors.orange),
            ),
            TextSpan(text: ' you.'),
          ],
          size: 38,
          height: 1.1,
        ),
        const SizedBox(height: 24),
        ...List.generate(AppContent.joinStepThree.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == AppContent.joinStepThree.length - 1 ? 0 : 14,
            ),
            child: _JoinSeenCard(text: AppContent.joinStepThree[index]),
          );
        }),
        const SizedBox(height: 24),
        const Spacer(),
        _JoinButton(
          label: 'That\'s me — let\'s do this →',
          onPressed: () => controller.advanceJoinStep(4),
        ),
      ],
    );
  }
}

class _JoinConsentStep extends StatelessWidget {
  const _JoinConsentStep({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return _JoinStepScaffold(
      valueKey: 'join-4',
      children: [
        _BackLink(onTap: () => controller.advanceJoinStep(3)),
        const SizedBox(height: 24),
        const _JoinEyebrow('Almost there'),
        const SizedBox(height: 10),
        _JoinHeadline(
          spans: const [
            TextSpan(text: 'Your details.\nYour '),
            TextSpan(
              text: 'data.',
              style: TextStyle(color: AppColors.orange),
            ),
          ],
          size: 38,
          height: 1.1,
        ),
        const SizedBox(height: 24),
        const _JoinParagraph(
          'We store your name and email so we can bring your progress back if you return. That\'s it. We don\'t sell it, share it, or use it for advertising. Ever.',
        ),
        const SizedBox(height: 20),
        const _GdprBox(),
        const SizedBox(height: 20),
        _JoinInput(
          initialValue: controller.joinName,
          hint: 'Your first name',
          textInputAction: TextInputAction.next,
          onChanged: controller.updateJoinName,
        ),
        const SizedBox(height: 10),
        _JoinInput(
          initialValue: controller.joinEmail,
          hint: 'Your email address',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onChanged: controller.updateJoinEmail,
        ),
        const SizedBox(height: 18),
        _ConsentRow(
          label:
              'I understand how my data is stored and used as described above',
          value: controller.consentData,
          onTap: controller.toggleConsentData,
        ),
        const SizedBox(height: 12),
        _ConsentRow(
          label: 'I confirm I am 18 years of age or older',
          value: controller.consentAge,
          onTap: controller.toggleConsentAge,
        ),
        const SizedBox(height: 24),
        _JoinButton(
          label: 'Start my journey →',
          enabled: controller.joinReady,
          onPressed: controller.submitJoin,
        ),
        const SizedBox(height: 12),
        const _JoinPrivacy(
          'No spam. No selling your data. You can delete everything at any time.',
        ),
      ],
    );
  }
}

class _JoinLogo extends StatelessWidget {
  const _JoinLogo();

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      const TextSpan(
        text: 'You Define ',
        children: [
          TextSpan(
            text: 'You',
            style: TextStyle(color: AppColors.orange),
          ),
        ],
      ),
      style: AppTheme.bebas(
        size: 18,
        letterSpacing: 2.7,
        color: AppColors.white.withValues(alpha: 0.4),
      ),
    );
  }
}

class _JoinTagline extends StatelessWidget {
  const _JoinTagline();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Men\'s Mental Health · You Define You Mindset',
      style: AppTheme.body(
        size: 10.5,
        weight: FontWeight.w600,
        color: AppColors.white.withValues(alpha: 0.2),
        height: 1.4,
      ).copyWith(letterSpacing: 0.8),
    );
  }
}

class _BackLink extends StatelessWidget {
  const _BackLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(
          '← Back',
          style: AppTheme.body(
            size: 12.5,
            color: AppColors.white.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}

class _JoinEyebrow extends StatelessWidget {
  const _JoinEyebrow(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTheme.body(
        size: 11,
        weight: FontWeight.w700,
        color: AppColors.orange,
        height: 1.2,
      ).copyWith(letterSpacing: 1.3),
    );
  }
}

class _JoinHeadline extends StatelessWidget {
  const _JoinHeadline({
    required this.spans,
    required this.size,
    required this.height,
  });

  final List<InlineSpan> spans;
  final double size;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(children: spans),
      style: AppTheme.bebas(
        size: size,
        height: height,
        letterSpacing: 1.1,
        color: AppColors.white,
      ),
    );
  }
}

class _JoinParagraph extends StatelessWidget {
  const _JoinParagraph(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTheme.body(
        size: 13.6,
        height: 1.7,
        color: AppColors.white.withValues(alpha: 0.5),
      ),
    );
  }
}

class _JoinButton extends StatelessWidget {
  const _JoinButton({
    required this.label,
    required this.onPressed,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange,
          disabledBackgroundColor: AppColors.orange.withValues(alpha: 0.4),
          foregroundColor: AppColors.white,
          disabledForegroundColor: AppColors.white.withValues(alpha: 0.75),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTheme.bebas(
            size: 18.5,
            letterSpacing: 1.1,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

class _JoinPrivacy extends StatelessWidget {
  const _JoinPrivacy(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTheme.body(
          size: 11,
          height: 1.5,
          color: AppColors.white.withValues(alpha: 0.2),
        ),
      ),
    );
  }
}

class _JoinWhatCard extends StatelessWidget {
  const _JoinWhatCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  final String icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.03),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.07)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(icon, style: const TextStyle(fontSize: 21)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.body(
                    size: 13.6,
                    weight: FontWeight.w700,
                    color: AppColors.white,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  text,
                  style: AppTheme.body(
                    size: 12,
                    height: 1.55,
                    color: AppColors.white.withValues(alpha: 0.45),
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

class _JoinSeenCard extends StatelessWidget {
  const _JoinSeenCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 18, 16),
      decoration: const BoxDecoration(
        color: Color(0x0DFF6B35),
        border: Border(left: BorderSide(color: AppColors.orange, width: 3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✓',
            style: AppTheme.body(
              size: 14,
              weight: FontWeight.w700,
              color: AppColors.orange,
              height: 1.5,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: AppTheme.body(
                size: 13.2,
                height: 1.6,
                color: AppColors.white.withValues(alpha: 0.65),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GdprBox extends StatelessWidget {
  const _GdprBox();

  static const _items = [
    (
      '🔒',
      'Stored locally on your device.',
      'Your progress — diary entries, tool answers, beliefs — is saved in your browser. It stays there until you clear it.',
    ),
    (
      '📧',
      'Your email is for account recovery only.',
      'If you return on a new device, your email lets us reconnect you to your progress.',
    ),
    (
      '🗑',
      'You can delete everything anytime.',
      'Tap \'Delete my data\' in the app footer and it\'s gone — permanently, immediately.',
    ),
    (
      '🇬🇧',
      'GDPR compliant.',
      'You have the right to access, correct, or delete your data at any time. We comply with UK GDPR.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.03),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How your data works',
            style: AppTheme.body(
              size: 10.5,
              weight: FontWeight.w700,
              color: AppColors.white.withValues(alpha: 0.3),
              height: 1.2,
            ).copyWith(letterSpacing: 1.1),
          ),
          const SizedBox(height: 14),
          ..._items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(item.$1, style: const TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: '${item.$2} ',
                        style: AppTheme.body(
                          size: 11.8,
                          weight: FontWeight.w700,
                          height: 1.55,
                          color: AppColors.white.withValues(alpha: 0.7),
                        ),
                        children: [
                          TextSpan(
                            text: item.$3,
                            style: AppTheme.body(
                              size: 11.8,
                              height: 1.55,
                              color: AppColors.white.withValues(alpha: 0.45),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JoinInput extends StatelessWidget {
  const _JoinInput({
    required this.initialValue,
    required this.hint,
    required this.onChanged,
    this.keyboardType,
    this.textInputAction,
  });

  final String initialValue;
  final String hint;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      cursorColor: AppColors.orange,
      style: AppTheme.body(size: 14, color: AppColors.white, height: 1.4),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTheme.body(
          size: 14,
          color: AppColors.white.withValues(alpha: 0.2),
        ),
        filled: true,
        fillColor: AppColors.white.withValues(alpha: 0.05),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.white.withValues(alpha: 0.12),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.orange),
        ),
      ),
    );
  }
}

class _ConsentRow extends StatelessWidget {
  const _ConsentRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final bool value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: value
                    ? AppColors.orange
                    : AppColors.white.withValues(alpha: 0.2),
                width: 2,
              ),
              color: value ? AppColors.orange : Colors.transparent,
            ),
            alignment: Alignment.center,
            child: Text(
              value ? '✓' : '',
              style: AppTheme.body(
                size: 11,
                weight: FontWeight.w700,
                color: AppColors.white,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppTheme.body(
                size: 12.2,
                height: 1.55,
                color: AppColors.white.withValues(alpha: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
