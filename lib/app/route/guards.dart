import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../core/enum/user_role_enum.dart';
import '../bloc/app_session_cubit/app_session_cubit.dart';
import 'routes.dart';
import 'utils/custom_go_route.dart';
import 'utils/redirect_query.dart';

String? authGuard(
  BuildContext context,
  GoRouterState state,
  AppSessionCubit? appSession,
) {
  if (appSession == null) {
    return loginLocationWithFrom(loginPath: Routes.login.path, state: state);
  }

  final session = appSession.state;

  if (session is SessionInitial || session is SessionLoading) {
    return null;
  }

  if (session is SessionUnauthenticated) {
    return loginLocationWithFrom(loginPath: Routes.login.path, state: state);
  }

  return null;
}

Guard roleGuard({
  required Set<UserRoleEnum> allowedRoles,
  String? fallbackPath,
}) {
  return (
    BuildContext context,
    GoRouterState state,
    AppSessionCubit? appSession,
  ) {
    if (appSession == null) {
      return null;
    }

    final session = appSession.state;

    if (session is! SessionAuthenticated) {
      return null;
    }

    if (allowedRoles.contains(session.session.user.role)) {
      return null;
    }

    return fallbackPath ?? Routes.unauthorized.path;
  };
}

String? guestGuard(
  BuildContext context,
  GoRouterState state,
  AppSessionCubit? appSession,
) {
  if (appSession == null) {
    return null;
  }

  final session = appSession.state;

  if (session is SessionInitial || session is SessionLoading) {
    return null;
  }

  if (session is SessionAuthenticated) {
    final from = safeFrom(
      state: state,
      allowedRedirectPaths: Routes.redirectAllowedPaths,
      blockedRedirectPaths: Routes.guestOnlyPaths,
    );
    return from ?? Routes.dashboard.path;
  }

  return null;
}
