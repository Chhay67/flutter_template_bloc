import 'package:flutter/material.dart';
import 'package:flutter_template_bloc/app/route/routes.dart';
import 'package:flutter_template_bloc/app/route/utils/refresh_listenable.dart';
import 'package:flutter_template_bloc/features/auth/presentation/page/login_page.dart';
import 'package:flutter_template_bloc/features/auth/presentation/page/register_page.dart';
import 'package:go_router/go_router.dart';

import '../../core/extension/app_extension.dart';
import '../../features/dashboard/presentation/page/dashboard_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../bloc/app_session_cubit/app_session_cubit.dart';
import '../widget/app_error_page.dart';
import '../widget/main_scaffold_page.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class AppGoRouter {
  AppGoRouter._();

  static final GlobalKey<NavigatorState> rootNavKey = GlobalKey<NavigatorState>();

  static final GlobalKey<NavigatorState> shellNavKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter({required AppSessionCubit appSessionCubit}) {
    return GoRouter(
      navigatorKey: rootNavKey,
      debugLogDiagnostics: true,
      initialLocation: Routes.dashboard.path,
      refreshListenable: GoRouterRefreshStream([appSessionCubit.stream]),
      redirect: (context, state) {
        final session = appSessionCubit.state;
        final location = state.uri.path;
        final isLogin = location == Routes.login.path;
        final isDashboard = location == Routes.dashboard.path;
        if (session is SessionUnauthenticated) {
          return isLogin ? null : Routes.login.path;
        }

        if(session is SessionAuthenticated){
          return isDashboard ? null :  Routes.dashboard.path;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: Routes.login.path,
          name: Routes.login.name,
          // redirect: (context, state) {
          //   final session = appSessionCubit.state;
          //   final location = state.uri.path;
          //   final isDashboard = location == Routes.dashboard.path;
          //   if(session is SessionAuthenticated){
          //
          //     return isDashboard ? null :  Routes.dashboard.path;
          //   }
          //   return null;
          // },
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: Routes.register.path,
          name: Routes.register.name,
          builder: (context, state) => const RegisterPage(),
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
            GoRoute(
              path: Routes.dashboard.path,
              name: Routes.dashboard.name,
              builder: (context, state) => const DashboardPage(),
            ),
            GoRoute(
              path: Routes.settings.path,
              name: Routes.settings.name,
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
