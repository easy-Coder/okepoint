import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/data/models/location/point.dart';
import 'package:okepoint/data/models/location/shared_location.dart';
import 'package:okepoint/data/states/share_location_state.dart';

import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../constants/icon_path.dart';
import '../../../data/services/map_service.dart';
import '../../../utils/useful_methods.dart';
import 'components/info_window.dart';

final selectSharedLocationIdProvider = StateProvider.autoDispose<String?>((ref) {
  return null;
});

final mapViewStateProvider = ChangeNotifierProvider.autoDispose<MapViewState>((ref) {
  return MapViewState(ref);
});

class MapViewState extends ChangeNotifier {
  final Ref ref;
  SharedLocation? sharedLocation;

  late Completer<GoogleMapController> mapController;
  late CustomInfoWindowController infoWindowController;

  BitmapDescriptor? userDestinationIconPin;

  String? mapStyle;

  ValueNotifier<LocationPoint?> get currentUserLocationPoint => _mapService.currentUserLocationPointNotifier;
  LocationPoint? get destinationLocation => sharedLocation?.lastLocation;

  ValueNotifier<Set<Marker>> get mapMarkers => _mapService.mapMarkers;

  MapService get _mapService => ref.read(mapServiceProvider);

  MapViewState(this.ref) {
    infoWindowController = CustomInfoWindowController();
    mapController = Completer<GoogleMapController>();

    _mapService.getUserCurrentPosition();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startLocationTracking();
    });
  }

  void _startLocationTracking() async {
    final id = ref.read(selectSharedLocationIdProvider);

    final controller = await mapController.future;

    rootBundle.loadString('assets/txt/map_style_light.txt').then((value) {
      mapStyle = value;
      controller.setMapStyle(mapStyle);
    });

    if (id == null) return;

    ref.listen(sharedLocationStateProvider.call(id), (oldLocation, newLocation) async {
      print("newLocation $newLocation");

      if (newLocation != null) {
        userDestinationIconPin ??= await getIconFromAssetString(IconPaths.point);
        _mapService.addMarker(newLocation.lastLocation.copyWith(
          descriptor: userDestinationIconPin,
        ));

        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: newLocation.lastLocation.location,
          zoom: 15,
        )));
      }
    });
  }
}
