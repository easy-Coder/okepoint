import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/data/models/location/point.dart';
import 'package:okepoint/data/models/location/shared_location.dart';
import 'package:okepoint/data/states/share_location_state.dart';

import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../constants/icon_path.dart';
import '../../../constants/text_path.dart';
import '../../../data/services/map_service.dart';
import '../../../utils/useful_methods.dart';
import 'components/info_window.dart';

final selectSharedLocationIdProvider = StateProvider<String?>((ref) {
  return null;
});

final mapViewStateProvider = ChangeNotifierProvider.autoDispose<MapViewState>((ref) {
  return MapViewState(ref);
});

class MapViewState extends ChangeNotifier {
  final Ref ref;
  SharedLocation? sharedLocation;
  bool listenLastLocationPoint = true;

  late Completer<GoogleMapController> mapController;
  late CustomInfoWindowController infoWindowController;

  BitmapDescriptor? userDestinationIconPin;

  int stepperIndex = 0;

  late GoogleMapController controller;

  ValueNotifier<LocationPoint?> get currentUserLocationPoint => _mapService.currentUserLocationPointNotifier;
  LocationPoint? destinationLocation;

  ValueNotifier<Set<Marker>> get mapMarkers => _mapService.mapMarkers;
  ValueNotifier<Set<Polyline>> get mapPolylines => _mapService.mapPolylines;

  String? get trackingId => ref.read(selectSharedLocationIdProvider);
  MapService get _mapService => ref.read(mapServiceProvider);

  set updateStepperIndex(int v) {
    stepperIndex = v;
    notifyListeners();
  }

  MapViewState(this.ref) {
    infoWindowController = CustomInfoWindowController();
    mapController = Completer<GoogleMapController>();

    _mapService.getUserCurrentPosition();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller = await mapController.future;
      final style = await rootBundle.loadString(TxtPath.mapStyle);

      controller.setMapStyle(style);

      _startLocationTracking();
    });
  }

  Future<void> goToLocationPoint(LocationPoint point) async {
    final newLocation = point.copyWith(
      id: "destination-location",
      descriptor: userDestinationIconPin,
    );

    destinationLocation = newLocation;
    notifyListeners();

    _mapService.addMarker(destinationLocation!);

    await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: destinationLocation!.location,
      zoom: 15,
    )));
  }

  void _startLocationTracking() async {
    if (trackingId == null) return;

    ref.listen(sharedLocationStateProvider.call(trackingId!), (oldLocation, newLocation) {
      sharedLocation = newLocation ?? oldLocation;

      notifyListeners();

      if (newLocation != null && listenLastLocationPoint) {
        getIconFromAssetString(IconPaths.point).then((value) {
          userDestinationIconPin ??= value;

          goToLocationPoint(newLocation.lastLocation);
        });
      }
    });
  }

  void toNewLocation(LocationPoint lastLocation) {
    listenLastLocationPoint = false;

    if (lastLocation.location == sharedLocation?.lastLocation.location) {
      listenLastLocationPoint = true;
    }

    goToLocationPoint(lastLocation);
  }
}
