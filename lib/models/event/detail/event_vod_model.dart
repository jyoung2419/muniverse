class EventVODModel {
  final String vodCode;
  final String name;
  final String content;
  final String profileImageUrl;
  final DateTime openDate;
  final DateTime endDate;
  final String vodStatus;

  EventVODModel({
    required this.vodCode,
    required this.name,
    required this.content,
    required this.profileImageUrl,
    required this.openDate,
    required this.endDate,
    required this.vodStatus,
  });

  factory EventVODModel.fromJson(Map<String, dynamic> json) {
    return EventVODModel(
      vodCode: json['vodCode']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      profileImageUrl: json['profileImageUrl']?.toString() ?? '',
      openDate: DateTime.tryParse(json['openDate'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['endDate'] ?? '') ?? DateTime.now(),
      vodStatus: json['vodStatus']?.toString() ?? 'CLOSED',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vodCode': vodCode,
      'name': name,
      'content': content,
      'profileImageUrl': profileImageUrl,
      'openDate': openDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'vodStatus': vodStatus,
    };
  }
}
