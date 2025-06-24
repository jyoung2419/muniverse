import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../models/event/main/event_nav_model.dart';
import '../../../services/event/event_main_service.dart';
import '../../../utils/dio_client.dart';

final eventNavProvider =
StateNotifierProvider<EventNavNotifier, AsyncValue<List<EventNavModel>>>((ref) {
  final dio = ref.watch(dioProvider);
  return EventNavNotifier(dio);
});

class EventNavNotifier extends StateNotifier<AsyncValue<List<EventNavModel>>> {
  final EventMainService _service;

  EventNavNotifier(Dio dio)
      : _service = EventMainService(dio),
        super(const AsyncLoading()) {
    fetch();
  }

  Future<void> fetch() async {
    try {
      final result = await _service.fetchEventNavList();
      state = AsyncData(result);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void clear() {
    state = const AsyncData([]);
  }
}
