import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String url;
  final double radius;
  final void Function(File file)? onPickImage;
  const ProfileAvatar({super.key, required this.url, this.onPickImage, this.radius = 60});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: Theme.of(context).canvasColor,
          backgroundImage: NetworkImage(url),
        ),
        if (onPickImage != null)
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
