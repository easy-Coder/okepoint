import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/UI/components/buttons/outline_button.dart';
import 'package:okepoint/UI/components/cards/paddings.dart';
import 'package:okepoint/UI/components/texts/texts.dart';
import 'package:okepoint/UI/theme/spacings.dart';
import 'package:okepoint/UI/theme/theme.dart';
import 'package:okepoint/data/states/user_state.dart';

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
                const CircleAvatar(
                  radius: 60,
                ),
                const SizedBox(height: AppSpacings.elementSpacing),
                OkepointTexts.headingMedium(user.displayName, context),
                const SizedBox(height: AppSpacings.cardPadding * 2),
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
                        OkepointTexts.subHeading("My Location", context, fontWeight: FontWeight.w600),
                        const SizedBox(height: AppSpacings.elementSpacing),
                        const Divider(height: AppSpacings.cardPadding),
                        OkeListTile(
                          title: OkepointTexts.bodyText("Location", context),
                          trailing: Row(
                            children: [
                              OkepointTexts.bodyText(
                                "Obia/Akpo, Rivers",
                                context,
                                color: Theme.of(context).unselectedWidgetColor,
                              ),
                              const SizedBox(width: AppSpacings.elementSpacing),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Theme.of(context).unselectedWidgetColor,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: AppSpacings.cardPadding),
                        OkeListTile(
                          title: OkepointTexts.bodyText("From", context),
                          trailing: Row(
                            children: [
                              OkepointTexts.bodyText(
                                "This iPhone",
                                context,
                                color: Theme.of(context).unselectedWidgetColor,
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: AppSpacings.cardPadding),
                        OkeListTile(
                          title: OkepointTexts.bodyText("Share My Location", context),
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
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: AppSpacings.cardPadding),
                Center(
                  child: OkepointTexts.subHeading(
                    "v1.0.0",
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

class OkeListTile extends StatelessWidget {
  final Widget title;
  final Widget trailing;

  const OkeListTile({
    super.key,
    required this.title,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: title),
        trailing,
      ],
    );
  }
}
