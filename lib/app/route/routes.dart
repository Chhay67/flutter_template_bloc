class Routes {
  static const login = _RouteData(name: 'login', path: '/login');

  static const register = _RouteData(name: 'register', path: '/register');
  static const settings = _RouteData(name: 'settings', path: '/settings');
  static const dashboard = _RouteData(name: 'dashboard', path: '/');

  static final Set<String> blockedRedirectPaths = {
    login.path,
    register.path,
  };
}

class _RouteData {
  const _RouteData({required this.name, required this.path});

  final String name;
  final String path;
}
