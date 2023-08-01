import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:okepoint/data/models/user/contact.dart';
import 'package:okepoint/data/models/user/user.dart';

class ProfileAvatar extends StatelessWidget {
  final User user;
  final void Function(File file)? onPickImage;
  const ProfileAvatar({super.key, required this.user, this.onPickImage});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Theme.of(context).canvasColor,
          backgroundImage: NetworkImage(user.profileImageUrl),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: CircleAvatar(
            backgroundColor: Theme.of(context).cardColor,
            radius: 16,
            child: Icon(
              CupertinoIcons.photo_camera,
              size: 18,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        )
      ],
    );
  }
}

class ContactAvatar extends StatelessWidget {
  final Contact contact;
  const ContactAvatar({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Theme.of(context).canvasColor,
      backgroundImage: NetworkImage(contact.profileImageUrl),
    );
  }
}
