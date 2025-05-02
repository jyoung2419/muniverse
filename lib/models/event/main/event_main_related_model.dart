class EventMainRelatedModel {
  final String name;
  final String profileImageUrl;
  final String videoUrl;

  EventMainRelatedModel({
    required this.name,
    required this.profileImageUrl,
    required this.videoUrl,
  });

  factory EventMainRelatedModel.fromJson(Map<String, dynamic> json) {
    return EventMainRelatedModel(
      name: json['name'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
    );
  }
}
