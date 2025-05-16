class EventModel {
  final String eventCode;
  final String name;
  final String shortName;
  final String introContent;
  final String content;
  final String bannerUrl;
  final String profileUrl;
  final int round;
  final String? liveCode;
  final String status;
  final DateTime performanceStartTime;
  final DateTime performanceEndTime;
  final DateTime? restNextPerformanceStartTime;

  const EventModel({
    required this.eventCode,
    required this.name,
    required this.shortName,
    required this.content,
    required this.introContent,
    required this.bannerUrl,
    required this.profileUrl,
    required this.status,
    required this.performanceStartTime,
    required this.performanceEndTime,
    required this.round,
    this.liveCode,
    this.restNextPerformanceStartTime,
  });

  factory EventModel.fromJson(Map<String, dynamic> json, String eventCode) {
    return EventModel(
      eventCode: eventCode,
      name: json['name'] ?? '',
      shortName: json['shortName'] ?? '',
      content: json['content'] ?? '',
      introContent: json['introContent'] ?? '',
      bannerUrl: json['bannerImageURL'] ?? '',
      profileUrl: json['profileImageURL'] ?? '',
      round: json['round'] == null
          ? 0
          : int.tryParse(json['round'].toString()) ?? 0,
      liveCode: json['liveCode']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      performanceStartTime: DateTime.parse(json['performanceStartTime']),
      performanceEndTime: DateTime.parse(json['performanceEndTime']),
      restNextPerformanceStartTime: json['restNextPerformanceStartTime'] != null
          ? DateTime.parse(json['restNextPerformanceStartTime'])
          : null,
    );
  }
}
