import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/services/remote_config_service.dart';
import '../../../../data/states/contacts_state.dart';
import '../../../components/buttons/linked_text.dart';
import '../../../components/cards/emergency_card.dart';
import '../../../theme/spacings.dart';
import '../share_location_state.dart';

class Emergencies extends ConsumerWidget {
  const Emergencies({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emergencies = ref.read(remoteConfigServiceProvider).appEmergencies;

    final selectedEmergency = ref.watch(selectedEmergencyProvider);
    final contacts = ref.watch(contactsStateProvider);

    return Column(
      children: [
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
                  link: "Add Emergency",
                  onLinkTap: () {},
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacings.elementSpacing),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () => ref.watch(selectedEmergencyProvider.notifier).state = emergencies[index],
                child: EmergencyCard(
                  emergency: emergencies[index],
                  selected: selectedEmergency?.type == emergencies[index].type,
                  contacts: contacts.where((element) => element.emergencyTypes.contains(emergencies[index].type)).toList(),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacings.cardPadding * 2),
      ],
    );
  }
}
