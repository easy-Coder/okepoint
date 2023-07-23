// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomInfoWindowController {
  Function(Widget, LatLng)? addInfoWindow;
  VoidCallback? onCameraMove;
  VoidCallback? hideInfoWindow;
  GoogleMapController? googleMapController;

  void dispose() {
    addInfoWindow = null;
    onCameraMove = null;
    hideInfoWindow = null;
    googleMapController = null;
  }
}

class CustomInfoWindow extends StatefulWidget {
  final CustomInfoWindowController controller;

  final double offset;
  final double height;
  final double width;

  const CustomInfoWindow({
    super.key,
    required this.controller,
    this.offset = 50,
    this.height = 50,
    this.width = 100,
  })  : assert(offset >= 0),
        assert(height >= 0),
        assert(width >= 0);

  @override
  _CustomInfoWindowState createState() => _CustomInfoWindowState();
}

class _CustomInfoWindowState extends State<CustomInfoWindow> {
  bool _showNow = false;
  double _leftMargin = 0;
  double _topMargin = 0;
  Widget? _child;
  LatLng? _latLng;

  @override
  void initState() {
    super.initState();
    widget.controller.addInfoWindow = _addInfoWindow;
    widget.controller.onCameraMove = _onCameraMove;
    widget.controller.hideInfoWindow = _hideInfoWindow;
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.dispose();
  }

  void _updateInfoWindow() async {
    if (_latLng == null || _child == null || widget.controller.googleMapController == null) {
      return;
    }
    ScreenCoordinate screenCoordinate = await widget.controller.googleMapController!.getScreenCoordinate(_latLng!);
    double devicePixelRatio;

    if (Platform.isAndroid && mounted) {
      devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    } else {
      devicePixelRatio = 1.0;
    }
    double left = (screenCoordinate.x.toDouble() / devicePixelRatio) - (widget.width / 2);
    double top = (screenCoordinate.y.toDouble() / devicePixelRatio) - (widget.offset + widget.height);
    setState(() {
      _showNow = true;
      _leftMargin = left;
      _topMargin = top;
    });
  }

  void _addInfoWindow(Widget child, LatLng latLng) {
    _child = child;
    _latLng = latLng;
    _updateInfoWindow();
  }

  void _onCameraMove() {
    if (_showNow) _updateInfoWindow();
  }

  void _hideInfoWindow() {
    setState(() => _showNow = false);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _leftMargin,
      top: _topMargin,
      child: Visibility(
        visible: (_showNow == false || (_leftMargin == 0 && _topMargin == 0) || _child == null || _latLng == null) ? false : true,
        child: SizedBox(
          height: widget.height,
          width: widget.width,
          child: _child,
        ),
      ),
    );
  }
}
