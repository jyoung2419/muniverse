class ArtistModel {
  final String artistCode;
  final String name;
  final String content;
  final String profileUrl;
  final String artistType;
  final DateTime createDate;
  final DateTime? updateDate;
  final bool deleteFlag;

  const ArtistModel({
    required this.artistCode,
    required this.name,
    required this.content,
    required this.profileUrl,
    required this.artistType,
    required this.createDate,
    this.updateDate,
    required this.deleteFlag,
  });

  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
      artistCode: json['artistCode'],
      name: json['name'],
      content: json['content'],
      profileUrl: json['profileUrl'],
      artistType: json['artistType'],
      createDate: DateTime.parse(json['createDate']),
      updateDate: json['updateDate'] != null
          ? DateTime.parse(json['updateDate'])
          : null,
      deleteFlag: json['deleteFlag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'artistCode': artistCode,
      'name': name,
      'content': content,
      'profileUrl': profileUrl,
      'artistType': artistType,
      'createDate': createDate.toIso8601String(),
      'updateDate': updateDate?.toIso8601String(),
      'deleteFlag': deleteFlag,
    };
  }
}
