class EventMainRelatedModel {
  final String eventShortName;
  final String eventCode;
  final int sequence;
  final List<EventMainRelatedDetailModel> relatedDetails;

  EventMainRelatedModel._({
    required this.eventShortName,
    required this.eventCode,
    required this.sequence,
    required this.relatedDetails,
  });

  factory EventMainRelatedModel.fromJson(Map<String, dynamic> json) {
    final related = (json['relatedDetails'] as List<dynamic>?)
        ?.map((e) => EventMainRelatedDetailModel.fromJson(e))
        .toList() ?? [];

    return EventMainRelatedModel._(
      eventShortName: json['eventShortName'] ?? '',
      eventCode: json['eventCode'] ?? '',
      sequence: json['sequence'] ?? 0,
      relatedDetails: related,
    );
  }
}

class EventMainRelatedDetailModel {
  final String name;
  final String profileImageUrl;
  final String videoUrl;

  EventMainRelatedDetailModel({
    required this.name,
    required this.profileImageUrl,
    required this.videoUrl,
  });

  factory EventMainRelatedDetailModel.fromJson(Map<String, dynamic> json) {
    return EventMainRelatedDetailModel(
      name: json['relatedVideoName'] ?? '',
      profileImageUrl: json['relatedVideoProfileImageUrl'] ?? '',
      videoUrl: json['relatedVideoUrl'] ?? '',
    );
  }
}
