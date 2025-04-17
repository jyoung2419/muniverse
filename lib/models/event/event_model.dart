import '../artist/artist_model.dart';

class EventModel {
  final String eventCode;
  final String name;
  final String content;
  final String status;
  final String bannerUrl; // 배너 이미지
  final String profileUrl;  // 카드 이미지
  final DateTime preOpenDateTime; // 가오픈
  final DateTime openDateTime;  // 오픈
  final DateTime endDateTime;
  final DateTime performanceStartTime;  // 스트리밍 시작
  final DateTime performanceEndTime;
  final bool activeFlag;
  final DateTime createDate;
  final DateTime? updateDate;
  final bool deleteFlag;

  final List<ArtistModel>? artists; // 🔥 참여 아티스트들 (EventArtist 기반)

  const EventModel({
    required this.eventCode,
    required this.name,
    required this.content,
    required this.status,
    required this.bannerUrl,
    required this.profileUrl,
    required this.preOpenDateTime,
    required this.openDateTime,
    required this.endDateTime,
    required this.performanceStartTime,
    required this.performanceEndTime,
    required this.activeFlag,
    required this.createDate,
    this.updateDate,
    required this.deleteFlag,
    this.artists,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventCode: json['eventCode'],
      name: json['name'],
      content: json['content'],
      status: json['status'],
      bannerUrl: json['bannerUrl'],
      profileUrl: json['profileUrl'],
      preOpenDateTime: DateTime.parse(json['preOpenDateTime']),
      openDateTime: DateTime.parse(json['openDateTime']),
      endDateTime: DateTime.parse(json['endDateTime']),
      performanceStartTime: DateTime.parse(json['performanceStartTime']),
      performanceEndTime: DateTime.parse(json['performanceEndTime']),
      activeFlag: json['activeFlag'],
      createDate: DateTime.parse(json['createDate']),
      updateDate: json['updateDate'] != null ? DateTime.parse(json['updateDate']) : null,
      deleteFlag: json['deleteFlag'],
      artists: json['artists'] != null
          ? List<ArtistModel>.from(
          json['artists'].map((a) => ArtistModel.fromJson(a)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventCode': eventCode,
      'name': name,
      'content': content,
      'status': status,
      'bannerUrl': bannerUrl,
      'profileUrl': profileUrl,
      'preOpenDateTime': preOpenDateTime.toIso8601String(),
      'openDateTime': openDateTime.toIso8601String(),
      'endDateTime': endDateTime.toIso8601String(),
      'performanceStartTime': performanceStartTime.toIso8601String(),
      'performanceEndTime': performanceEndTime.toIso8601String(),
      'activeFlag': activeFlag,
      'createDate': createDate.toIso8601String(),
      'updateDate': updateDate?.toIso8601String(),
      'deleteFlag': deleteFlag,
      'artists': artists?.map((a) => a.toJson()).toList(),
    };
  }
}
