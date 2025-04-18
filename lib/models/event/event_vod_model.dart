import 'event_model.dart';

class EventVODModel {
  final String vodCode;
  final String name;
  final String content;
  final String profileImageUrl; // 표출될 이미지
  final String videoUrl;  // 추후 추가할 비디오 예시
  final EventModel event;
  final int eventYear;
  final DateTime openDate;
  final DateTime createDate;
  final DateTime? updateDate;

  EventVODModel({
    required this.vodCode,
    required this.name,
    required this.content,
    required this.profileImageUrl,
    required this.videoUrl,
    required this.event,
    required this.eventYear,
    required this.openDate,
    required this.createDate,
    this.updateDate,
  });

  factory EventVODModel.fromJson(Map<String, dynamic> json) {
    return EventVODModel(
      vodCode: json['vodCode'],
      name: json['name'],
      content: json['content'],
      profileImageUrl: json['profileImageUrl'],
      videoUrl: json['videoUrl'],
      event: EventModel.fromJson(json['event']),
      eventYear: json['eventYear'],
      openDate: DateTime.parse(json['openDate']),
      createDate: DateTime.parse(json['createDate']),
      updateDate: json['updateDate'] != null ? DateTime.parse(json['updateDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vodCode': vodCode,
      'name': name,
      'content': content,
      'profileImageUrl': profileImageUrl,
      'videoUrl': videoUrl,
      'event': event.toJson(),
      'eventYear': eventYear,
      'openDate': openDate.toIso8601String(),
      'createDate': createDate.toIso8601String(),
      'updateDate': updateDate?.toIso8601String(),
    };
  }
}
