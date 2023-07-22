import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:okepoint/utils/extentions/primary_extensions.dart';

import '../../../data/models/emergency.dart';
import '../../theme/colors.dart';
import '../../theme/spacings.dart';
import '../texts/texts.dart';

class EmergencyCard extends StatelessWidget {
  final Emergency emergency;
  final bool selected;

  const EmergencyCard({
    super.key,
    required this.emergency,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(15);

    return Container(
      padding: const EdgeInsets.all(AppSpacings.cardPadding),
      decoration: BoxDecoration(
        color: selected ? AppColors.red : Theme.of(context).cardColor,
        borderRadius: borderRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OkepointTexts.headingSmall(emergency.title, context),
                const SizedBox(height: AppSpacings.elementSpacing * 0.25),
                OkepointTexts.bodyText(emergency.subtitle, context),
              ],
            ),
          ),
          Icon(
            CupertinoIcons.add_circled_solid,
            color: (selected ? AppColors.white : Theme.of(context).unselectedWidgetColor).lighten(0.2),
            size: 30,
          ),
        ],
      ),
    );
  }
}
