import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/event/detail/event_vod_model.dart';
import '../../../services/event/event_title_service.dart';
import '../../../utils/dio_client.dart';

final eventVODProvider =
StateNotifierProvider.autoDispose<EventVODNotifier, List<EventVODModel>>((ref) {
  final dio = ref.watch(dioProvider);
  return EventVODNotifier(EventTitleService(dio));
});

class EventVODNotifier extends StateNotifier<List<EventVODModel>> {
  final EventTitleService _eventTitleService;

  EventVODNotifier(this._eventTitleService) : super([]);

  Future<void> fetchVODs(String eventCode, int? eventYear) async {
    try {
      List<EventVODModel> allVods = [];

      if (eventYear == null) {
        final years = [2025, 2024, 2023];
        for (final y in years) {
          final res = await _eventTitleService.fetchEventVODList(eventCode, y);
          allVods.addAll(res.map((json) => EventVODModel.fromJson(json)));
        }
      } else {
        final res = await _eventTitleService.fetchEventVODList(eventCode, eventYear);
        allVods = res.map((json) => EventVODModel.fromJson(json)).toList();
      }

      state = allVods;
    } catch (e) {
      print('❌ VOD 불러오기 실패: $e');
      rethrow;
    }
  }

  void clear() {
    state = [];
  }
}
