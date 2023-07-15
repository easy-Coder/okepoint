import 'dart:async';

import 'package:flutter/material.dart';
import 'app.dart';

main() {
  runZonedGuarded<Future<void>>(() async {
    runApp(
      const OkePointApp(),
    );
  }, (error, stack) => debugPrint(error.toString()));
}
