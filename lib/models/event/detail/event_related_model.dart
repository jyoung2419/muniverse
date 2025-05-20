class EventRelatedModel {
  final String name;
  final String profileImageUrl;
  final String videoUrl;
  final String eventCode;

  EventRelatedModel({
    required this.name,
    required this.profileImageUrl,
    required this.videoUrl,
    required this.eventCode,
  });

  factory EventRelatedModel.fromJson(Map<String, dynamic> json) {
    return EventRelatedModel(
      name: json['name'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      eventCode: json['eventCode'] ?? '',
    );
  }
}
