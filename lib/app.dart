import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/UI/theme/theme.dart';
import 'package:okepoint/data/services/navigation_service.dart';

class OkePointApp extends ConsumerWidget {
  const OkePointApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationService = ref.read(navigationServiceProvider);
    final appTheme = ref.read(appThemeProvider);

    return ValueListenableBuilder<ThemeData>(
        valueListenable: appTheme.themeDataNotifier,
        builder: (context, theme, _) {
          return MaterialApp.router(
            theme: theme,
            routerConfig: navigationService.router,
            shortcuts: {
              LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
            },
            title: 'Òkè point',
            builder: (context, widget) => Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => widget ?? const SizedBox(),
                ),
              ],
            ),
          );
        });
  }
}
