import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:okepoint/UI/components/avaters/profile_avater.dart';
import 'package:okepoint/utils/extentions/primary_extensions.dart';

import '../../../data/models/emergency.dart';
import '../../../data/models/user/contact.dart';
import '../../screens/add_edit_emergecy_contacts/mobile/add_edit_emergency_contacts_view_mobile.dart';
import '../../theme/colors.dart';
import '../../theme/spacings.dart';
import '../models/cupertino_model.dart';
import '../texts/texts.dart';

class EmergencyCard extends StatelessWidget {
  final Emergency emergency;
  final List<Contact> contacts;
  final bool selected;
  final bool readOnly;

  const EmergencyCard({
    super.key,
    required this.emergency,
    required this.selected,
    this.readOnly = false,
    this.contacts = const [],
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(15);

    return Container(
      padding: const EdgeInsets.all(AppSpacings.cardPadding),
      decoration: BoxDecoration(
        color: selected ? AppColors.red : Theme.of(context).cardColor,
        borderRadius: borderRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OkepointTexts.headingSmall(
                  emergency.title,
                  context,
                  color: selected ? AppColors.white : null,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: AppSpacings.elementSpacing * 0.5),
                OkepointTexts.bodyText(
                  emergency.subtitle,
                  context,
                  color: selected ? AppColors.white : null,
                  fontWeight: FontWeight.w300,
                  maxLines: 2,
                ),
                if (contacts.isNotEmpty) ...[
                  const SizedBox(height: AppSpacings.elementSpacing * 0.5),
                  PeopleAvatar(
                    urls: contacts.map((e) => e.profileImageUrl).toList(),
                    size: 24,
                  ),
                ],
              ],
            ),
          ),
          if (selected && !readOnly)
            InkWell(
              onTap: () => showCupertinoModelBottomSheet(
                context: context,
                useRootNavigator: true,
                barrierColor: Theme.of(context).cardColor.withOpacity(.8),
                builder: (context) => const AddEditEmergencyContactsViewMobile(),
              ),
              child: Icon(
                CupertinoIcons.add_circled_solid,
                color: (selected ? AppColors.white : Theme.of(context).unselectedWidgetColor).lighten(0.2),
                size: 30,
              ),
            ),
        ],
      ),
    );
  }
}

class PeopleAvatar extends StatelessWidget {
  final double size;
  final List<String> urls;
  final Color? backgroundColor;
  const PeopleAvatar({
    Key? key,
    required this.size,
    required this.urls,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) return const SizedBox.shrink();
    final int length = urls.length.clamp(0, 5);
    return SizedBox(
      width: length * 30,
      height: size,
      child: Stack(
          clipBehavior: Clip.none,
          children: List.generate(
            length,
            (index) => Positioned(
              left: index * size,
              child: CircleAvatar(
                radius: size * 0.55,
                backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.background,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ProfileAvatar(
                      url: urls[index],
                      radius: size,
                    ),
                    if (index == (length - 1) && length >= 5) ...[
                      Container(
                        width: index * size,
                        height: index * size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.black.withOpacity(.5),
                        ),
                        child: Center(
                          child: OkepointTexts.caption(
                            '+${urls.length - length}',
                            context,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
