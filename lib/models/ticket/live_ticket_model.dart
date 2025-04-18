import '../user/user_model.dart';
import '../event/event_live_model.dart';

class LiveTicketModel {
  final String livePinNumber;
  final bool useFlag;
  final UserModel user;
  final EventLiveModel eventLive;
  final DateTime createDate;
  final DateTime? useDate;

  LiveTicketModel({
    required this.livePinNumber,
    required this.useFlag,
    required this.user,
    required this.eventLive,
    required this.createDate,
    this.useDate,
  });

  factory LiveTicketModel.fromJson(Map<String, dynamic> json) {
    return LiveTicketModel(
      livePinNumber: json['livePinNumber'],
      useFlag: json['useFlag'],
      user: UserModel.fromJson(json['user']),
      eventLive: EventLiveModel.fromJson(json['eventLive']),
      createDate: DateTime.parse(json['createDate']),
      useDate: json['useDate'] != null ? DateTime.parse(json['useDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'livePinNumber': livePinNumber,
      'useFlag': useFlag,
      'user': user.toJson(),
      'eventLive': eventLive.toJson(),
      'createDate': createDate.toIso8601String(),
      'useDate': useDate?.toIso8601String(),
    };
  }
}
