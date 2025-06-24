import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/event/main/event_main_vote_model.dart';
import '../../../services/event/event_main_service.dart';
import '../../../utils/dio_client.dart';

final eventMainVoteProvider =
StateNotifierProvider<EventMainVoteNotifier, List<EventMainVoteModel>>((ref) {
  final dio = ref.watch(dioProvider);
  return EventMainVoteNotifier(dio);
});

class EventMainVoteNotifier extends StateNotifier<List<EventMainVoteModel>> {
  final EventMainService _eventMainService;

  EventMainVoteNotifier(Dio dio)
      : _eventMainService = EventMainService(dio),
        super([]);

  Future<void> fetchEventMainVotes() async {
    try {
      final rawVotes = await _eventMainService.fetchEventMainVotes();
      state = rawVotes.map((e) => EventMainVoteModel.fromJson(e)).toList();
    } catch (e) {
      print('❌ Failed to fetch main votes: $e');
    }
  }
}
