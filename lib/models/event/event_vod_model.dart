import 'event_model.dart';

class EventVODModel {
  final int eventYear;
  final int round;
  final DateTime createDate;
  final DateTime endDate;
  final DateTime openDate;
  final DateTime? updateDate;
  final String eventCode;
  final String vodCode;
  final String name;
  final String content;
  final String profileImageUrl;
  final String videoUrl;

  final EventModel? event; // 🔄 Optional: 연관된 이벤트 객체

  EventVODModel({
    required this.eventYear,
    required this.round,
    required this.createDate,
    required this.endDate,
    required this.openDate,
    this.updateDate,
    required this.eventCode,
    required this.vodCode,
    required this.name,
    required this.content,
    required this.profileImageUrl,
    required this.videoUrl,
    this.event,
  });

  factory EventVODModel.fromJson(Map<String, dynamic> json) {
    return EventVODModel(
      eventYear: json['eventYear'],
      round: json['round'],
      createDate: DateTime.parse(json['createDate']),
      endDate: DateTime.parse(json['endDate']),
      openDate: DateTime.parse(json['openDate']),
      updateDate: json['updateDate'] != null ? DateTime.parse(json['updateDate']) : null,
      eventCode: json['eventCode'],
      vodCode: json['vodCode'],
      name: json['name'],
      content: json['content'],
      profileImageUrl: json['profileImageUrl'],
      videoUrl: json['videoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventYear': eventYear,
      'round': round,
      'createDate': createDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'openDate': openDate.toIso8601String(),
      'updateDate': updateDate?.toIso8601String(),
      'eventCode': eventCode,
      'vodCode': vodCode,
      'name': name,
      'content': content,
      'profileImageUrl': profileImageUrl,
      'videoUrl': videoUrl,
    };
  }
}
