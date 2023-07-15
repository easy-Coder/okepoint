import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/data/services/navigation_service.dart';

class OkePointApp extends ConsumerWidget {
  const OkePointApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationService = ref.read(navigationServiceProvider);

    return MaterialApp.router(
      routeInformationProvider: navigationService.router.routeInformationProvider,
      routeInformationParser: navigationService.router.routeInformationParser,
      routerDelegate: navigationService.router.routerDelegate,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
      },
      title: 'òkè point',
      builder: (context, widget) => Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (context) => widget ?? const SizedBox(),
          ),
        ],
      ),
    );
  }
}
