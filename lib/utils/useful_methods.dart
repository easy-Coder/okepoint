import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:random_string/random_string.dart';

DateTime get timeStampNow => Timestamp.now().toDate();
int get utcTimeNow => timeStampNow.millisecondsSinceEpoch;

Future<BitmapDescriptor> getIconFromAssetString(String iconPath) async {
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

String generate16DigitIds(String prefix) {
  final randomString = randomAlphaNumeric(16);
  return '${prefix}_$randomString';
}
