import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:okepoint/UI/components/avaters/profile_avater.dart';
import 'package:okepoint/UI/components/cards/list_tile.dart';
import 'package:okepoint/UI/components/cards/paddings.dart';
import 'package:okepoint/UI/components/texts/texts.dart';
import 'package:okepoint/UI/screens/add_edit_contact/mobile/add_edit_contact_view_mobile.dart';
import 'package:okepoint/UI/screens/add_edit_emergecy_contacts/add_edit_emergecy_contacts_state.dart';
import 'package:okepoint/UI/screens/share_location/share_location_state.dart';
import 'package:okepoint/UI/theme/spacings.dart';
import 'package:okepoint/data/models/user/contact.dart';

import '../../../components/buttons/linked_text.dart';
import '../../../components/buttons/primary_button.dart';
import '../../../components/models/cupertino_model.dart';

class AddEditEmergencyContactsViewMobile extends ConsumerWidget {
  const AddEditEmergencyContactsViewMobile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emergency = ref.read(selectedEmergencyProvider);
    if (emergency == null) return const SizedBox.shrink();

    final contacts = ref.watch(addEditEmergencyContactsProvider.call(emergency));
    final notifier = ref.read(addEditEmergencyContactsProvider.call(emergency).notifier);

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: AppSpacings.cardPadding * 0.8),
          CardPadding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OkepointTexts.headingSmall(
                  "Emergency contacts",
                  context,
                ),
                LinkedText(
                  link: "Close",
                  textColor: Theme.of(context).iconTheme.color,
                  onLinkTap: () => context.pop(),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacings.cardPadding * 0.8),
          const Divider(height: 0),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacings.cardPadding,
                horizontal: AppSpacings.cardPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacings.cardPadding),
                    child: OkepointTexts.headingSmall(
                      emergency.title,
                      context,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: AppSpacings.cardPadding * 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OkepointTexts.subHeading("Contacts", context),
                    ],
                  ),
                  const SizedBox(height: AppSpacings.elementSpacing),
                  ListView.builder(
                    itemCount: contacts.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final contact = contacts[index];

                      return InkWell(
                        onTap: () async {
                          await showCupertinoModelBottomSheet<Contact?>(
                            context: context,
                            useRootNavigator: true,
                            enableDrag: false,
                            isDismissible: false,
                            builder: (context) => AddEditContactViewMobile(
                              contactId: contact.id,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacings.elementSpacing),
                          child: OkeListTile(
                            title: Row(
                              children: [
                                ContactAvatar(contact: contact),
                                const SizedBox(width: AppSpacings.elementSpacing),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      OkepointTexts.subHeading(contact.displayName, context),
                                      const SizedBox(height: AppSpacings.elementSpacing * 0.5),
                                      OkepointTexts.bodyText(contact.phone, context),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 13),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          CardPadding(
            child: OkepointPrimaryButton(
              color: Theme.of(context).cardColor,
              title: "Add New Contact",
              onPressed: () async {
                final contact = await showCupertinoModelBottomSheet<Contact?>(
                  context: context,
                  useRootNavigator: true,
                  enableDrag: false,
                  isDismissible: false,
                  builder: (context) => const AddEditContactViewMobile(),
                );

                if (contact != null) notifier.addContactToEmergency(contact);
              },
            ),
          ),
          SizedBox(height: AppSpacings.cardPadding * 2 + MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }
}
