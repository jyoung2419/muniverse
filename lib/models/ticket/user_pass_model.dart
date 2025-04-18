import 'package:flutter/foundation.dart';

enum UserPassType { STREAMING, VOD }

UserPassType userPassTypeFromString(String type) {
  return UserPassType.values.firstWhere(
        (e) => describeEnum(e) == type,
    orElse: () => UserPassType.VOD,
  );
}

String userPassTypeToString(UserPassType type) {
  return describeEnum(type);
}

class EventUseInfo {
  final String code;
  final UserPassType type; // STREAMING | VOD
  final String pinNumber;
  final bool used;
  final DateTime? usedAt;

  EventUseInfo({
    required this.code,
    required this.type,
    required this.pinNumber,
    required this.used,
    this.usedAt,
  });

  factory EventUseInfo.fromJson(Map<String, dynamic> json) {
    return EventUseInfo(
      code: json['code'],
      type: userPassTypeFromString(json['type']),
      pinNumber: json['pinNumber'],
      used: json['used'],
      usedAt: json['usedAt'] != null ? DateTime.parse(json['usedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'type': userPassTypeToString(type),
      'pinNumber': pinNumber,
      'used': used,
      'usedAt': usedAt?.toIso8601String(),
    };
  }
}

class UserPass {
  final String pinNumber;
  final String userId;
  final String passName;
  final DateTime createdAt;
  final bool useFlag;
  final List<EventUseInfo> events;

  UserPass({
    required this.pinNumber,
    required this.userId,
    required this.passName,
    required this.createdAt,
    required this.useFlag,
    required this.events,
  });

  factory UserPass.fromJson(Map<String, dynamic> json) {
    return UserPass(
      pinNumber: json['pinNumber'],
      userId: json['userId'],
      passName: json['passName'],
      createdAt: DateTime.parse(json['createdAt']),
      useFlag: json['useFlag'],
      events: (json['events'] as List)
          .map((e) => EventUseInfo.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pinNumber': pinNumber,
      'userId': userId,
      'passName': passName,
      'createdAt': createdAt.toIso8601String(),
      'useFlag': useFlag,
      'events': events.map((e) => e.toJson()).toList(),
    };
  }
}
