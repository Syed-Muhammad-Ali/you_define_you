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
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool ghost;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: ghost ? Colors.transparent : AppColors.orange,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.border,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: ghost
                ? const BorderSide(color: AppColors.border)
                : BorderSide.none,
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        child: Text(
          label,
          style: ghost
              ? AppTheme.body(
                  size: 13,
                  weight: FontWeight.w400,
                  color: AppColors.muted,
                )
              : AppTheme.bebas(size: 22, letterSpacing: 1.6),
        ),
      ),
    );
  }
}
