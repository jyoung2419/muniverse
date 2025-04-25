class ArtistModel {
  final String artistCode;
  final String name;
  final String artistType; // 'GROUP' | 'SOLO'
  final String content;
  final String? profileUrl;
  final String? admin;

  final DateTime createDate;
  final DateTime? updateDate;
  final bool deleteFlag;

  const ArtistModel({
    required this.artistCode,
    required this.name,
    required this.artistType,
    required this.content,
    this.profileUrl,
    this.admin,
    required this.createDate,
    this.updateDate,
    required this.deleteFlag,
  });

  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
      artistCode: json['artistCode'],
      name: json['name'],
      artistType: json['artistType'],
      content: json['content'],
      profileUrl: json['profileUrl'],
      admin: json['admin'],
      createDate: DateTime.parse(json['createDate']),
      updateDate: json['updateDate'] != null ? DateTime.parse(json['updateDate']) : null,
      deleteFlag: json['deleteFlag'] == true || json['deleteFlag'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'artistCode': artistCode,
      'name': name,
      'artistType': artistType,
      'content': content,
      'profileUrl': profileUrl,
      'admin': admin,
      'createDate': createDate.toIso8601String(),
      'updateDate': updateDate?.toIso8601String(),
      'deleteFlag': deleteFlag,
    };
  }
}
