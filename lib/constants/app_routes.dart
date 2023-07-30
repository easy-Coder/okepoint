enum AppRoutes { shareLocation, profile, map }

extension AppRouteExtension on AppRoutes {
  String get path {
    return switch (this) {
      AppRoutes.shareLocation => '/share-location',
      AppRoutes.profile => '/profile',
      AppRoutes.map => '/map-view',
    };
  }
}
