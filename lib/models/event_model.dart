class EventModel {
  final int id;
  final String title;
  final String description;
  final String bannerImg;
  final DateTime startDate;
  final DateTime endDate;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.bannerImg,
    required this.startDate,
    required this.endDate,
  });
}
