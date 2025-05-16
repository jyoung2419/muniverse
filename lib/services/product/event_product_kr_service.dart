import 'package:dio/dio.dart';
import '../../models/product/product_group_kr_model.dart';
import '../../utils/shared_prefs_util.dart';

class EventProductKRService {
  final Dio _dio;

  EventProductKRService(this._dio);

  Future<ProductGroupKRModel> fetchEventProducts(String eventCode) async {
    final lang = await SharedPrefsUtil.getAcceptLanguage();

    final response = await _dio.get(
      '/api/v1/product/event/kr',
      queryParameters: {
        'eventCode': eventCode,
      },
      options: Options(
        headers: {
          'Accept-Language': lang,
        },
      ),
    );

    return ProductGroupKRModel.fromJson(response.data);
  }
}
