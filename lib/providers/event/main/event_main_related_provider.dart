import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../models/event/main/event_main_related_model.dart';
import '../../../services/event/event_main_service.dart';
import '../../../utils/dio_client.dart';

final eventMainRelatedProvider =
StateNotifierProvider<EventMainRelatedNotifier, AsyncValue<List<EventMainRelatedModel>>>((ref) {
  final dio = ref.watch(dioProvider);
  return EventMainRelatedNotifier(dio);
});

class EventMainRelatedNotifier extends StateNotifier<AsyncValue<List<EventMainRelatedModel>>> {
  final EventMainService _service;

  EventMainRelatedNotifier(Dio dio)
      : _service = EventMainService(dio),
        super(const AsyncLoading()) {
    fetch();
  }

  Future<void> fetch() async {
    try {
      final res = await _service.fetchMainRelatedVideos();
      state = AsyncData(res.map((e) => EventMainRelatedModel.fromJson(e)).toList());
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void clear() {
    state = const AsyncData([]);
  }
}
