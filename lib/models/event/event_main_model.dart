class EventMainModel {
  final String eventCode;
  final String cardUrl;
  final String status;

  const EventMainModel({
    required this.eventCode,
    required this.cardUrl,
    required this.status,
  });

  factory EventMainModel.fromJson(Map<String, dynamic> json) {
    return EventMainModel(
      eventCode: json['eventCode'] ?? '',
      cardUrl: json['cardImageURL'] ?? '',
      status: json['eventStatus'] ?? '',
    );
  }
}