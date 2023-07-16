// ignore_for_file: constant_identifier_names

enum AppRoutes { share_location, profile, auth }

extension AppRouteExtension on AppRoutes {
  String get path {
    switch (this) {
      case AppRoutes.share_location:
        return '/share_location';
      case AppRoutes.profile:
        return '/profile';
      case AppRoutes.auth:
        return '/authentication';
      default:
        return '/';
    }
  }
}
