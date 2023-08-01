import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:okepoint/UI/components/buttons/linked_text.dart';
import 'package:okepoint/UI/screens/add_edit_contact/add_edit_contact_state.dart';
import 'package:okepoint/data/models/user/contact.dart';
import 'package:okepoint/utils/validations.dart';

import '../../../components/cards/paddings.dart';
import '../../../components/texts/texts.dart';
import '../../../theme/spacings.dart';

class AddEditContactViewMobile extends ConsumerWidget {
  const AddEditContactViewMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactId = ref.watch(selectContactProvider);
    final state = ref.watch(addEditContactStateProvider.call(contactId));

    return Scaffold(
      body: Form(
        key: state.formKey,
        child: Column(
          children: [
            const SizedBox(height: AppSpacings.elementSpacing * 0.5),
            CardPadding(
              child: Row(
                children: [
                  const CloseButton(),
                  const SizedBox(width: AppSpacings.elementSpacing),
                  OkepointTexts.headingSmall(
                    "Add contact",
                    context,
                  ),
                  const Spacer(),
                  LinkedText(
                    link: "Save",
                    onLinkTap: () => state.saveContact((contact) {
                      if (contact != null) context.pop<Contact?>(contact);
                    }),
                  )
                ],
              ),
            ),
            const Divider(height: AppSpacings.elementSpacing * 0.5),
            Expanded(
              child: CardPadding(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacings.cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        controller: state.nameController,
                        validator: (value) => AppValidations.isName(value) ? null : "Invalid name",
                        decoration: InputDecoration(
                          label: OkepointTexts.bodyText("Name*", context),
                          hintText: "Enter contact name.",
                          prefixIcon: const Icon(CupertinoIcons.person),
                        ),
                      ),
                      const SizedBox(height: AppSpacings.cardPadding),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        controller: state.phoneController,
                        validator: (value) => AppValidations.isPhone(value) ? null : "Invalid phone",
                        decoration: InputDecoration(
                          label: OkepointTexts.bodyText("Phone*", context),
                          hintText: "Enter contact phone number.",
                          prefixIcon: const Icon(CupertinoIcons.phone),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.photo_camera_front_outlined),
                            color: Theme.of(context).primaryColor,
                            onPressed: () {},
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacings.cardPadding),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        controller: state.emailController,
                        validator: (value) => AppValidations.isEmail(value) ? null : "Invalid email",
                        decoration: InputDecoration(
                          label: OkepointTexts.bodyText("Email", context),
                          hintText: "Enter contact email",
                          prefixIcon: const Icon(CupertinoIcons.mail),
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
                          value: state.contactTypeController.text.isEmpty ? null : state.contactTypeController.text,
                          borderRadius: BorderRadius.circular(15),
                          dropdownColor: Theme.of(context).cardColor,
                          isExpanded: true,
                          hint: OkepointTexts.bodyText("Select contact type", context),
                          underline: const SizedBox.shrink(),
                          items: ["Family", "Friend", "Professional"]
                              .map((e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: OkepointTexts.bodyText(e, context),
                                  ))
                              .toList(),
                          onChanged: (v) {},
                        ),
                      ),
                      const SizedBox(height: AppSpacings.cardPadding * 2),
                      TextField(
                        minLines: 2,
                        maxLines: 6,
                        controller: state.noteController,
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          label: OkepointTexts.bodyText("Note", context),
                          hintText: "Enter Note",
                          prefixIcon: const Icon(CupertinoIcons.doc),
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
      ),
    );
  }
}
