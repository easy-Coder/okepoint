import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPoint {
  final String id;
  final String name;
  final String geohash;
  final LatLng location;
  final BitmapDescriptor descriptor;

  LocationPoint({
    required this.location,
    this.descriptor = BitmapDescriptor.defaultMarker,
    required this.id,
    required this.geohash,
    required this.name,
  });

  LocationPoint copyWith({
    LatLng? location,
    BitmapDescriptor? descriptor,
    String? id,
    String? geohash,
    String? name,
  }) {
    return LocationPoint(
      location: location ?? this.location,
      descriptor: descriptor ?? this.descriptor,
      id: id ?? this.id,
      geohash: geohash ?? this.geohash,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'location': {
        "lat": location.latitude,
        "lng": location.longitude,
      },
      'id': id,
      'geohash': geohash,
    };
  }

  factory LocationPoint.fromMap(Map<String, dynamic> map) {
    final latlng = Map<String, dynamic>.from(map['location']);
    return LocationPoint(
      location: LatLng(latlng["lat"], latlng["lng"]),
      id: map['id'] as String,
      geohash: map['geohash'] as String,
      name: map['name'],
    );
  }

  @override
  String toString() => 'LocationPoint(location: $location, descriptor: $descriptor, id: $id, geohash: $geohash)';

  @override
  bool operator ==(covariant LocationPoint other) {
    if (identical(this, other)) return true;
    return other.location == location && other.descriptor == descriptor && other.id == id && other.geohash == geohash;
  }

  @override
  int get hashCode => location.hashCode ^ descriptor.hashCode ^ id.hashCode ^ geohash.hashCode;
}
