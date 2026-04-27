import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:you_define_you/controllers/app_controller.dart';
import 'package:you_define_you/models/app_models.dart';
import 'package:you_define_you/services/local_storage_service.dart';

void main() {
  test('controller starts in join stage by default', () async {
    SharedPreferences.setMockInitialValues({});
    final controller = AppController(storageService: LocalStorageService());
    await controller.initialize();

    expect(controller.currentStage, AppStage.join);
  });
}
