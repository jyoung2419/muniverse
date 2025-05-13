class UserProfileModel {
  final String id;
  final String nickname;
  final String email;
  final String name;
  final String? profileUrl;
  final bool localFlag;
  final DateTime createDate;

  const UserProfileModel({
    required this.id,
    required this.nickname,
    required this.email,
    required this.name,
    this.profileUrl,
    required this.localFlag,
    required this.createDate,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? '',
      nickname: json['nickname'] ?? json['nickName'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      profileUrl: json['profileUrl'],
      localFlag: json['localFlag'] ?? false,
      createDate: DateTime.tryParse(json['createDate'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'nickName': nickname,
      'name': name,
      'localFlag': localFlag,
    };
  }
}
