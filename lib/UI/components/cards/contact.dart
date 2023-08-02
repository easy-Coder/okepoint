import 'package:flutter/material.dart';
import 'package:okepoint/UI/theme/spacings.dart';

import '../../../data/models/user/contact.dart';
import '../avaters/profile_avater.dart';
import '../texts/texts.dart';
import 'list_tile.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.contact,
  });

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return OkeListTile(
      title: Row(
        children: [
          ProfileAvatar(
            url: contact.profileImageUrl,
            radius: 30,
          ),
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
    );
  }
}
