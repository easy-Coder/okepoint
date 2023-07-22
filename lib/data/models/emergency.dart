// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Emergency {
  final String title;
  final String subtitle;
  final String type;

  const Emergency({
    required this.title,
    required this.subtitle,
    required this.type,
  });

  Emergency copyWith({
    String? title,
    String? subtitle,
    String? type,
  }) {
    return Emergency(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'subtitle': subtitle,
      'type': type,
    };
  }

  factory Emergency.fromMap(Map<String, dynamic> map) {
    return Emergency(
      title: map['title'] as String,
      subtitle: map['subtitle'] as String,
      type: map['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Emergency.fromJson(String source) => Emergency.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Emergency(title: $title, subtitle: $subtitle, type: $type)';

  @override
  bool operator ==(covariant Emergency other) {
    if (identical(this, other)) return true;

    return other.title == title && other.subtitle == subtitle && other.type == type;
  }

  @override
  int get hashCode => title.hashCode ^ subtitle.hashCode ^ type.hashCode;
}
