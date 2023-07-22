// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';

class User {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String profileImageUrl;

  final bool verified;
  final bool active;

  final Map<String, dynamic> homePreferences;
  final Map<String, dynamic> settings;

  final int createdAt;
  final int updatedAt;
  User({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.profileImageUrl,
    required this.verified,
    required this.active,
    required this.homePreferences,
    required this.settings,
    required this.createdAt,
    required this.updatedAt,
  });

  User copyWith({
    String? uid,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? profileImageUrl,
    bool? verified,
    bool? active,
    Map<String, dynamic>? homePreferences,
    Map<String, dynamic>? settings,
    int? createdAt,
    int? updatedAt,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      verified: verified ?? this.verified,
      active: active ?? this.active,
      homePreferences: homePreferences ?? this.homePreferences,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'verified': verified,
      'active': active,
      'homePreferences': homePreferences,
      'settings': settings,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] as String,
      email: map['email'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      phone: map['phone'] as String,
      profileImageUrl: map['profileImageUrl'] as String,
      verified: map['verified'] as bool,
      active: map['active'] as bool,
      homePreferences: Map<String, dynamic>.from(map['homePreferences'] as Map<String, dynamic>),
      settings: Map<String, dynamic>.from(map['settings'] as Map<String, dynamic>),
      createdAt: map['createdAt'] as int,
      updatedAt: map['updatedAt'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(uid: $uid, email: $email, firstName: $firstName, lastName: $lastName, phone: $phone, profileImageUrl: $profileImageUrl, verified: $verified, active: $active, homePreferences: $homePreferences, settings: $settings, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.email == email &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.phone == phone &&
        other.profileImageUrl == profileImageUrl &&
        other.verified == verified &&
        other.active == active &&
        mapEquals(other.homePreferences, homePreferences) &&
        mapEquals(other.settings, settings) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        email.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        phone.hashCode ^
        profileImageUrl.hashCode ^
        verified.hashCode ^
        active.hashCode ^
        homePreferences.hashCode ^
        settings.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
