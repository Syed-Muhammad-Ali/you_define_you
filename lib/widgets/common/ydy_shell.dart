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
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth < 480
                  ? constraints.maxWidth
                  : 480.0;

              return Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: width,
                  height: constraints.maxHeight,
                  child: SafeArea(
                    top: safeTop,
                    bottom: safeBottom,
                    child: child,
                  ),
                ),
              );
            },
          ),
          const Positioned.fill(
            child: IgnorePointer(child: CustomPaint(painter: _NoisePainter())),
          ),
        ],
      ),
    );
  }
}

class _NoisePainter extends CustomPainter {
  const _NoisePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.white.withValues(alpha: 0.018);
    const step = 7.0;
    for (double y = 0; y < size.height; y += step) {
      for (double x = 0; x < size.width; x += step) {
        final seed = ((x * 17 + y * 31).round() % 13);
        if (seed == 0 || seed == 5) {
          canvas.drawRect(Rect.fromLTWH(x, y, 0.7, 0.7), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
