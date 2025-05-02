class EventInfoModel {
  final String content;

  EventInfoModel({required this.content});

  factory EventInfoModel.fromJson(Map<String, dynamic> json) {
    return EventInfoModel(
      content: json['content'] ?? '',
    );
  }
}