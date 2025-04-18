import '../event/event_vod_model.dart';
import '../user/user_model.dart';

class VODTicket {
  final String vodPinNumber;
  final DateTime? startTime;
  final DateTime? endTime;
  final int expiredDate;
  final bool useFlag;
  final DateTime createDate;
  final UserModel userId;
  final EventVODModel eventVOD;
  // final String? vodExImg; // UI용 썸네일 (서버 응답에 없을 수 있음)

  VODTicket({
    required this.vodPinNumber,
    this.startTime,
    this.endTime,
    required this.expiredDate,
    required this.useFlag,
    required this.createDate,
    required this.userId,
    required this.eventVOD,
    // this.vodExImg,
  });

  factory VODTicket.fromJson(Map<String, dynamic> json) {
    return VODTicket(
      vodPinNumber: json['vodPinNumber'],
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      expiredDate: json['expiredDate'],
      useFlag: json['useFlag'],
      createDate: DateTime.parse(json['createDate']),
      userId: UserModel.fromJson(json['userId']),
      eventVOD: EventVODModel.fromJson(json['eventVOD']),
      // vodExImg: json['vodExImg'], // 없으면 null로 받음
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vodPinNumber': vodPinNumber,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'expiredDate': expiredDate,
      'useFlag': useFlag,
      'createDate': createDate.toIso8601String(),
      'userId': userId.toJson(),
      'eventVOD': eventVOD.toJson(),
      // 'vodExImg': vodExImg,
    };
  }

  // UI 편의 필드
  String get title => eventVOD.name;
  DateTime get date => startTime ?? createDate;
  // String get imagePath => vodExImg ?? 'assets/images/vod.png';
  String get type => 'VOD';
}
