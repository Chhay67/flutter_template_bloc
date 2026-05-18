class Routes {
  static const login = RouteData(name: 'login', path: '/login');

  static const register = RouteData(name: 'register', path: '/register');
  static const unauthorized = RouteData(
    name: 'unauthorized',
    path: '/unauthorized',
  );
  static const settings = RouteData(name: 'settings', path: '/settings');
  static const dashboard = RouteData(name: 'dashboard', path: '/');

  static final Set<String> guestOnlyPaths = {
    login.path,
    register.path,
  };

  static final Set<String> redirectAllowedPaths = {
    dashboard.path,
    settings.path,
  };
}

class RouteData {
  const RouteData({required this.name, required this.path});

  final String name;
  final String path;
}
