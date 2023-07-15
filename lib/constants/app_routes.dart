enum AppRoutes { home, auth }

extension AppRouteExtension on AppRoutes {
  String get path {
    switch (this) {
      case AppRoutes.home:
        return '/home';
      case AppRoutes.auth:
        return '/authentication';
      default:
        return '/';
    }
  }
}
