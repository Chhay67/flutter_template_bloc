import 'package:flutter/material.dart';
import 'package:flutter_template_bloc/app/route/guards.dart';
import 'package:flutter_template_bloc/app/route/routes.dart';
import 'package:flutter_template_bloc/app/route/utils/custom_go_route.dart';
import 'package:flutter_template_bloc/app/route/utils/refresh_listenable.dart';
import 'package:flutter_template_bloc/core/enum/user_role_enum.dart';
import 'package:flutter_template_bloc/features/auth/presentation/page/login_page.dart';
import 'package:flutter_template_bloc/features/auth/presentation/page/register_page.dart';
import 'package:go_router/go_router.dart';

import '../../core/extension/app_extension.dart';
import '../../features/dashboard/presentation/page/dashboard_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../bloc/app_session_cubit/app_session_cubit.dart';
import '../widget/app_error_page.dart';
import '../widget/main_scaffold_page.dart';
import '../widget/unauthorized_page.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class AppGoRouter {
  AppGoRouter._();

  static final GlobalKey<NavigatorState> rootNavKey =
      GlobalKey<NavigatorState>();

  static final GlobalKey<NavigatorState> shellNavKey =
      GlobalKey<NavigatorState>();

  static GoRouter createRouter({required AppSessionCubit appSession}) {
    return GoRouter(
      navigatorKey: rootNavKey,
      debugLogDiagnostics: true,
      initialLocation: Routes.dashboard.path,
      refreshListenable: GoRouterRefreshStream([appSession.stream]),

      routes: [
        CustomGoRoute(
          path: Routes.login.path,
          name: Routes.login.name,
          appSession: appSession,
          guards: [guestGuard],
          builder: (context, state) => const LoginPage(),
        ),
        CustomGoRoute(
          path: Routes.register.path,
          name: Routes.register.name,
          appSession: appSession,
          guards: [guestGuard],
          builder: (context, state) => const RegisterPage(),
        ),
        CustomGoRoute(
          path: Routes.unauthorized.path,
          name: Routes.unauthorized.name,
          appSession: appSession,
          guards: [authGuard],
          builder: (context, state) => const UnauthorizedPage(),
        ),
        ShellRoute(
          navigatorKey: shellNavKey,
          builder: (context, state, child) {
            final location = state.uri.path;

            final initNavBarIndex = MainScaffoldPage.tabs.indexWhereOrNull(
              (tab) => tab.route.path == location,
            );

            return MainScaffoldPage(
              initNavBarIndex: initNavBarIndex,
              child: child,
            );
          },

          routes: [
            CustomGoRoute(
              path: Routes.dashboard.path,
              name: Routes.dashboard.name,
              appSession: appSession,
              guards: [authGuard],
              builder: (context, state) => const DashboardPage(),
            ),
            CustomGoRoute(
              path: Routes.settings.path,
              name: Routes.settings.name,
              appSession: appSession,
              guards: [
                authGuard,
                roleGuard(
                  allowedRoles: {UserRoleEnum.admin},
                ),
              ],
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],

      errorBuilder: (context, state) {
        return AppErrorPage(location: state.uri.toString(), error: state.error);
      },
    );
  }
}
