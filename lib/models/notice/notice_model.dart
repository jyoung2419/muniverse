class NoticeModel {
  final String title;
  final String content;
  final DateTime? createDate;
  final DateTime? updateDate;

  NoticeModel({
    required this.title,
    required this.content,
    required this.createDate,
    required this.updateDate,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createDate: json['createDate'] != null ? DateTime.parse(json['createDate']) : null,
      updateDate: json['updateDate'] != null ? DateTime.parse(json['updateDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'createDate': createDate?.toIso8601String(),
      'updateDate': updateDate?.toIso8601String(),
    };
  }
}
