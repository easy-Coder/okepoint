// ignore_for_file: public_member_api_docs, sort_constructors_first, constant_identifier_names
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart' hide LocationAccuracy;
import 'package:okepoint/UI/theme/colors.dart';

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

  final Location location = Location();
  final PolylinePoints polylinePoints = PolylinePoints();

  ValueNotifier<bool> enabledLocationSharing = ValueNotifier<bool>(false);

  ValueNotifier<LocationPoint?> currentUserLocationPointNotifier = ValueNotifier<LocationPoint?>(null);
  ValueNotifier<Set<Marker>> mapMarkers = ValueNotifier<Set<Marker>>({});
  ValueNotifier<Set<Polyline>> mapPolylines = ValueNotifier<Set<Polyline>>({});

  StreamSubscription? _positionSubscription;

  BitmapDescriptor? userIconPin;

  LatLng? lastLatLng;

  MapService(this.ref);

  bool latLngMeters(LatLng latLng, {LatLng? lastLL, int meterThreshold = 100}) {
    final meter = Geolocator.distanceBetween(
      latLng.latitude,
      latLng.longitude,
      (lastLL ?? lastLatLng)!.latitude,
      (lastLL ?? lastLatLng)!.longitude,
    );

    return meter > meterThreshold;
  }

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
          if (latLngMeters(latLng)) {
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

      final newLocation = await getLocationFromLatLngAPI(location);
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

  void addPolyline(LocationPoint point) async {
    final startPoint = currentUserLocationPointNotifier.value!.location;
    final polylines = await getRoutePolyPoints(startPoint, point.location);

    final newPolyline = Polyline(
      polylineId: PolylineId(point.id),
      color: AppColors.green,
      width: 5,
      points: polylines.map((e) => LatLng(e.latitude, e.longitude)).toList(),
    );

    mapPolylines.value.removeWhere((poly) => poly.polylineId.value == point.id);
    mapPolylines.value = {newPolyline, ...mapPolylines.value};
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

  Future<LocationPoint> getLocationFromLatLngAPI(LocationPoint point) async {
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

  Future<List<PointLatLng>> getRoutePolyPoints(LatLng startLatLng, LatLng endLatLng) async {
    try {
      final uri = Uri.parse(
          "$baseGoogleMapsUrl/directions/json?origin=${startLatLng.latitude},${startLatLng.longitude}&destination=${endLatLng.latitude},${endLatLng.longitude}&key=$GOOGLE_MAP_API_KEY&result_type=street_address&limit=1");
      final response = await get(uri);

      if (response.statusCode == 200) {
        Map values = jsonDecode(response.body);
        List<dynamic> routes = List.from(values['routes']);
        if (routes.isEmpty) return [];

        final data = Map<String, dynamic>.from(routes.first);

        final points = data['overview_polyline']['points'];
        final polylines = PolylinePoints().decodePolyline(points);

        return polylines;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }
}
