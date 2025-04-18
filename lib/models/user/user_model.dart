enum SocialType { GOOGLE, X, NONE }

SocialType socialTypeFromString(String value) =>
    SocialType.values.firstWhere((e) => e.name == value, orElse: () => SocialType.NONE);

String socialTypeToString(SocialType type) => type.name;

class UserModel {
  final int seq;
  final String id;
  final String password;
  final String nickName;
  final String email;
  final String name;
  final String phoneNumber;
  final String? profileUrl;
  final SocialType socialType;
  final bool regisStatus;
  final DateTime createDate;
  final DateTime? updateDate;
  final bool deleteFlag;

  const UserModel({
    required this.seq,
    required this.id,
    required this.password,
    required this.nickName,
    required this.email,
    required this.name,
    required this.phoneNumber,
    this.profileUrl,
    required this.socialType,
    required this.regisStatus,
    required this.createDate,
    this.updateDate,
    required this.deleteFlag,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      seq: json['seq'],
      id: json['id'],
      password: json['password'],
      nickName: json['nickName'],
      email: json['email'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      profileUrl: json['profileUrl'],
      socialType: socialTypeFromString(json['socialType']),
      regisStatus: json['regisStatus'],
      createDate: DateTime.parse(json['createDate']),
      updateDate: json['updateDate'] != null ? DateTime.parse(json['updateDate']) : null,
      deleteFlag: json['deleteFlag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seq': seq,
      'id': id,
      'password': password,
      'nickName': nickName,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'profileUrl': profileUrl,
      'socialType': socialTypeToString(socialType),
      'regisStatus': regisStatus,
      'createDate': createDate.toIso8601String(),
      'updateDate': updateDate?.toIso8601String(),
      'deleteFlag': deleteFlag,
    };
  }
}
