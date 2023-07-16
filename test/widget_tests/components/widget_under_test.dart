import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/app.dart';

Widget createWidgetUnderTest({List<Override>? overrides}) {
  return ProviderScope(
    overrides: overrides ?? [],
    child: const ProviderScope(child: OkePointApp()),
  );
}
