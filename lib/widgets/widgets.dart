import 'package:flutter/material.dart';

import '../app/theme/app_colors.dart';
import '../app/theme/app_theme.dart';
import '../theme/theme.dart';

// ── MAIN ORANGE BUTTON ──
class YDYButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool enabled;
  final bool loading;
  const YDYButton({
    super.key,
    required this.label,
    this.onTap,
    this.enabled = true,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = enabled && !loading;
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isEnabled ? AppColors.orange : AppColors.border,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: loading
              ? const SizedBox(
                  key: ValueKey('loader'),
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  key: ValueKey(label),
                  label,
                  style: AppTheme.bebas(
                    size: 18,
                    letterSpacing: 1.5,
                    color: isEnabled ? AppColors.white : AppColors.dimText,
                  ),
                ),
        ),
      ),
    );
  }
}

class YDYLoadingOverlay extends StatelessWidget {
  final bool loading;
  final String? message;
  final Widget child;

  const YDYLoadingOverlay({
    super.key,
    required this.loading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        IgnorePointer(
          ignoring: !loading,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: loading ? 1 : 0,
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                decoration: BoxDecoration(
                  color: YDYColors.dark.withValues(alpha: 0.96),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: YDYColors.border),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 24,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation<Color>(YDYColors.orange),
                      ),
                    ),
                    if (message != null && message!.trim().isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Text(
                        message!,
                        textAlign: TextAlign.center,
                        style: YDYTypography.dmSans(
                          fontSize: 13,
                          color: YDYColors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── GHOST / OUTLINE BUTTON ──
class YDYGhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const YDYGhostButton({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: YDYColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
          child: Text(
            label,
            style: YDYTypography.dmSans(fontSize: 13, color: YDYColors.muted),
          ),
      ),
    );
  }
}

// ── CARD CONTAINER ──
class YDYCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;
  final VoidCallback? onTap;
  const YDYCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color ?? YDYColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: YDYColors.border),
        ),
        child: child,
      ),
    );
  }
}

// ── SECTION LABEL ──
class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
        child: Text(
          text.toUpperCase(),
          style: YDYTypography.bebasNeue(
            fontSize: 14,
            letterSpacing: 2,
            color: YDYColors.muted,
          ),
        ),
    );
  }
}

// ── ORANGE LEFT-BORDER STATEMENT ──
class BorderStatement extends StatelessWidget {
  final String text;
  const BorderStatement(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: YDYColors.orange, width: 2)),
      ),
        child: Text(
          text,
          style: YDYTypography.dmSans(
            fontSize: 15,
            color: YDYColors.white,
            fontWeight: FontWeight.w400,
            height: 1.6,
          ),
        ),
    );
  }
}

// ── OPTION SELECTOR TILE ──
class OptionTile extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;
  const OptionTile({
    super.key,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? YDYColors.orangeDim : YDYColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? YDYColors.orange : YDYColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? YDYColors.orange : Colors.transparent,
                border: Border.all(
                  color: selected ? YDYColors.orange : YDYColors.muted,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 10, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Text(
                  text,
                  style: YDYTypography.dmSans(
                    fontSize: 14,
                    color: selected ? YDYColors.white : YDYColors.muted,
                    fontWeight: selected ? FontWeight.w500 : FontWeight.w300,
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── SCORE DOTS (1–10) ──
class ScoreDots extends StatelessWidget {
  final int? selected;
  final Function(int) onSelect;
  const ScoreDots({super.key, this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(10, (i) {
        final n = i + 1;
        final isSelected = selected == n;
        return GestureDetector(
          onTap: () => onSelect(n),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? YDYColors.orange : YDYColors.greyLight,
              border: Border.all(
                color: isSelected ? YDYColors.orange : YDYColors.border,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '$n',
              style: YDYTypography.bebasNeue(
                fontSize: 15,
                color: isSelected ? Colors.white : YDYColors.muted,
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ── PROGRESS BAR ──
class YDYProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final String label;
  final String? rightLabel;
  const YDYProgressBar({
    super.key,
    required this.progress,
    required this.label,
    this.rightLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: YDYTypography.dmSans(fontSize: 13, color: YDYColors.muted),
            ),
            if (rightLabel != null)
              Text(
                rightLabel!,
                style: YDYTypography.dmSans(fontSize: 13, color: YDYColors.muted),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: YDYColors.border,
            valueColor: const AlwaysStoppedAnimation<Color>(YDYColors.orange),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

// ── ORANGE GLOW DECORATION ──
class OrangeGlow extends StatelessWidget {
  final double size;
  const OrangeGlow({super.key, this.size = 260});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [YDYColors.orangeGlow, Colors.transparent],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }
}

// ── SCREEN HEADER WITH BACK ──
class ScreenHeader extends StatelessWidget {
  final String stepLabel;
  final String title;
  final VoidCallback onBack;
  const ScreenHeader({
    super.key,
    required this.stepLabel,
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
      decoration: const BoxDecoration(
        color: YDYColors.dark,
        border: Border(bottom: BorderSide(color: YDYColors.border)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: YDYColors.greyLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: YDYColors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stepLabel,
                style: YDYTypography.dmSans(
                  fontSize: 11,
                  color: YDYColors.orange,
                ),
              ),
              Text(
                title,
                style: YDYTypography.bebasNeue(
                  fontSize: 20,
                  color: YDYColors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
