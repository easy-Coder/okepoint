import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
            child: CardPadding(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: AppSpacings.cardPadding),
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
                    const SizedBox(height: AppSpacings.cardPadding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OkepointTexts.subHeading("Contacts", context),
                      ],
                    ),
                    const SizedBox(height: AppSpacings.elementSpacing),
                    GridView.builder(
                      itemCount: contacts.length + 1,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: AppSpacings.cardPadding * 1.5,
                        crossAxisSpacing: AppSpacings.elementSpacing,
                      ),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return InkWell(
                            onTap: () async {
                              final contact = await showCupertinoModelBottomSheet<Contact?>(
                                context: context,
                                useRootNavigator: true,
                                enableDrag: false,
                                isDismissible: false,
                                builder: (context) => const AddEditContactViewMobile(),
                              );

                              if (contact != null) notifier.addContactToEmergency(contact);
                            },
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).cardColor,
                              child: Icon(
                                Icons.add,
                                color: Theme.of(context).iconTheme.color,
                                size: 30,
                              ),
                            ),
                          );
                        }

                        final contact = contacts[index - 1];

                        return Stack(
                          clipBehavior: Clip.none,
                          fit: StackFit.expand,
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme.of(context).cardColor,
                            ),
                            Positioned(
                              left: 15,
                              right: 15,
                              bottom: -(AppSpacings.cardPadding),
                              child: Center(
                                child: OkepointTexts.callout(
                                  contact.displayName,
                                  context,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          CardPadding(
            child: OkepointPrimaryButton(
              title: "Start Sharing",
              state: ButtonState.initial,
              onPressed: () {},
            ),
          ),
          SizedBox(height: AppSpacings.cardPadding * 2 + MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }
}
