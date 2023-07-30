import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/UI/components/buttons/linked_text.dart';
import 'package:okepoint/UI/components/texts/texts.dart';
import 'package:okepoint/UI/screens/share_location/share_location_state.dart';
import 'package:okepoint/constants/image_paths.dart';

import '../../../data/services/remote_config_service.dart';
import '../../components/buttons/primary_button.dart';
import '../../components/cards/blur.dart';
import '../../components/cards/emergency_card.dart';
import '../../components/cards/paddings.dart';
import '../../theme/spacings.dart';

class ShareLocationViewWidget extends ConsumerWidget {
  const ShareLocationViewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emergencies = ref.read(remoteConfigServiceProvider).appEmergencies;
    final selectedEmergencyId = ref.watch(selectedEmergencyProvider);

    return Scaffold(
      body: SafeArea(
        child: CardPadding(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
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
                              "Select mode & start sharing your location with your firends or family members.",
                              context,
                              center: true,
                            ),
                          ),
                          const SizedBox(height: AppSpacings.cardPadding * 2),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: emergencies.length + 1,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              if (index == emergencies.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: AppSpacings.elementSpacing),
                                  child: LinkedText(
                                    link: "Add Custom Emergency",
                                    onLinkTap: () {},
                                  ),
                                );
                              }
                              return Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacings.elementSpacing),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(15),
                                  onTap: () {
                                    ref.watch(selectedEmergencyProvider.notifier).state = emergencies[index].type;
                                  },
                                  child: EmergencyCard(
                                    emergency: emergencies[index],
                                    selected: selectedEmergencyId == emergencies[index].type,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: AppSpacings.cardPadding * 2),
                        ],
                      ),
                    ),
                    const Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: BlurCardArea(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
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
