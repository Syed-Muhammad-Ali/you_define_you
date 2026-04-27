import 'dart:ui';

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class YdyShell extends StatelessWidget {
  const YdyShell({
    super.key,
    required this.child,
    this.safeTop = true,
    this.safeBottom = true,
    this.showGlow = true,
  });

  final Widget child;
  final bool safeTop;
  final bool safeBottom;
  final bool showGlow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(color: AppColors.black),
            ),
          ),
          if (showGlow)
            Positioned(
              right: -40,
              top: MediaQuery.of(context).size.height * 0.18,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 42, sigmaY: 42),
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [AppColors.orangeGlow, Colors.transparent],
                      stops: [0, 0.7],
                    ),
                  ),
                ),
              ),
            ),
          SafeArea(top: safeTop, bottom: safeBottom, child: child),
        ],
      ),
    );
  }
}
