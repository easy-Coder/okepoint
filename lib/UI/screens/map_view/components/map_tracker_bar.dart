import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/UI/components/avaters/profile_avater.dart';
import 'package:okepoint/UI/components/buttons/linked_text.dart';
import 'package:okepoint/UI/components/buttons/primary_button.dart';
import 'package:okepoint/UI/components/cards/paddings.dart';
import 'package:okepoint/UI/components/texts/texts.dart';
import 'package:okepoint/UI/theme/colors.dart';
import 'package:okepoint/UI/theme/spacings.dart';
import 'package:okepoint/utils/extentions/primary_extensions.dart';
import 'package:okepoint/utils/useful_methods.dart';

import '../../../../data/models/emergency.dart';
import '../../../../data/models/location/point.dart';
import '../../../../data/states/share_location_state.dart';
import '../../../components/cards/emergency_card.dart';
import '../../../components/cards/list_tile.dart';
import '../../../theme/theme.dart';
import '../../share_location/share_location_state.dart';
import '../map_view_state.dart';

class MapTrackerBar extends ConsumerWidget {
  const MapTrackerBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(appThemeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final state = ref.watch(mapViewStateProvider);
    final sharedLocation = state.sharedLocation!;

    final Emergency? emergency = ref.watch(getByTypeEmergencyProvider(sharedLocation.emergencyType));
    final List<LocationPoint> lastLocations = ref.watch(sharedLocationStatePointsProvider.call(state.trackingId));

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 380,
        color: Theme.of(context).colorScheme.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CardPadding(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppSpacings.cardPadding),
                          OkepointTexts.subHeading("Tracking", context),
                          const SizedBox(height: AppSpacings.elementSpacing * 0.4),
                          OkepointTexts.caption(sharedLocation.updatedAt.timeMilliseconds!.getLocationTimestamp.toUpperCase(), context),
                          const SizedBox(height: AppSpacings.cardPadding),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacings.cardPadding, vertical: AppSpacings.elementSpacing),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: OkeListTile(
                              title: Row(
                                children: [
                                  Stack(
                                    children: [
                                      ProfileAvatar(
                                        url: sharedLocation.profileImageUrl,
                                        radius: 28,
                                      ),
                                      const Positioned(
                                        top: 0,
                                        right: 0,
                                        child: CircleAvatar(
                                          backgroundColor: AppColors.green,
                                          radius: 8,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(width: AppSpacings.cardPadding),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      OkepointTexts.subHeading(sharedLocation.displayName, context),
                                      const SizedBox(height: AppSpacings.elementSpacing * 0.5),
                                      OkepointTexts.caption("Location sharing: On", context, fontWeight: FontWeight.w400),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                          const SizedBox(height: AppSpacings.elementSpacing),
                          if (emergency != null) EmergencyCard(emergency: emergency, selected: false, readOnly: true),
                          const SizedBox(height: AppSpacings.cardPadding),
                          OkeListTileReverse(
                            title: const Icon(
                              CupertinoIcons.placemark,
                              size: 18,
                            ),
                            trailing: ElementPadding(
                              child: OkepointTexts.bodyText((state.destinationLocation ?? sharedLocation.lastLocation).name, context),
                            ),
                          ),
                          const SizedBox(height: AppSpacings.cardPadding * 2),
                          OkepointPrimaryButton(
                            onPressed: () {},
                            title: "Get Direction",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacings.cardPadding * 2),
                    if (lastLocations.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CardPadding(
                            child: OkepointTexts.subHeading("Last known locations", context),
                          ),
                          const SizedBox(height: AppSpacings.elementSpacing),
                          Stepper(
                            physics: const NeverScrollableScrollPhysics(),
                            key: Key(generate16DigitIds('stepper')),
                            currentStep: state.stepperIndex,
                            controlsBuilder: (context, details) {
                              final location = lastLocations[details.stepIndex];
                              final latlng = location.location;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacings.elementSpacing),
                                child: CardPadding(
                                  child: Row(
                                    children: [
                                      const SizedBox(width: AppSpacings.cardPadding * 2),
                                      Icon(
                                        CupertinoIcons.placemark_fill,
                                        size: 16,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      const SizedBox(width: AppSpacings.elementSpacing * 0.5),
                                      LinkedText(
                                        link: latlng == state.destinationLocation?.location ? "See here(Current)" : "See here",
                                        onLinkTap: () => state.toNewLocation(location),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            margin: EdgeInsets.zero,
                            onStepCancel: () {},
                            onStepContinue: () {},
                            onStepTapped: (i) => state.updateStepperIndex = i,
                            steps: List.generate(lastLocations.length, (index) {
                              final location = lastLocations[index];

                              return Step(
                                state: StepState.complete,
                                isActive: isDark ? false : true,
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    OkepointTexts.bodyText(location.name, context),
                                    const SizedBox(height: AppSpacings.elementSpacing * 0.5),
                                    OkepointTexts.caption(location.createdAt.timeMilliseconds!.getShortLocationTimestamp.toUpperCase(), context),
                                  ],
                                ),
                                content: const SizedBox(),
                              );
                            }),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            CardPadding(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacings.cardPadding, vertical: AppSpacings.elementSpacing),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: OkeListTile(
                  title: OkepointTexts.bodyText("Dark Theme", context),
                  trailing: CupertinoSwitch(
                    value: isDark,
                    onChanged: (_) => appTheme.changeThemeFromName((isDark ? Brightness.light : Brightness.dark).name),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacings.cardPadding),
          ],
        ),
      ),
    );
  }
}
