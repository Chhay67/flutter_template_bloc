


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'app/bloc/app_session_cubit/app_session_cubit.dart';
import 'app/root_app.dart';
import 'core/config/app_config.dart';
import 'core/di/init_dependencies.dart';
import 'core/enum/flavor_enum.dart';
import 'core/utils/app_logger.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await AppConfig.init(appFlavor: FlavorEnum.production);

    usePathUrlStrategy();

    await initBootDependencies();

    runApp(const RootApp());

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await serviceLocator<AppSessionCubit>().onAppStart();
      await initLazyDependencies();
    });
  }, (error, stackTrace) {
    AppLogger.error(error.toString(), stackTrace: stackTrace);
  });
}