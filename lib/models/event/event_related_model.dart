class EventRelatedModel {
  final String name;
  final String profileImageUrl;
  final String videoUrl;

  EventRelatedModel({
    required this.name,
    required this.profileImageUrl,
    required this.videoUrl,
  });

  factory EventRelatedModel.fromJson(Map<String, dynamic> json) {
    return EventRelatedModel(
      name: json['name'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
    );
  }
}
