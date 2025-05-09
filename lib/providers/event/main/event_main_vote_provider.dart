import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../models/event/main/event_main_vote_model.dart';
import '../../../services/event/event_main_service.dart';

class EventMainVoteProvider with ChangeNotifier {
  List<EventMainVoteModel> _votes = [];

  List<EventMainVoteModel> get votes => _votes;

  final EventMainService _eventMainService;
  EventMainVoteProvider(Dio dio) : _eventMainService = EventMainService(dio);

  Future<void> fetchEventMainVotes() async {
    try {
      final List<Map<String, dynamic>> rawVotes = await _eventMainService.fetchEventMainVotes();
      _votes = rawVotes.map((e) => EventMainVoteModel.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      print('❌ Failed to fetch main votes: $e');
    }
  }
}
