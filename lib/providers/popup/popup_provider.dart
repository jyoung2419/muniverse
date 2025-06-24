import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../models/popup/popup_model.dart';
import '../../services/popup/popup_service.dart';
import '../../utils/dio_client.dart';

final popupProvider = StateNotifierProvider<PopupNotifier, AsyncValue<PopupListResponse?>>((ref) {
  final dio = ref.watch(dioProvider);
  return PopupNotifier(dio);
});

class PopupNotifier extends StateNotifier<AsyncValue<PopupListResponse?>> {
  final PopupService _popupService;
  bool _isLoaded = false;

  PopupNotifier(Dio dio)
      : _popupService = PopupService(dio),
        super(const AsyncLoading());

  Future<void> loadPopups() async {
    if (_isLoaded) return; // 이미 로딩한 경우 skip
    try {
      final result = await _popupService.fetchPopupList();
      state = AsyncData(result);
      _isLoaded = true;
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
