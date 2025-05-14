class RewardUserInfoModel {
  final String rewardCode;
  final String name;
  final String phone;
  final String email;

  RewardUserInfoModel({
    required this.rewardCode,
    required this.name,
    required this.phone,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'rewardCode': rewardCode,
      'name': name,
      'phone': phone,
      'email': email,
    };
  }

  factory RewardUserInfoModel.fromJson(Map<String, dynamic> json) {
    return RewardUserInfoModel(
      rewardCode: json['rewardCode'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
