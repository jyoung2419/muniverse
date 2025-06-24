import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../models/event/main/event_main_model.dart';
import '../../../services/event/event_main_service.dart';
import '../../../utils/dio_client.dart';

final eventMainProvider = StateNotifierProvider<EventMainNotifier, List<EventMainModel>>((ref) {
  final dio = DioClient().dio;
  return EventMainNotifier(dio);
});

class EventMainNotifier extends StateNotifier<List<EventMainModel>> {
  final EventMainService _eventService;

  EventMainNotifier(Dio dio) : _eventService = EventMainService(dio), super([]);

  Future<void> fetchMainEvents() async {
    try {
      final response = await _eventService.fetchMainEvents();
      state = response.map((e) => EventMainModel.fromJson(e)).toList();
    } catch (e) {
      print('❌ Error fetching main events: $e');
    }
  }

  EventMainModel? getEventByCode(String code) {
    return state.firstWhere((e) => e.eventCode == code, orElse: () => null as EventMainModel);
  }
}
