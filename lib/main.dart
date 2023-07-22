import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

main() {
  runZonedGuarded<Future<void>>(() async {
    await configureApp(AppFlavor.dev);
    runApp(const ProviderScope(child: OkePointApp()));
  }, (error, stack) => debugPrint(error.toString()));
}
