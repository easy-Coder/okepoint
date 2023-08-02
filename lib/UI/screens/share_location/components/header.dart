import 'package:flutter/cupertino.dart';

import '../../../../constants/image_paths.dart';
import '../../../components/cards/paddings.dart';
import '../../../components/texts/texts.dart';
import '../../../theme/spacings.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacings.elementSpacing),
        Image.asset(
          ImagePaths.contactPoint,
          height: 80,
        ),
        const SizedBox(height: AppSpacings.elementSpacing),
        Column(
          children: [
            OkepointTexts.headingBig(
              "Find your friends and Family on a Map",
              context,
              center: true,
            ),
            const SizedBox(height: AppSpacings.elementSpacing),
            CardPadding(
              child: OkepointTexts.bodyText(
                "Select mode & start sharing your location with your firends or family members.",
                context,
                center: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
