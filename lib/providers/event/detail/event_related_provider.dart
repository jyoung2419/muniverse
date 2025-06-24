import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/event/detail/event_related_model.dart';
import '../../../services/event/event_title_service.dart';
import '../../../utils/dio_client.dart';

final eventRelatedProvider = StateNotifierProvider.autoDispose<EventRelatedNotifier, EventRelatedState>((ref) {
  final dio = ref.watch(dioProvider);
  return EventRelatedNotifier(EventTitleService(dio));
});

class EventRelatedState {
  final List<EventRelatedModel> relatedVideos;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final bool isLastPage;

  const EventRelatedState({
    this.relatedVideos = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 0,
    this.isLastPage = false,
  });

  EventRelatedState copyWith({
    List<EventRelatedModel>? relatedVideos,
    bool? isLoading,
    String? error,
    int? currentPage,
    bool? isLastPage,
  }) {
    return EventRelatedState(
      relatedVideos: relatedVideos ?? this.relatedVideos,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }
}

class EventRelatedNotifier extends StateNotifier<EventRelatedState> {
  final EventTitleService _eventTitleService;

  EventRelatedNotifier(this._eventTitleService) : super(const EventRelatedState());

  Future<void> fetchNextPage(String eventCode, {int? eventYear}) async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);
    try {
      final data = await _eventTitleService.fetchEventRelatedVideos(
        eventCode,
        eventYear: eventYear,
        page: state.currentPage,
        size: 10,
      );
      final videos = data.map((e) => EventRelatedModel.fromJson(e)).toList();
      state = state.copyWith(
        relatedVideos: [...state.relatedVideos, ...videos],
        currentPage: state.currentPage + 1,
        isLoading: false,
        isLastPage: videos.isEmpty,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '❌ 관련 영상 추가 로드 실패');
    }
  }

  void clear() {
    state = const EventRelatedState();
  }
}
