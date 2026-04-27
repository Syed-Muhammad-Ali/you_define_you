import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'controllers/app_controller.dart';
import 'services/local_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = LocalStorageService();
  final controller = AppController(storageService: storageService);
  await controller.initialize();

  runApp(YouDefineYouApp(controller: controller));
}
