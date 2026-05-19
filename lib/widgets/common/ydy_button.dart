import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';

class YdyButton extends StatelessWidget {
  const YdyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.ghost = false,
    this.textSize,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool ghost;
  final double? textSize;

  @override
  Widget build(BuildContext context) {
    // final effectiveTextSize = textSize ?? (ghost ? 13.0 : 15.0);

    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: ghost ? Colors.transparent : AppColors.orange,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: const Color(0xFF2A2A2A),
          disabledForegroundColor: const Color(0xFF444444),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: ghost
                ? const BorderSide(color: AppColors.border)
                : BorderSide.none,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          label,
          style: ghost
              ? AppTheme.body(
                  size: 13,
                  weight: FontWeight.w400,
                  color: AppColors.muted,
                )
              : AppTheme.bebas(size: textSize ?? 15.0, letterSpacing: 1.35),
        ),
      ),
    );
  }
}
