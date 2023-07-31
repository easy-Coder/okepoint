import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/UI/components/buttons/linked_text.dart';
import 'package:okepoint/UI/components/buttons/outline_button.dart';
import 'package:okepoint/UI/components/cards/paddings.dart';
import 'package:okepoint/UI/components/texts/texts.dart';
import 'package:okepoint/UI/theme/spacings.dart';
import 'package:okepoint/UI/theme/theme.dart';
import 'package:okepoint/data/states/user_state.dart';

import '../../../components/avaters/profile_avater.dart';
import '../../../components/cards/list_tile.dart';
import '../components/user_location.dart';

class UserProfileWiget extends ConsumerWidget {
  const UserProfileWiget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateProvider);
    final appTheme = ref.watch(appThemeProvider);

    return Scaffold(
      body: SafeArea(
        child: Builder(builder: (context) {
          if (user == null) return const SizedBox();
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: AppSpacings.elementSpacing),
                CardPadding(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          LinkedText(link: "Edit", onLinkTap: () {}),
                        ],
                      ),
                      const SizedBox(height: AppSpacings.elementSpacing),
                      ProfileAvatar(
                        user: user,
                        onPickImage: (File file) {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacings.elementSpacing),
                if (user.displayName.trim().isNotEmpty) OkepointTexts.headingMedium(user.displayName, context),
                const SizedBox(height: AppSpacings.cardPadding * 2),
                const UserLocation(),
                const SizedBox(height: AppSpacings.cardPadding),
                CardPadding(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacings.cardPadding),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OkepointTexts.subHeading("Notifications", context, fontWeight: FontWeight.w600),
                        const SizedBox(height: AppSpacings.elementSpacing),
                        const Divider(height: AppSpacings.cardPadding),
                        OkeListTile(
                          title: OkepointTexts.bodyText("Enable Push Notification", context),
                          trailing: CupertinoSwitch(value: true, onChanged: (_) {}),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacings.cardPadding),
                CardPadding(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacings.cardPadding),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OkepointTexts.subHeading("Theme", context, fontWeight: FontWeight.w600),
                        const SizedBox(height: AppSpacings.elementSpacing),
                        const Divider(height: AppSpacings.cardPadding),
                        OkeListTile(
                          title: OkepointTexts.bodyText("Dark Theme", context),
                          trailing: CupertinoSwitch(
                            value: isDark,
                            onChanged: (_) => appTheme.changeThemeFromName((isDark ? Brightness.light : Brightness.dark).name),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacings.cardPadding),
                CardPadding(
                  child: OkepointOutlineButton(
                    title: "Log Out",
                    color: Colors.red,
                    onPressed: ref.watch(userStateProvider.notifier).logout,
                  ),
                ),
                const SizedBox(height: AppSpacings.cardPadding),
                Center(
                  child: OkepointTexts.subHeading(
                    "v0.0.1",
                    context,
                    color: Theme.of(context).unselectedWidgetColor,
                  ),
                ),
                const SizedBox(height: AppSpacings.cardPadding * 2),
              ],
            ),
          );
        }),
      ),
    );
  }
}
