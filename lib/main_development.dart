import 'dart:async';

import 'package:flutter/material.dart';

import 'app/root_app.dart';
import 'core/config/app_config.dart';
import 'core/di/init_dependencies.dart';
import 'core/enum/flavor_enum.dart';
import 'core/utils/app_logger.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await AppConfig.init(appFlavor: FlavorEnum.dev);

    await initDependencies();

    runApp(const RootApp());
  }, (error, stackTrace) {
    AppLogger.error(error.toString(), stackTrace: stackTrace);
  });
}
