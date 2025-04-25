import 'event_model.dart';

class EventLiveModel {
  final int eventYear;
  final int round;
  final DateTime createDate;
  final DateTime taskDate;
  final DateTime taskEndDate;
  final DateTime? updateDate;
  final String eventCode;
  final String liveCode;
  final String name;
  final String content;
  final String profileImageUrl;
  final String videoUrl;

  final EventModel? event; // 🔄 Optional: 연관된 이벤트 객체 (선택)

  EventLiveModel({
    required this.eventYear,
    required this.round,
    required this.createDate,
    required this.taskDate,
    required this.taskEndDate,
    this.updateDate,
    required this.eventCode,
    required this.liveCode,
    required this.name,
    required this.content,
    required this.profileImageUrl,
    required this.videoUrl,
    this.event,
  });

  factory EventLiveModel.fromJson(Map<String, dynamic> json) {
    return EventLiveModel(
      eventYear: json['eventYear'],
      round: json['round'],
      createDate: DateTime.parse(json['createDate']),
      taskDate: DateTime.parse(json['taskDate']),
      taskEndDate: DateTime.parse(json['taskEndDate']),
      updateDate: json['updateDate'] != null ? DateTime.parse(json['updateDate']) : null,
      eventCode: json['eventCode'],
      liveCode: json['liveCode'],
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
      'taskDate': taskDate.toIso8601String(),
      'taskEndDate': taskEndDate.toIso8601String(),
      'updateDate': updateDate?.toIso8601String(),
      'eventCode': eventCode,
      'liveCode': liveCode,
      'name': name,
      'content': content,
      'profileImageUrl': profileImageUrl,
      'videoUrl': videoUrl,
    };
  }
}
