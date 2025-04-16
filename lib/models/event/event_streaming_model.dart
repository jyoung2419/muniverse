import 'event_model.dart';

class EventStreamingModel {
  final String streamingCode;
  final String name;
  final String content;
  final EventModel event;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? imagePath; // ✅ 예시 이미지 경로

  EventStreamingModel({
    required this.streamingCode,
    required this.name,
    required this.content,
    required this.event,
    required this.createDate,
    this.updateDate,
    this.imagePath,
  });

  factory EventStreamingModel.fromJson(Map<String, dynamic> json) {
    return EventStreamingModel(
      streamingCode: json['streamingCode'],
      name: json['name'],
      content: json['content'],
      event: EventModel.fromJson(json['event']),
      createDate: DateTime.parse(json['createDate']),
      updateDate: json['updateDate'] != null ? DateTime.parse(json['updateDate']) : null,
      imagePath: json['imagePath'],
    );
  }
}
