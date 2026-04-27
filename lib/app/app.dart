import 'package:flutter/material.dart';

import '../controllers/app_controller.dart';
import '../views/root/root_view.dart';
import 'theme/app_theme.dart';

class YouDefineYouApp extends StatelessWidget {
  const YouDefineYouApp({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'You Define You',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: RootView(controller: controller),
    );
  }
}
