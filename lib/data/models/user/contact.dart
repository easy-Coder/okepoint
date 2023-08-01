// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Contact {
  final String id;
  final String uid;
  final Map<String, dynamic> info;
  final List<String> emergencyTypes;
  final int createdAt;
  final int updatedAt;

  const Contact({
    required this.id,
    required this.uid,
    required this.info,
    required this.emergencyTypes,
    required this.createdAt,
    required this.updatedAt,
  });

  Contact copyWith({
    String? id,
    String? uid,
    Map<String, dynamic>? info,
    List<String>? emergencyTypes,
    int? createdAt,
    int? updatedAt,
  }) {
    return Contact(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      info: info ?? this.info,
      emergencyTypes: emergencyTypes ?? this.emergencyTypes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'info': info,
      'emergencyTypes': emergencyTypes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] as String,
      uid: map['uid'] as String,
      info: Map<String, dynamic>.from(map['info'] as Map<String, dynamic>),
      emergencyTypes: List<String>.from(map['emergencyTypes'] as List<String>),
      createdAt: map['createdAt'] as int,
      updatedAt: map['updatedAt'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Contact.fromJson(String source) => Contact.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Contact(id: $id, uid: $uid, info: $info, emergencyTypes: $emergencyTypes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Contact other) {
    if (identical(this, other)) return true;

    return other.id == id && other.uid == uid && mapEquals(other.info, info) && listEquals(other.emergencyTypes, emergencyTypes) && other.createdAt == createdAt && other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ uid.hashCode ^ info.hashCode ^ emergencyTypes.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }
}
