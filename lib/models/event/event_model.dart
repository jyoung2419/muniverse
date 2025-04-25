import '../artist/artist_model.dart';

class EventModel {
  final String eventCode;
  final String name;
  final String content;
  final String status;
  final String bannerUrl;
  final String profileUrl;
  final String cardUrl;
  final String introContent;
  final String manager;
  final String shortName;

  final DateTime preOpenDateTime;
  final DateTime openDateTime;
  final DateTime endDateTime;
  final DateTime performanceStartTime;
  final DateTime performanceEndTime;
  final DateTime createDate;
  final DateTime? updateDate;
  final bool activeFlag;
  final bool deleteFlag;

  final List<ArtistModel>? artists;

  const EventModel({
    required this.eventCode,
    required this.name,
    required this.content,
    required this.status,
    required this.bannerUrl,
    required this.profileUrl,
    required this.cardUrl,
    required this.introContent,
    required this.manager,
    required this.shortName,
    required this.preOpenDateTime,
    required this.openDateTime,
    required this.endDateTime,
    required this.performanceStartTime,
    required this.performanceEndTime,
    required this.createDate,
    this.updateDate,
    required this.activeFlag,
    required this.deleteFlag,
    this.artists,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventCode: json['eventCode'],
      name: json['name'],
      content: json['content'],
      status: json['status'],
      bannerUrl: json['bannerUrl'] ?? '',
      profileUrl: json['profileUrl'] ?? '',
      cardUrl: json['cardUrl'] ?? '',
      introContent: json['introContent'],
      manager: json['manager'],
      shortName: json['shortName'],
      preOpenDateTime: DateTime.parse(json['preOpenDateTime']),
      openDateTime: DateTime.parse(json['openDateTime']),
      endDateTime: DateTime.parse(json['endDateTime']),
      performanceStartTime: DateTime.parse(json['performanceStartTime']),
      performanceEndTime: DateTime.parse(json['performanceEndTime']),
      createDate: DateTime.parse(json['createDate']),
      updateDate: json['updateDate'] != null ? DateTime.parse(json['updateDate']) : null,
      activeFlag: json['activeFlag'] == true || json['activeFlag'] == 1,
      deleteFlag: json['deleteFlag'] == true || json['deleteFlag'] == 1,
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
      'cardUrl': cardUrl,
      'introContent': introContent,
      'manager': manager,
      'shortName': shortName,
      'preOpenDateTime': preOpenDateTime.toIso8601String(),
      'openDateTime': openDateTime.toIso8601String(),
      'endDateTime': endDateTime.toIso8601String(),
      'performanceStartTime': performanceStartTime.toIso8601String(),
      'performanceEndTime': performanceEndTime.toIso8601String(),
      'createDate': createDate.toIso8601String(),
      'updateDate': updateDate?.toIso8601String(),
      'activeFlag': activeFlag,
      'deleteFlag': deleteFlag,
      'artists': artists?.map((a) => a.toJson()).toList(),
    };
  }
}
