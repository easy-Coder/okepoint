import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/UI/components/texts/texts.dart';
import 'package:okepoint/data/states/contacts_state.dart';
import '../../../components/cards/contact.dart';
import '../../../components/cards/emergency_card.dart';
import '../../../theme/spacings.dart';
import '../share_location_state.dart';

class SelectedEmergency extends ConsumerWidget {
  const SelectedEmergency({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(contactsStateProvider);
    final selectedEmergency = ref.watch(selectedEmergencyProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacings.cardPadding),
        OkepointTexts.subHeading(
          "Sharing to contacts base on",
          context,
        ),
        const SizedBox(height: AppSpacings.elementSpacing),
        EmergencyCard(emergency: selectedEmergency!, selected: false, readOnly: true),
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
    );
  }
}
