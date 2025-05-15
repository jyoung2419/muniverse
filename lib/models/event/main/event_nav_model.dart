class EventNavModel {
  final String eventName;
  final String eventCode;

  EventNavModel({
    required this.eventName,
    required this.eventCode,
  });

  factory EventNavModel.fromJson(Map<String, dynamic> json) {
    return EventNavModel(
      eventName: json['eventName'] ?? '',
      eventCode: json['eventCode'] ?? '',
    );
  }
}