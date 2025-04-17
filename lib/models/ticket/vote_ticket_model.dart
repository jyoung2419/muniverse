import '../user/user_model.dart';

class VoteTicketModel {
  final String votePinNumber;
  final bool useFlag;
  final UserModel user;
  final DateTime createDate;
  final DateTime? useDate;

  const VoteTicketModel({
    required this.votePinNumber,
    required this.useFlag,
    required this.user,
    required this.createDate,
    this.useDate,
  });

  factory VoteTicketModel.fromJson(Map<String, dynamic> json) {
    return VoteTicketModel(
      votePinNumber: json['votePinNumber'],
      useFlag: json['useFlag'],
      user: UserModel.fromJson(json['user']),
      createDate: DateTime.parse(json['createDate']),
      useDate: json['useDate'] != null ? DateTime.parse(json['useDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'votePinNumber': votePinNumber,
      'useFlag': useFlag,
      'user': user.toJson(),
      'createDate': createDate.toIso8601String(),
      'useDate': useDate?.toIso8601String(),
    };
  }
}
