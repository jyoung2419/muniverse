class NoticeModel {
  final int seq;
  final String title;
  final String content;
  final bool active;
  final int displayOrder;
  final DateTime createDate;
  final DateTime? updateDate;

  NoticeModel({
    required this.seq,
    required this.title,
    required this.content,
    required this.active,
    required this.displayOrder,
    required this.createDate,
    this.updateDate,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      seq: json['seq'],
      title: json['title'],
      content: json['content'],
      active: json['active'],
      displayOrder: json['displayOrder'],
      createDate: DateTime.parse(json['createDate']),
      updateDate: json['updateDate'] != null
          ? DateTime.parse(json['updateDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seq': seq,
      'title': title,
      'content': content,
      'active': active,
      'displayOrder': displayOrder,
      'createDate': createDate.toIso8601String(),
      'updateDate': updateDate?.toIso8601String(),
    };
  }
}
