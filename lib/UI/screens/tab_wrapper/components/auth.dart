import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/constants/icon_path.dart';
import 'package:okepoint/data/states/auth_state.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../components/texts/texts.dart';
import '../../../theme/colors.dart';
import '../../../theme/spacings.dart';

class AuthenticationView extends ConsumerWidget {
  const AuthenticationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final state = ref.watch(authStateProvider);

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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Theme.of(context).iconTheme.color,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacings.elementSpacing),
              Container(
                padding: const EdgeInsets.all(AppSpacings.cardPadding),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).cardColor.withOpacity(.4),
                      spreadRadius: 3,
                      blurRadius: 8,
                      offset: const Offset(0, -10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OkepointTexts.headingMedium("SignIn", context),
                    const SizedBox(height: AppSpacings.elementSpacing * 0.25),
                    OkepointTexts.bodyText("Signin to Continue using Okepoint", context),
                    const SizedBox(height: AppSpacings.cardPadding),
                    OkepointPrimaryButton(
                      onPressed: () => state.signInWithApple(),
                      title: "Signin with Apple",
                      color: isLight ? AppColors.black : AppColors.white,
                      textColor: !isLight ? AppColors.black : AppColors.white,
                      state: state.isAppleSiginIn ? ButtonState.loading : ButtonState.initial,
                      icon: Padding(
                        padding: const EdgeInsets.all(AppSpacings.elementSpacing),
                        child: Image.asset(
                          IconPaths.apple,
                          color: !isLight ? AppColors.black : AppColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacings.elementSpacing),
                    OkepointPrimaryButton(
                      onPressed: () => state.signInWithGoogle(),
                      title: "Signin with Google",
                      color: AppColors.blue,
                      state: state.isGoogleSiginIn ? ButtonState.loading : ButtonState.initial,
                      icon: Padding(
                        padding: const EdgeInsets.all(AppSpacings.elementSpacing),
                        child: Image.asset(IconPaths.google),
                      ),
                    ),
                    const SizedBox(height: AppSpacings.cardPadding),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
