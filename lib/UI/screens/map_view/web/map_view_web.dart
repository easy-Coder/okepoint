import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
          );
        });
  }
}
