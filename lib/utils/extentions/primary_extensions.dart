import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:okepoint/utils/useful_methods.dart';

extension ColorBrightness on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1));

    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}

extension XString on String {
  bool hasLength(int length) {
    return trim().length >= length;
  }

  String get capitalize {
    return split(" ").map((str) => toBeginningOfSentenceCase(str)).join(" ");
  }

  bool get hasUppercase => contains(RegExp(r'[A-Z]'));
  bool get hasLowercase => contains(RegExp(r'[a-z]'));
  bool get hasNumber => contains(RegExp(r'[0-9]'));

  bool get hasBothUpperAndLowercase => hasLowercase && hasUppercase;

  String get getFirstAndMiddleName {
    String firstName = '';
    final names = split(' ');

    if (names.isNotEmpty) {
      firstName = names[0];

      if (names.length > 1 && names[1] != names.last) {
        firstName = "$firstName ${names[1]}";
      }
    }

    return firstName;
  }

  String get getFirstName {
    String firstName = '';
    final names = split(' ');

    if (names.isNotEmpty) {
      firstName = names[0];
    }

    return firstName;
  }

  String get getLastName {
    String lastName = '';
    final names = split(' ');

    if (names.length > 1) {
      lastName = names.last;
    }

    return lastName;
  }
}

extension XInt on int {
  Duration get seconds => Duration(seconds: this);

  DateTime? get timeMilliseconds {
    try {
      return Timestamp.fromMillisecondsSinceEpoch(this).toDate();
    } catch (_) {
      return null;
    }
  }

  String get getDigits => NumberFormat.simpleCurrency(locale: "en_US", decimalDigits: 0).format(this);
  String get getMoney => NumberFormat.simpleCurrency(locale: "en_US", decimalDigits: 00).format(this);
}

extension XDateTime on DateTime {
  String get timeAgo {
    final num elapsed = utcTimeNow - millisecondsSinceEpoch;

    final num seconds = elapsed / 1000;
    final num minutes = seconds / 60;
    final num hours = minutes / 60;
    final num days = hours / 24;
    final num months = days / 30;
    final num years = days / 365;

    if (seconds < 45) {
      return "Now";
    } else if (seconds < 90) {
      return '1 minute ago';
    } else if (minutes < 45) {
      return '${minutes.round()} minutes ago';
    } else if (minutes < 90) {
      return '1 hour ago';
    } else if (hours < 24) {
      return '${hours.round()} hours ago';
    } else if (hours < 48) {
      return '1 day ago';
    } else if (days < 30) {
      return '${days.round()} days ago';
    } else if (days < 60) {
      return '1 month ago';
    } else if (days < 365) {
      return '${months.round()} months ago';
    } else if (years < 2) {
      return '1 year ago';
    } else {
      return '${years.round()} years ago';
    }
  }
}
