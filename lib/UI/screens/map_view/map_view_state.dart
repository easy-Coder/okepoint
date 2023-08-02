import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okepoint/data/models/location/point.dart';
import 'package:okepoint/data/models/location/shared_location.dart';
import 'package:okepoint/data/states/share_location_state.dart';

import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../data/services/map_service.dart';
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

  ValueNotifier<LocationPoint?> get currentUserLocationPoint => _mapService.currentUserLocationPointNotifier;
  LocationPoint? get destinationLocation => sharedLocation?.lastLocation;

  ValueNotifier<Set<Marker>> get mapMarkers => _mapService.mapMarkers;

  MapService get _mapService => ref.read(mapServiceProvider);

  MapViewState(this.ref) {
    infoWindowController = CustomInfoWindowController();
    mapController = Completer<GoogleMapController>();

    final id = ref.read(selectSharedLocationIdProvider);
    if (id == null) return;
    final location = ref.watch(sharedLocationStateProvider.call(id));
    sharedLocation = location;
  }
}
