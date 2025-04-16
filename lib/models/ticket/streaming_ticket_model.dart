import 'base_ticket.dart';

class StreamingTicket extends BaseTicket {
  final String streamingPinNumber;
  final bool useFlag;
  final String eventTitle;
  final DateTime eventDate;
  final String imagePath;

  StreamingTicket({
    required this.streamingPinNumber,
    required this.useFlag,
    required this.eventTitle,
    required this.eventDate,
    required this.imagePath,
  });

  @override
  String get title => eventTitle;

  @override
  DateTime get date => eventDate;

  @override
  String get type => 'STREAMING';
}
