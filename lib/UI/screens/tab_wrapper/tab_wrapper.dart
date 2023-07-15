import 'package:flutter/material.dart';

class TabWrapper extends StatelessWidget {
  final Widget body;
  const TabWrapper({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: ClipRRect(child: body),
      ),
    );
  }
}
