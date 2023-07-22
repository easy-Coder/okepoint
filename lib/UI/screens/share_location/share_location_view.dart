import 'package:flutter/material.dart';
import 'package:okepoint/UI/components/texts/texts.dart';
import 'package:okepoint/constants/image_paths.dart';

import '../../components/buttons/primary_button.dart';
import '../../components/cards/paddings.dart';
import '../../theme/spacings.dart';

class ShareLocationViewWidget extends StatelessWidget {
  const ShareLocationViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CardPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacings.elementSpacing),
                    Image.asset(
                      ImagePaths.contactPoint,
                      height: 80,
                    ),
                    const SizedBox(height: AppSpacings.elementSpacing),
                    OkepointTexts.headingBig("Find your friends and Family on a Map", context, center: true),
                    const SizedBox(height: AppSpacings.elementSpacing),
                    CardPadding(
                      child: OkepointTexts.bodyText(
                        "Start sharing your location with your firends or family members.",
                        context,
                        center: true,
                      ),
                    ),
                  ],
                ),
              ),
              OkepointPrimaryButton(
                title: "Start Sharing",
                state: ButtonState.initial,
                onPressed: () {},
              ),
              const SizedBox(height: AppSpacings.cardPadding),
            ],
          ),
        ),
      ),
    );
  }
}
