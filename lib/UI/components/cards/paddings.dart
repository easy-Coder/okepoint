import 'package:flutter/cupertino.dart';
import 'package:okepoint/UI/theme/spacings.dart';

class CardPadding extends StatelessWidget {
  final Widget child;
  const CardPadding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacings.cardPadding),
      child: child,
    );
  }
}
