import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:okepoint/data/services/map_service.dart';

import 'components/info_window.dart';

class MapView extends ConsumerStatefulWidget {
  const MapView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
  late Completer<GoogleMapController> mapController;
  late CustomInfoWindowController infoWindowController;

  @override
  void initState() {
    super.initState();

    infoWindowController = CustomInfoWindowController();
    mapController = Completer<GoogleMapController>();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapServiceProvider);
    return ListenableBuilder(
        listenable: Listenable.merge([
          state.currentUserLocationPointNotifier,
          state.destinationLocationPointNotifier,
          state.mapMarkers,
        ]),
        builder: (context, _) {
          final currentLocation = state.currentUserLocationPointNotifier.value;
          if (currentLocation == null) return const SizedBox.shrink();
          final markers = state.mapMarkers.value;

          return Stack(
            children: [
              GoogleMap(
                myLocationButtonEnabled: false,
                mapType: MapType.terrain,
                initialCameraPosition: CameraPosition(
                  target: currentLocation.location,
                  zoom: 15,
                ),
                markers: markers,
                onTap: (_) => infoWindowController.hideInfoWindow!(),
                onMapCreated: (GoogleMapController controller) {
                  mapController.complete(controller);

                  infoWindowController.googleMapController = controller;
                },
              ),
              CustomInfoWindow(
                controller: infoWindowController,
                height: MediaQuery.of(context).size.width * 0.12,
                width: MediaQuery.of(context).size.width * 0.4,
                offset: 50,
              ),
            ],
          );
        });
  }
}
