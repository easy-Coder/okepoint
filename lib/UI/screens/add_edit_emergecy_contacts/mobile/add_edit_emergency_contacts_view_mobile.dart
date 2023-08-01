import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:okepoint/UI/components/cards/paddings.dart';
import 'package:okepoint/UI/components/texts/texts.dart';
import 'package:okepoint/UI/screens/add_edit_contact/mobile/add_edit_contact_view_mobile.dart';
import 'package:okepoint/UI/theme/spacings.dart';
import 'package:okepoint/data/models/emergency.dart';

import '../../../components/buttons/linked_text.dart';
import '../../../components/buttons/primary_button.dart';
import '../../../components/models/cupertino_model.dart';

class AddEditEmergencyContactsViewMobile extends ConsumerWidget {
  final Emergency emergency;
  const AddEditEmergencyContactsViewMobile({
    super.key,
    required this.emergency,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: AppSpacings.cardPadding),
          CardPadding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OkepointTexts.subHeading(
                  "Emergency contacts",
                  context,
                ),
                LinkedText(
                  link: "Close",
                  textColor: Theme.of(context).colorScheme.error,
                  onLinkTap: () => context.pop(),
                )
              ],
            ),
          ),
          const SizedBox(height: AppSpacings.cardPadding),
          const Divider(height: 0),
          Expanded(
            child: CardPadding(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacings.cardPadding),
                    OkepointTexts.headingSmall(
                      emergency.title,
                      context,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: AppSpacings.cardPadding * 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OkepointTexts.subHeading("Contacts", context),
                      ],
                    ),
                    const SizedBox(height: AppSpacings.elementSpacing),
                    GridView.builder(
                      itemCount: 2,
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
                            onTap: () {
                              showCupertinoModelBottomSheet(
                                context: context,
                                useRootNavigator: true,
                                enableDrag: false,
                                isDismissible: false,
                                builder: (context) => const AddEditContactViewMobile(),
                              );
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
                                  "Jeremiah",
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
