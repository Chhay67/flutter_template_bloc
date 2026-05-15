import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template_bloc/app/bloc/app_loading_cubit/app_loading_cubit.dart';
import 'package:flutter_template_bloc/app/route/app_router.dart';
import 'package:flutter_template_bloc/app/widget/app_overlay.dart';
import 'package:go_router/go_router.dart';

import '../core/di/init_dependencies.dart';
import 'bloc/app_session_cubit/app_session_cubit.dart';

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppSessionCubit>.value(
          value: serviceLocator<AppSessionCubit>(),
        ),
        BlocProvider<AppLoadingCubit>.value(
          value: serviceLocator<AppLoadingCubit>(),
        ),
      ],
      child: MaterialApp.router(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        title: 'Flutter Clean Architecture with Bloc Demo',
        routerConfig: serviceLocator<GoRouter>(),
        builder: (context, child) => AppOverlay(child: child),
      ),
    );
  }
}
