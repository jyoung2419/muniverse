class UserMeModel {
  final String userId;
  final String userNickName;

  UserMeModel({
    required this.userId,
    required this.userNickName,
  });

  factory UserMeModel.fromJson(Map<String, dynamic> json) {
    return UserMeModel(
      userId: json['userId']?.toString() ?? '',
      userNickName: json['userNickName']?.toString() ?? '',
    );
  }
}
