import 'package:flutter/material.dart';

class OkeListTile extends StatelessWidget {
  final Widget title;
  final Widget trailing;

  const OkeListTile({
    super.key,
    required this.title,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: title),
        trailing,
      ],
    );
  }
}
