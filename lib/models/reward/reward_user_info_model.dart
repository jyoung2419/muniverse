class RewardUserInfoModel {
  final String rewardCode;
  final String name;
  final String phone;
  final String email;
  final String? sex;
  final String? birthDate;

  RewardUserInfoModel({
    required this.rewardCode,
    required this.name,
    required this.phone,
    required this.email,
    this.sex,
    this.birthDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'rewardCode': rewardCode,
      'name': name,
      'phone': phone,
      'email': email,
      'sex': sex,
      'birthDate': birthDate,
    };
  }
}
