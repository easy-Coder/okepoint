// ignore_for_file: public_member_api_docs, sort_constructors_first, constant_identifier_names
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart' hide LocationAccuracy;

import '../../constants/icon_path.dart';
import '../../constants/keys.dart';
import '../../utils/useful_methods.dart';
import '../models/location/point.dart';
import 'package:geolocator/geolocator.dart';

final mapServiceProvider = Provider<MapService>((ref) {
  return MapService(ref);
});

class MapService {
  final Ref ref;

  final String baseGoogleMapsUrl = "https://maps.googleapis.com/maps/api";

  Location location = Location();

  ValueNotifier<bool> enabledLocationSharing = ValueNotifier<bool>(false);

  ValueNotifier<LocationPoint?> currentUserLocationPointNotifier = ValueNotifier<LocationPoint?>(null);
  ValueNotifier<Set<Marker>> mapMarkers = ValueNotifier<Set<Marker>>({});

  StreamSubscription? _positionSubscription;

  BitmapDescriptor? userIconPin;

  LatLng? lastLatLng;

  MapService(this.ref);

  void enableBackgroundLocation(bool enable) {
    if (!enabledLocationSharing.value) return;
    location.enableBackgroundMode(enable: enable);
  }

  Future<void> shareLocationRealtime(Function(LocationPoint) onLocationChanged) async {
    try {
      final enable = await requestPermission();

      if (!enable) return;

      cancelRealtimeLocationShare();
      _positionSubscription = location.onLocationChanged.listen((position) {
        if (position.latitude == null || position.longitude == null) return;

        enabledLocationSharing.value = true;
        debugPrint("LOCATION STREAM STARTED");

        final latLng = LatLng(position.latitude!, position.longitude!);
        final location = LocationPoint(
          id: "current-user-location",
          name: '',
          geohash: '',
          descriptor: userIconPin!,
          location: latLng,
          createdAt: timeStampNow.millisecondsSinceEpoch,
        );

        if (lastLatLng != null) {
          final meter = Geolocator.distanceBetween(
            latLng.latitude,
            latLng.longitude,
            lastLatLng!.latitude,
            lastLatLng!.longitude,
          );

          if (meter > 100) {
            currentUserLocationPointNotifier.value = location;
            onLocationChanged(location);

            lastLatLng = latLng;
            debugPrint("100M changed ocurred $latLng");
          }
        }
      });
    } catch (_) {}
  }

  void cancelRealtimeLocationShare() {
    _positionSubscription?.cancel();
    _positionSubscription = null;

    enabledLocationSharing.value = false;
  }

  Future<LocationPoint?> getUserCurrentPosition() async {
    try {
      userIconPin = await getIconFromAssetString(IconPaths.pin);

      final isGranted = await requestPermission();

      if (!isGranted) return null;
      final data = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      final latLng = LatLng(data.latitude, data.longitude);

      final location = LocationPoint(
        id: "current-user-location",
        name: '',
        geohash: '',
        location: latLng,
        descriptor: userIconPin!,
        createdAt: (data.timestamp ?? DateTime.now()).millisecondsSinceEpoch,
      );

      final newLocation = await getLocationFromLatLng(location);
      currentUserLocationPointNotifier.value = newLocation;
      lastLatLng = latLng;

      addMarker(newLocation);
    } catch (_) {}

    return currentUserLocationPointNotifier.value;
  }

  Future<bool> requestPermission() async {
    final permission = await location.requestPermission();
    return [PermissionStatus.granted, PermissionStatus.grantedLimited].contains(permission);
  }

  void addMarker(LocationPoint point) {
    final newMarker = Marker(
      markerId: MarkerId(point.id),
      icon: point.descriptor,
      position: point.location,
      onTap: () {},
    );

    mapMarkers.value.removeWhere((marker) => marker.markerId.value == point.id);
    mapMarkers.value = {newMarker, ...mapMarkers.value};
  }

  void onTapMarker() {}

  Future<LocationPoint> getLocationFromLatLng(LocationPoint point) async {
    try {
      String url = "$baseGoogleMapsUrl/geocode/json?latlng=${point.location.latitude},${point.location.longitude}&key=$GOOGLE_MAP_API_KEY&result_type=street_address&limit=1";
      final response = await get(Uri.parse(url));
      if (response.statusCode == 200) {
        final body = Map<String, dynamic>.from(jsonDecode(response.body));
        final results = List.from(body["results"]);
        if (results.isNotEmpty) return point.copyWith(name: results.first["formatted_address"] as String?);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return point;
  }
}
