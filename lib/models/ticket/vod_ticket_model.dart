import 'base_ticket.dart';
import '../event/event_model.dart';
import '../user/user_model.dart';

class VODTicket extends BaseTicket {
  final String vodPinNumber;
  final DateTime? startTime;
  final DateTime? endTime;
  final int expiredDate;
  final bool useFlag;
  final UserModel user;
  final EventModel event;
  final DateTime createDate;
  final String? vodExImg;

  VODTicket({
    required this.vodPinNumber,
    this.startTime,
    this.endTime,
    required this.expiredDate,
    required this.useFlag,
    required this.user,
    required this.event,
    required this.createDate,
    this.vodExImg,
  });

  factory VODTicket.fromJson(Map<String, dynamic> json) {
    return VODTicket(
      vodPinNumber: json['vodPinNumber'],
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      expiredDate: json['expiredDate'],
      useFlag: json['useFlag'],
      user: UserModel.fromJson(json['user']),
      event: EventModel.fromJson(json['event']),
      createDate: DateTime.parse(json['createDate']),
      vodExImg: json['vodExImg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vodPinNumber': vodPinNumber,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'expiredDate': expiredDate,
      'useFlag': useFlag,
      'user': user.toJson(),
      'event': event.toJson(),
      'createDate': createDate.toIso8601String(),
      'vodExImg': vodExImg,
    };
  }

  @override
  String get title => event.name;

  @override
  DateTime get date => startTime ?? DateTime.now();

  @override
  String get imagePath => vodExImg ?? 'assets/images/vod.png';

  @override
  String get type => 'VOD';
}
