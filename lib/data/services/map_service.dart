// ignore_for_file: public_member_api_docs, sort_constructors_first, constant_identifier_names
import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:okepoint/app.dart';

import '../../configs/app_config.dart';
import '../../configs/firebase_options.dart';
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
  final FlutterBackgroundService backgroundService = FlutterBackgroundService();

  final String baseGoogleMapsUrl = "https://maps.googleapis.com/maps/api";

  ValueNotifier<bool> enabledLocationSharing = ValueNotifier<bool>(false);

  ValueNotifier<LocationPoint?> currentUserLocationPointNotifier = ValueNotifier<LocationPoint?>(null);
  ValueNotifier<Set<Marker>> mapMarkers = ValueNotifier<Set<Marker>>({});

  StreamSubscription? _positionSubscription;

  BitmapDescriptor? userIconPin;

  bool initialLastLocation = true;

  LatLng? lastLatLng;

  MapService(this.ref) {
    _initializedBackgroundService();
  }

  Future<void> _initializedBackgroundService() async {
    try {
      final result = await backgroundService.configure(
          iosConfiguration: IosConfiguration(
            onForeground: _onBackgroundListener,
            onBackground: (v) => _onBackgroundListener(v, isBackground: true),
          ),
          androidConfiguration: AndroidConfiguration(
            isForegroundMode: false,
            onStart: (v) => _onBackgroundListener(v, isBackground: true),
          ));

      backgroundService.startService();

      debugPrint("BACKGROUND SERVICE INITIALIZED: $result");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> _onBackgroundListener(ServiceInstance service, {bool isBackground = false}) async {
    debugPrint("BackgroundListener");

    if (isBackground) {
      AppFlavorConfigs.instance.setFlavor = AppFlavor.dev;
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(options: kIsWeb ? DefaultFirebaseOptions.currentPlatform(AppFlavor.dev) : null);
      debugPrint("START BACKGROUND SERVICE");
    }

    return true;
  }

  Future<void> shareLocationRealtime(Function(LocationPoint) onLocationChanged) async {
    try {
      cancelRealtimeLocationShare();

      _positionSubscription = Geolocator.getPositionStream().listen((position) {
        enabledLocationSharing.value = true;

        final latLng = LatLng(position.latitude, position.longitude);
        final location = LocationPoint(
          id: "current-user-location",
          name: '',
          geohash: '',
          descriptor: userIconPin!,
          location: latLng,
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

            print("DB LISTENING $latLng");
          }
        }
      });
    } catch (_) {}
  }

  void cancelRealtimeLocationShare() {
    _positionSubscription?.cancel();
    _positionSubscription = null;

    initialLastLocation = true;
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
      );

      final newLocation = await getLocationFromLatLng(location);
      currentUserLocationPointNotifier.value = newLocation;
      lastLatLng = latLng;

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
      debugPrint(e.toString());
    }
    return point;
  }
}
