import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:okepoint/constants/icon_path.dart';

import 'components/info_window.dart';
import 'components/map_tooltip.dart';

class MapView extends ConsumerStatefulWidget {
  const MapView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
  late Completer<GoogleMapController> mapController;
  late CustomInfoWindowController infoWindowController;

  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();

    infoWindowController = CustomInfoWindowController();

    mapController = Completer<GoogleMapController>();
    _initializedMap();
  }

  Future<void> _initializedMap() async {
    final icon = await getMapIcon(IconPaths.point);
    var latLng = const LatLng(0, 0);
    markers.clear();

    markers.add(
      Marker(
        markerId: const MarkerId('id'),
        icon: icon,
        position: latLng,
        onTap: () {
          infoWindowController.hideInfoWindow!();
          infoWindowController.addInfoWindow!(
            CustomWindow(
              info: OkePointInfoWindow(
                name: "Hypercity",
                logoUrl: "",
                address: '',
                position: latLng,
              ),
            ),
            latLng,
          );
        },
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          myLocationButtonEnabled: false,
          mapType: MapType.terrain,
          initialCameraPosition: const CameraPosition(
            target: LatLng(0, 0),
            zoom: 15,
          ),
          markers: markers,
          onTap: (_) {
            infoWindowController.hideInfoWindow!();
          },
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
  }

  Future<BitmapDescriptor> getMapIcon(String iconPath) async {
    final Uint8List endMarker = await getBytesFromAsset(iconPath, 65);
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
