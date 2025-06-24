import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/event/detail/event_live_model.dart';
import '../../../services/event/event_title_service.dart';
import '../../../utils/dio_client.dart';

final eventLiveProvider = StateNotifierProvider.autoDispose<EventLiveNotifier, List<EventLiveModel>>((ref) {
  final dio = ref.watch(dioProvider);
  return EventLiveNotifier(EventTitleService(dio));
});

class EventLiveNotifier extends StateNotifier<List<EventLiveModel>> {
  final EventTitleService _eventTitleService;

  EventLiveNotifier(this._eventTitleService) : super([]);

  Future<void> fetchLives(String eventCode, int? eventYear) async {
    try {
      List<EventLiveModel> allLives = [];

      if (eventYear == null) {
        final years = [2025, 2024, 2023];
        for (final y in years) {
          final res = await _eventTitleService.fetchEventLiveList(eventCode, y);
          allLives.addAll(res.map((json) => EventLiveModel.fromJson(json)));
        }
      } else {
        final res = await _eventTitleService.fetchEventLiveList(eventCode, eventYear);
        allLives = res.map((json) => EventLiveModel.fromJson(json)).toList();
      }

      state = allLives;
    } catch (e) {
      print('❌ Live 불러오기 실패: $e');
      rethrow;
    }
  }

  void clear() {
    state = [];
  }
}
