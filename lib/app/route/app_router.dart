import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template_bloc/app/route/routes.dart';
import 'package:flutter_template_bloc/app/route/utils/refresh_listenable.dart';
import 'package:flutter_template_bloc/core/di/init_dependencies.dart';
import 'package:flutter_template_bloc/features/auth/presentation/page/login_page.dart';
import 'package:flutter_template_bloc/features/dashboard/presentation/bloc/user_profile_cubit/user_profile_cubit.dart';
import 'package:go_router/go_router.dart';

import '../../core/extension/app_extension.dart';
import '../../features/dashboard/presentation/bloc/products_cubit/products_cubit.dart';
import '../../features/dashboard/presentation/page/dashboard_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../bloc/app_session_cubit/app_session_cubit.dart';
import '../widget/app_error_page.dart';
import '../widget/main_scaffold_page.dart';
import '../widget/splash_page.dart';
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
class AppGoRouter {
  AppGoRouter._();

  static final GlobalKey<NavigatorState> rootNavKey =
      GlobalKey<NavigatorState>();

  static final GlobalKey<NavigatorState> shellNavKey =
      GlobalKey<NavigatorState>();

  static GoRouter createRouter({required AppSessionCubit appSessionCubit}) {
    return GoRouter(
      navigatorKey: rootNavKey,
      debugLogDiagnostics: true,
      initialLocation: Routes.dashboard.path,

      refreshListenable: GoRouterRefreshStream([appSessionCubit.stream]),

      redirect: (context, state) {
        final session = appSessionCubit.state;
        final location = state.uri.path;

        final isRoot = location == Routes.root.path;
        final isLogin = location == Routes.login.path;

        if (session is SessionInitial || session is SessionLoading) {
          return isRoot ? null : Routes.root.path;
        }

        if (session is SessionUnauthenticated) {
          return isLogin ? null : Routes.login.path;
        }

        if (session is SessionAuthenticated) {
          if (isRoot || isLogin) {
            return Routes.dashboard.path;
          }

          return null;
        }

        return null;
      },

      routes: [
        GoRoute(
          path: Routes.root.path,
          name: Routes.root.name,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: Routes.login.path,
          name: Routes.login.name,
          builder: (context, state) => const LoginPage(),
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
              builder: (context, state) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider<ProductsCubit>(
                      create: (_) =>  serviceLocator<ProductsCubit>()..getProducts(),
                    ),
                    BlocProvider<UserProfileCubit>(
                      create: (context) => serviceLocator<UserProfileCubit>()..fetchUser(),
                    ),
                  ],
                  child: const DashboardPage(),
                );


              },
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
