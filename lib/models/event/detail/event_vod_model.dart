class EventVODModel {
  final String vodCode;
  final String name;
  final String content;
  final String profileImageUrl;

  EventVODModel({
    required this.vodCode,
    required this.name,
    required this.content,
    required this.profileImageUrl,
  });

  factory EventVODModel.fromJson(Map<String, dynamic> json) {
    return EventVODModel(
      vodCode: json['vodCode']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      profileImageUrl: json['profileImageUrl']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vodCode': vodCode,
      'name': name,
      'content': content,
      'profileImageUrl': profileImageUrl,
    };
  }
}
