class EventLiveModel {
  final String liveCode;
  final String profileImageURL;
  final String name;
  final String content;
  final String status;
  final DateTime taskDateTime;
  final DateTime taskEndDateTime;

  EventLiveModel({
    required this.liveCode,
    required this.profileImageURL,
    required this.name,
    required this.content,
    required this.status,
    required this.taskDateTime,
    required this.taskEndDateTime,
  });

  factory EventLiveModel.fromJson(Map<String, dynamic> json) {
    return EventLiveModel(
      liveCode: json['liveCode']?.toString() ?? '',
      profileImageURL: json['profileImageURL']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      taskDateTime: DateTime.parse(json['taskDateTime']),
      taskEndDateTime: DateTime.parse(json['taskEndDateTime']),
    );
  }

}