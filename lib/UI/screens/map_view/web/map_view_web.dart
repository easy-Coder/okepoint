import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:okepoint/UI/components/avaters/profile_avater.dart';
import 'package:okepoint/UI/components/buttons/linked_text.dart';
import 'package:okepoint/UI/components/buttons/primary_button.dart';
import 'package:okepoint/UI/components/cards/paddings.dart';
import 'package:okepoint/UI/components/texts/texts.dart';
import 'package:okepoint/UI/theme/colors.dart';
import 'package:okepoint/UI/theme/spacings.dart';

import '../../../../data/states/share_location_state.dart';
import '../../../components/cards/emergency_card.dart';
import '../../../components/cards/list_tile.dart';
import '../../../theme/theme.dart';
import '../../share_location/share_location_state.dart';
import '../components/info_window.dart';
import '../map_view_state.dart';

class MapView extends ConsumerStatefulWidget {
  final String? trackingId;

  const MapView({super.key, required this.trackingId});

  @override
  ConsumerState<MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectSharedLocationIdProvider.notifier).state = widget.trackingId;
      print("trackingId ${widget.trackingId}");
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapViewStateProvider);

    return ListenableBuilder(
        listenable: Listenable.merge([
          state.currentUserLocationPoint,
          state.mapMarkers,
        ]),
        builder: (context, _) {
          final currentLocation = state.currentUserLocationPoint.value;
          if (currentLocation == null) return const SizedBox.shrink();
          final markers = state.mapMarkers.value;

          return FutureBuilder(
              future: state.mapController.future,
              builder: (context, v) {
                return Stack(
                  children: [
                    Row(
                      children: [
                        const MapTrackerBar(),
                        const VerticalDivider(width: 0),
                        Expanded(
                          child: Stack(
                            children: [
                              GoogleMap(
                                myLocationButtonEnabled: false,
                                mapType: MapType.terrain,
                                initialCameraPosition: CameraPosition(
                                  target: currentLocation.location,
                                  zoom: 15,
                                ),
                                markers: markers,
                                onTap: (_) => state.infoWindowController.hideInfoWindow!(),
                                onMapCreated: (GoogleMapController controller) {
                                  state.mapController.complete(controller);
                                  state.infoWindowController.googleMapController = controller;
                                },
                              ),
                              CustomInfoWindow(
                                controller: state.infoWindowController,
                                height: MediaQuery.of(context).size.width * 0.12,
                                width: MediaQuery.of(context).size.width * 0.4,
                                offset: 50,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (!v.hasData)
                      Container(
                        color: AppColors.white,
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                );
              });
        });
  }
}

class MapTrackerBar extends ConsumerWidget {
  const MapTrackerBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(appThemeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final state = ref.watch(mapViewStateProvider);
    final locations = ref.watch(sharedLocationStatePointsProvider.call("sl_fspUtcGkhanTqjio"));

    print("LAST LOCATION $locations  ID:${state.sharedLocation?.id}");

    final emergency = ref.watch(getByTypeEmergencyProvider("medical-attention"));
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
                          OkepointTexts.caption("11:50AM - Jan. 12, 2023", context),
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
                                  const Stack(
                                    children: [
                                      ProfileAvatar(
                                        url: "https://cdn.idolnetworth.com/images/34/madeintyo.jpg",
                                        radius: 28,
                                      ),
                                      Positioned(
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
                                      OkepointTexts.subHeading("Paul Jeremiah", context),
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
                              child: OkepointTexts.bodyText("14 Beaitiful Gate Close, Port Harcourt, Nigeria", context),
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
                    if (locations.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CardPadding(
                            child: OkepointTexts.subHeading("Last known locations", context),
                          ),
                          const SizedBox(height: AppSpacings.elementSpacing),
                          Stepper(
                            physics: const NeverScrollableScrollPhysics(),
                            currentStep: 0,
                            controlsBuilder: (context, details) {
                              return CardPadding(
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
                                      link: "See here",
                                      onLinkTap: () {},
                                    ),
                                  ],
                                ),
                              );
                            },
                            margin: EdgeInsets.zero,
                            onStepCancel: () {},
                            onStepContinue: () {},
                            onStepTapped: (v) {},
                            steps: List.generate(locations.length, (index) {
                              return Step(
                                state: StepState.complete,
                                isActive: isDark ? false : true,
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    OkepointTexts.bodyText("Port Harcourt, Nigeria", context),
                                    const SizedBox(height: AppSpacings.elementSpacing),
                                    OkepointTexts.caption("11:50AM - Jan. 12", context),
                                  ],
                                ),
                                label: OkepointTexts.bodyText("Port Harcourt, Nigeria", context),
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
