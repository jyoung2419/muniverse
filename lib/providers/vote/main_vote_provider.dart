import 'package:flutter/material.dart';
import '../../models/vote/main_vote_model.dart';
import '../../services/event/event_main_service.dart';

class MainVoteProvider with ChangeNotifier {
  List<MainVoteModel> _votes = [];

  List<MainVoteModel> get votes => _votes;

  final EventMainService _eventMainService = EventMainService();

  Future<void> fetchMainVotes() async {
    try {
      final List<Map<String, dynamic>> rawVotes = await _eventMainService.fetchMainVotes();
      _votes = rawVotes.map((e) => MainVoteModel.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      print('❌ Failed to fetch main votes: $e');
    }
  }
}
