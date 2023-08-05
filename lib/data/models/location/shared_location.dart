// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:okepoint/data/models/location/point.dart';

import '../../../utils/useful_methods.dart';

class SharedLocation {
  final String id;
  final Map<String, dynamic> createdBy;
  final LocationPoint startLocation;
  final LocationPoint lastLocation;
  final String emergencyType;
  final int duration;
  final int createdAt;
  final int updatedAt;

  SharedLocation({
    required this.id,
    required this.createdBy,
    required this.startLocation,
    required this.lastLocation,
    required this.emergencyType,
    required this.duration,
    required this.createdAt,
    required this.updatedAt,
  });

  static String get generatedId => generate16DigitIds("sl");

  SharedLocation copyWith({
    String? id,
    Map<String, dynamic>? createdBy,
    LocationPoint? startLocation,
    LocationPoint? lastLocation,
    String? emergencyType,
    int? duration,
    int? createdAt,
    int? updatedAt,
  }) {
    return SharedLocation(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      startLocation: startLocation ?? this.startLocation,
      lastLocation: lastLocation ?? this.lastLocation,
      emergencyType: emergencyType ?? this.emergencyType,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdBy': createdBy,
      'startLocation': startLocation.toMap(),
      'lastLocation': lastLocation.toMap(),
      'emergencyType': emergencyType,
      'duration': duration,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory SharedLocation.fromMap(Map<String, dynamic> map) {
    return SharedLocation(
      id: map['id'] as String,
      createdBy: Map<String, dynamic>.from(map['createdBy'] as Map<String, dynamic>),
      startLocation: LocationPoint.fromMap(map['startLocation'] as Map<String, dynamic>),
      lastLocation: LocationPoint.fromMap(map['lastLocation'] as Map<String, dynamic>),
      emergencyType: map['emergencyType'] as String,
      duration: map['duration'] as int,
      createdAt: map['createdAt'] as int,
      updatedAt: map['updatedAt'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SharedLocation.fromJson(String source) => SharedLocation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SharedLocation(id: $id, createdBy: $createdBy, startLocation: $startLocation, lastLocation: $lastLocation, emergencyType: $emergencyType, duration: $duration, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant SharedLocation other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        mapEquals(other.createdBy, createdBy) &&
        other.startLocation == startLocation &&
        other.lastLocation == lastLocation &&
        other.emergencyType == emergencyType &&
        other.duration == duration &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ createdBy.hashCode ^ startLocation.hashCode ^ lastLocation.hashCode ^ emergencyType.hashCode ^ duration.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }
}
