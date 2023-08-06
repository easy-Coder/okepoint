import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:okepoint/UI/screens/share_location/mobile/share_location_view_mobile.dart';
import 'package:okepoint/constants/app_routes.dart';

import '../../UI/screens/map_view/web/map_view_web.dart';
import '../../UI/screens/profile/mobile/user_profile_mobile.dart';
import '../../UI/screens/tab_wrapper/tab_wrapper.dart';

final navigationServiceProvider = Provider<NavigationService>((ref) {
  return NavigationService(ref);
});

class NavigationService {
  final Ref ref;

  late GlobalKey<NavigatorState> mainNavigatorKey;

  AppRoutes get getInitialPath => kIsWeb ? AppRoutes.map : AppRoutes.shareLocation;

  NavigationService(this.ref) {
    mainNavigatorKey = GlobalKey<NavigatorState>();
  }

  GoRouter get router {
    return GoRouter(
      navigatorKey: mainNavigatorKey,
      initialLocation: getInitialPath.path,
      routes: [
        StatefulShellRoute.indexedStack(
          parentNavigatorKey: mainNavigatorKey,
          pageBuilder: (context, state, navigationShell) {
            return NoTransitionPage(
              child: TabWrapper(
                navigationShell: navigationShell,
              ),
            );
          },
          branches: [
            StatefulShellBranch(
              initialLocation: AppRoutes.shareLocation.path,
              routes: [
                GoRoute(
                  name: AppRoutes.shareLocation.name,
                  path: AppRoutes.shareLocation.path,
                  pageBuilder: (_, state) {
                    return const NoTransitionPage(
                      child: ShareLocationViewWidget(),
                    );
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              initialLocation: AppRoutes.profile.path,
              routes: [
                GoRoute(
                  name: AppRoutes.profile.name,
                  path: AppRoutes.profile.path,
                  pageBuilder: (_, state) {
                    return const NoTransitionPage(
                      child: UserProfileWiget(),
                    );
                  },
                ),
              ],
            )
          ],
        ),
        GoRoute(
          name: AppRoutes.map.name,
          path: AppRoutes.map.path,
          pageBuilder: (_, state) {
            final trackingId = state.queryParameters["trackingId"];

            return NoTransitionPage(
              child: MapView(trackingId: trackingId),
            );
          },
        ),
      ],
    );
  }
}

String getRoutePath(String path, {Map<String, dynamic> quary = const {}}) {
  return Uri(path: path, queryParameters: quary).toString();
}

class TransparentPage<T> extends Page<T> {
  const TransparentPage({
    required this.child,
    this.transitionDuration = const Duration(milliseconds: 1),
    this.reverseTransitionDuration = const Duration(milliseconds: 1),
    this.maintainState = true,
    this.fullscreenDialog = true,
    this.opaque = false,
    this.barrierDismissible = true,
    this.barrierColor,
    this.barrierLabel,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  final Widget child;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
  final bool maintainState;
  final bool fullscreenDialog;
  final bool opaque;
  final bool barrierDismissible;
  final Color? barrierColor;

  final String? barrierLabel;

  @override
  Route<T> createRoute(BuildContext context) => _CustomTransitionPageRoute<T>(this);
}

class _CustomTransitionPageRoute<T> extends PageRoute<T> {
  _CustomTransitionPageRoute(TransparentPage<T> page) : super(settings: page);

  TransparentPage<T> get _page => settings as TransparentPage<T>;

  @override
  bool get barrierDismissible => _page.barrierDismissible;

  @override
  Color? get barrierColor => _page.barrierColor;

  @override
  String? get barrierLabel => _page.barrierLabel;

  @override
  Duration get transitionDuration => _page.transitionDuration;

  @override
  Duration get reverseTransitionDuration => _page.reverseTransitionDuration;

  @override
  bool get maintainState => _page.maintainState;

  @override
  bool get fullscreenDialog => _page.fullscreenDialog;

  @override
  bool get opaque => _page.opaque;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: _page.child,
      );
}
