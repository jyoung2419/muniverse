import 'package:dio/dio.dart';
import '../../models/product/product_group_usd_model.dart';
import '../../utils/shared_prefs_util.dart';

class EventProductUSDService {
  final Dio _dio;

  EventProductUSDService(this._dio);

  Future<ProductGroupUSDModel> fetchEventProducts(String eventCode) async {
    final lang = await SharedPrefsUtil.getAcceptLanguage();

    final response = await _dio.get(
      '/api/v1/product/event/usd',
      queryParameters: {
        'eventCode': eventCode,
      },
      options: Options(
        headers: {
          'Accept-Language': lang,
        },
      ),
    );

    return ProductGroupUSDModel.fromJson(response.data);
  }
}
