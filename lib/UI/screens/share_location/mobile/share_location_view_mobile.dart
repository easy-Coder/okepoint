import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/UI/components/texts/texts.dart';
import 'package:okepoint/data/services/map_service.dart';
import 'package:okepoint/data/states/contacts_state.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../components/cards/blur.dart';
import '../../../components/cards/contact.dart';
import '../../../components/cards/emergency_card.dart';
import '../../../components/cards/paddings.dart';
import '../../../theme/spacings.dart';
import '../components/emergencies.dart';
import '../components/header.dart';
import '../share_location_state.dart';

class ShareLocationViewWidget extends ConsumerWidget {
  const ShareLocationViewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapService = ref.read(mapServiceProvider);

    final contacts = ref.watch(contactsStateProvider);
    final selectedEmergency = ref.watch(selectedEmergencyProvider);

    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
            listenable: Listenable.merge([
              mapService.enabledLocationSharing,
            ]),
            builder: (context, _) {
              final isEnabled = mapService.enabledLocationSharing.value;

              return CardPadding(
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(vertical: AppSpacings.cardPadding),
                            child: Column(
                              children: [
                                if (!isEnabled) ...[
                                  const HomeHeader(),
                                  const Emergencies(),
                                ] else if (selectedEmergency != null) ...[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: AppSpacings.cardPadding),
                                      OkepointTexts.subHeading(
                                        "Sharing to contacts base on",
                                        context,
                                      ),
                                      const SizedBox(height: AppSpacings.elementSpacing),
                                      EmergencyCard(
                                        emergency: selectedEmergency,
                                        selected: false,
                                        readOnly: true,
                                      ),
                                      const SizedBox(height: AppSpacings.cardPadding),
                                      ListView.builder(
                                        itemCount: contacts.where((element) => element.emergencyTypes.contains(selectedEmergency.type)).length,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          final contact = contacts[index];

                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: AppSpacings.elementSpacing),
                                            child: ContactCard(contact: contact),
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                ],
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
                      title: isEnabled ? "Stop Sharing" : "Start Sharing Location",
                      color: isEnabled ? Theme.of(context).colorScheme.error : null,
                      state: ButtonState.initial,
                      onPressed: () {
                        if (isEnabled) {
                          mapService.cancelRealtimeLocationShare();
                          return;
                        }
                        mapService.shareLocationRealtime((location) {
                          print(location);
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacings.cardPadding),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
