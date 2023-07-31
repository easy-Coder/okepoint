// ignore_for_file: public_member_api_docs, sort_constructors_first, constant_identifier_names
import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

import '../../constants/icon_path.dart';
import '../../constants/keys.dart';
import '../models/point.dart';
import 'package:geolocator/geolocator.dart';

final mapServiceProvider = Provider<MapService>((ref) {
  return MapService(ref);
});

class MapService {
  final Ref ref;

  final String baseGoogleMapsUrl = "https://maps.googleapis.com/maps/api";

  ValueNotifier<LocationPoint?> currentUserLocationPointNotifier = ValueNotifier<LocationPoint?>(null), destinationLocationPointNotifier = ValueNotifier<LocationPoint?>(null);
  ValueNotifier<Set<Marker>> mapMarkers = ValueNotifier<Set<Marker>>({});

  MapService(this.ref);

  Future<LocationPoint?> getUserCurrentPosition() async {
    try {
      final icon = await getMapIcon(IconPaths.pin);

      final isGranted = await requestPermission();

      if (!isGranted) return null;
      final data = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      final latLng = LatLng(data.latitude, data.longitude);

      final location = LocationPoint(
        id: "current-user-location",
        name: 'Nigeria',
        geohash: '',
        location: latLng,
        descriptor: icon,
      );

      final newLocation = await getLocationFromLatLng(location);
      currentUserLocationPointNotifier.value = newLocation;

      addMarker(newLocation);
    } catch (_) {}

    return currentUserLocationPointNotifier.value;
  }

  Future<bool> requestPermission() async {
    final permission = await Geolocator.requestPermission();
    return [LocationPermission.always, LocationPermission.whileInUse].contains(permission);
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
      print(e);
    }
    return point;
  }

  Future<BitmapDescriptor> getMapIcon(String iconPath) async {
    final Uint8List endMarker = await getBytesFromAsset(iconPath, 45);
    final icon = BitmapDescriptor.fromBytes(endMarker);
    return icon;
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }
}
