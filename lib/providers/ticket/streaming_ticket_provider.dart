import 'package:flutter/material.dart';
import '../../models/ticket/streaming_ticket_model.dart';

class StreamingTicketProvider with ChangeNotifier {
  List<StreamingTicket> _tickets = [];

  List<StreamingTicket> get tickets => _tickets;

  StreamingTicketProvider() {
    fetchDummyTickets();
  }

  void fetchDummyTickets() {
    _tickets = [
      StreamingTicket(
        streamingPinNumber: 'pin-001',
        useFlag: false,
        eventTitle: 'BIG 콘서트',
        eventDate: DateTime(2025, 6, 11),
        imagePath: 'assets/images/live.png',
      ),
      StreamingTicket(
        streamingPinNumber: 'pin-002',
        useFlag: false,
        eventTitle: 'K-POP 밴드 콘서트',
        eventDate: DateTime(2025, 6, 12),
        imagePath: 'assets/images/live.png',
      ),
      StreamingTicket(
        streamingPinNumber: 'pin-003',
        useFlag: false,
        eventTitle: 'BIG 콘서트',
        eventDate: DateTime(2025, 6, 13),
        imagePath: 'assets/images/live.png',
      ),
    ];
    notifyListeners();
  }
}
