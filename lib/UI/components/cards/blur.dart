import 'package:flutter/material.dart';

import '../../theme/spacings.dart';

class BlurCardArea extends StatelessWidget {
  final Alignment begin;
  final Alignment end;
  final Color? color;
  final double? width;
  final double? height;

  const BlurCardArea({
    Key? key,
    required this.begin,
    required this.end,
    this.color,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        height: height ?? 40,
        width: width ?? AppSpacings.cardPadding,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            colors: [
              (color ?? Theme.of(context).colorScheme.background).withOpacity(.0001),
              (color ?? Theme.of(context).colorScheme.background).withOpacity(.4),
              color ?? Theme.of(context).colorScheme.background,
            ],
          ),
        ),
      ),
    );
  }
}
