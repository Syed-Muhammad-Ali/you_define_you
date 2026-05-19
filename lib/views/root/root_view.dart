import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';
import '../../models/app_models.dart';
import '../../screens/signin_screen.dart';
import '../foundation/foundation_dashboard_screen.dart';
import '../join/join_flow_screen.dart';
import '../onboarding/onboarding_flow_screen.dart';

class RootView extends StatelessWidget {
  const RootView({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (!controller.isAuthenticated) {
          return SignInScreen(controller: controller);
        }

        switch (controller.currentStage) {
          case AppStage.foundation:
            return FoundationDashboardScreen(controller: controller);
          case AppStage.onboarding:
            return OnboardingFlowScreen(controller: controller);
          case AppStage.join:
            return JoinFlowScreen(controller: controller);
        }
      },
    );
  }
}
