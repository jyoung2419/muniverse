import 'package:dio/dio.dart';
import '../../models/popup/popup_model.dart';

class PopupService {
  final Dio _dio;
  PopupService(this._dio);

  Future<PopupListResponse?> fetchPopupList() async {
    try {
      final response = await _dio.get('/api/v1/popup');
      return PopupListResponse.fromJson(response.data);
    } catch (e) {
      print('❌ 팝업 불러오기 실패: $e');
      return null;
    }
  }
}
