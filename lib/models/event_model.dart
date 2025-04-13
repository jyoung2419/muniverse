class EventModel {
  final int id;
  final String title;
  final String bannerImg; // 이미지 경로
  // 다른 필드들도 필요시 추가 가능

  const EventModel({
    required this.id,
    required this.title,
    required this.bannerImg,
  });
}
