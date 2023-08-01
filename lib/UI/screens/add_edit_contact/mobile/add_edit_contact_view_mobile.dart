import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:okepoint/UI/components/buttons/linked_text.dart';

import '../../../components/cards/paddings.dart';
import '../../../components/texts/texts.dart';
import '../../../theme/spacings.dart';

class AddEditContactViewMobile extends ConsumerWidget {
  final String? contactId;

  const AddEditContactViewMobile({
    super.key,
    this.contactId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: AppSpacings.elementSpacing),
          CardPadding(
            child: Row(
              children: [
                const CloseButton(),
                const SizedBox(width: AppSpacings.elementSpacing),
                OkepointTexts.subHeading(
                  "Add contact",
                  context,
                ),
                const Spacer(),
                LinkedText(
                  link: "Save",
                  onLinkTap: () => context.pop(),
                )
              ],
            ),
          ),
          const Divider(height: AppSpacings.elementSpacing),
          Expanded(
            child: CardPadding(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: AppSpacings.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        label: OkepointTexts.bodyText("Name*", context),
                        hintText: "Enter contact name.",
                      ),
                    ),
                    const SizedBox(height: AppSpacings.cardPadding),
                    TextField(
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        label: OkepointTexts.bodyText("Phone*", context),
                        hintText: "Enter contact phone number.",
                      ),
                    ),
                    const SizedBox(height: AppSpacings.cardPadding),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        label: OkepointTexts.bodyText("Email", context),
                        hintText: "Enter contact email",
                      ),
                    ),
                    const SizedBox(height: AppSpacings.cardPadding),
                    Container(
                      padding: const EdgeInsets.only(
                        left: AppSpacings.cardPadding * 0.6,
                        right: AppSpacings.cardPadding,
                        top: AppSpacings.elementSpacing * 0.4,
                        bottom: AppSpacings.elementSpacing * 0.4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          width: Theme.of(context).inputDecorationTheme.enabledBorder!.borderSide.width,
                          color: Theme.of(context).inputDecorationTheme.enabledBorder!.borderSide.color,
                        ),
                      ),
                      child: DropdownButton<String>(
                        value: null,
                        alignment: const AlignmentDirectional(0, 0),
                        icon: const SizedBox.shrink(),
                        borderRadius: BorderRadius.circular(15),
                        dropdownColor: Theme.of(context).cardColor,
                        isExpanded: true,
                        hint: OkepointTexts.bodyText("Select contact type", context),
                        underline: const SizedBox.shrink(),
                        items: ["Family", "Friend", "Professional"]
                            .map((e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      OkepointTexts.bodyText(e, context),
                                    ],
                                  ),
                                ))
                            .toList(),
                        onChanged: (v) {},
                      ),
                    ),
                    const SizedBox(height: AppSpacings.cardPadding * 2),
                    TextField(
                      minLines: 2,
                      maxLines: 6,
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        label: OkepointTexts.bodyText("Note", context),
                        hintText: "Enter Note",
                      ),
                    ),
                    SizedBox(height: AppSpacings.cardPadding * 2 + MediaQuery.paddingOf(context).bottom),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
