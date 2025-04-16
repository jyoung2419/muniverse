abstract class BaseTicket {
  String get title;
  DateTime get date;
  String get imagePath;
  String get type; // 'VOD' 또는 'STREAMING'
}