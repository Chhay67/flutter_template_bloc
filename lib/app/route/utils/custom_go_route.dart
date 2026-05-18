import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_template_bloc/app/bloc/app_session_cubit/app_session_cubit.dart';
import 'package:go_router/go_router.dart';

typedef Guard =
    FutureOr<String?> Function(
      BuildContext context,
      GoRouterState state,
      AppSessionCubit? appSession,
    );

FutureOr<String?> redirectGuards(
  BuildContext context,
  GoRouterState state,
  List<Guard> guards,
  AppSessionCubit? appSession,
) async {
  for (final guard in guards) {
    final result = await guard(context, state, appSession);
    if (result != null) return result;
  }
  return null;
}

class CustomGoRoute extends GoRoute {
  CustomGoRoute({
    required super.path,
    required super.name,
    required super.builder,
    super.pageBuilder,
    List<Guard> guards = const [],
    super.routes,
    super.parentNavigatorKey,
    super.caseSensitive,
    super.onExit,
    AppSessionCubit? appSession,
  }) : super(
         redirect: guards.isEmpty
             ? null
             : (context, state) =>
                   redirectGuards(context, state, guards, appSession),
       );
}
