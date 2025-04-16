import 'event_model.dart';

class EventVODModel {
  final String vodCode;
  final String name;
  final String content;
  final EventModel event;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? vodExImg; // 이미지 경로 추가

  EventVODModel({
    required this.vodCode,
    required this.name,
    required this.content,
    required this.event,
    required this.createDate,
    this.updateDate,
    this.vodExImg,
  });

  factory EventVODModel.fromJson(Map<String, dynamic> json) {
    return EventVODModel(
      vodCode: json['vodCode'],
      name: json['name'],
      content: json['content'],
      event: EventModel.fromJson(json['event']),
      createDate: DateTime.parse(json['createDate']),
      updateDate: json['updateDate'] != null ? DateTime.parse(json['updateDate']) : null,
      vodExImg: json['vodExImg'], // 예시 이미지
    );
  }
}
