

class Routes {

  static const root = _RouteData(name: 'root', path: '/');
  static const login = _RouteData(name: 'login', path: '/login');
  static const settings = _RouteData(name: 'settings', path: '/settings');
  static const dashboard = _RouteData(name: 'dashboard', path: '/dashboard');

  static final List<String> validPaths = [
    login.path,
    dashboard.path,
    settings.path,
  ];
}



class _RouteData{
  const _RouteData({required this.name,required this.path});
  final String name;
  final String path;
}