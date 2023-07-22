import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:okepoint/constants/icon_path.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../components/texts/texts.dart';
import '../../../theme/colors.dart';
import '../../../theme/spacings.dart';

class AuthenticationView extends StatelessWidget {
  const AuthenticationView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            color: Theme.of(context).colorScheme.background.withOpacity(.65),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(AppSpacings.cardPadding),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).cardColor.withOpacity(.8),
                  spreadRadius: 3,
                  blurRadius: 8,
                  offset: const Offset(0, -10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OkepointTexts.headingMedium("New User?", context),
                const SizedBox(height: AppSpacings.elementSpacing * 0.25),
                OkepointTexts.bodyText("Signin to Continue using Okepoint", context),
                const SizedBox(height: AppSpacings.cardPadding),
                OkepointPrimaryButton(
                  onPressed: () {},
                  title: "Signin with Apple",
                  color: AppColors.white,
                  textColor: AppColors.black,
                  icon: Padding(
                    padding: const EdgeInsets.all(AppSpacings.elementSpacing),
                    child: Image.asset(IconPaths.apple),
                  ),
                ),
                const SizedBox(height: AppSpacings.elementSpacing),
                OkepointPrimaryButton(
                  onPressed: () {},
                  title: "Signin with Google",
                  color: AppColors.blue,
                  icon: Padding(
                    padding: const EdgeInsets.all(AppSpacings.elementSpacing),
                    child: Image.asset(IconPaths.google),
                  ),
                ),
                const SizedBox(height: AppSpacings.cardPadding),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
