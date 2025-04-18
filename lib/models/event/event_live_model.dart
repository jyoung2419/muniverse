import 'event_model.dart';

class EventLiveModel {
  final String liveCode;
  final String name;
  final String content;
  final String profileImageUrl;
  final String videoUrl;
  final DateTime taskDate;
  final DateTime taskEndDate;
  final int eventYear;
  final EventModel event;
  final DateTime createDate;
  final DateTime? updateDate;

  EventLiveModel({
    required this.liveCode,
    required this.name,
    required this.content,
    required this.profileImageUrl,
    required this.videoUrl,
    required this.taskDate,
    required this.taskEndDate,
    required this.eventYear,
    required this.event,
    required this.createDate,
    this.updateDate,
  });

  factory EventLiveModel.fromJson(Map<String, dynamic> json) {
    return EventLiveModel(
      liveCode: json['liveCode'],
      name: json['name'],
      content: json['content'],
      profileImageUrl: json['profileImageUrl'],
      videoUrl: json['videoUrl'],
      taskDate: DateTime.parse(json['taskDate']),
      taskEndDate: DateTime.parse(json['taskEndDate']),
      eventYear: json['eventYear'],
      event: EventModel.fromJson(json['event']),
      createDate: DateTime.parse(json['createDate']),
      updateDate: json['updateDate'] != null ? DateTime.parse(json['updateDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'liveCode': liveCode,
      'name': name,
      'content': content,
      'profileImageUrl': profileImageUrl,
      'videoUrl': videoUrl,
      'taskDate': taskDate.toIso8601String(),
      'taskEndDate': taskEndDate.toIso8601String(),
      'eventYear': eventYear,
      'event': event.toJson(),
      'createDate': createDate.toIso8601String(),
      'updateDate': updateDate?.toIso8601String(),
    };
  }
}
