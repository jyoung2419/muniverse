import 'package:dio/dio.dart';
import '../../utils/shared_prefs_util.dart';

class ProductDetailService {
  final Dio _dio;
  ProductDetailService(this._dio);

  Future<String> _getLangHeader() async {
    final lang = await SharedPrefsUtil.getAcceptLanguage();
    return lang == 'kr' ? 'kr' : 'en';
  }

  /// 상품 상세 조회 (KR)
  Future<Map<String, dynamic>> fetchKRProductDetail({
    required String productCode,
    required String viewType,
  }) async {
    try {
      final langHeader = await _getLangHeader();
      final response = await _dio.get(
        '/api/v1/product/detail/kr',
        queryParameters: {
          'productCode': productCode,
          'viewType': viewType,
        },
        options: Options(headers: {
          'Accept-Language': langHeader,
        }),
      );
      return response.data;
    } catch (e) {
      print('❌ KR 상품 상세 API 호출 실패: $e');
      rethrow;
    }
  }

  /// 상품 상세 조회 (USD)
  Future<Map<String, dynamic>> fetchUSDProductDetail({
    required String productCode,
    required String viewType,
  }) async {
    try {
      final langHeader = await _getLangHeader();
      final response = await _dio.get(
        '/api/v1/product/detail/usd',
        queryParameters: {
          'productCode': productCode,
          'viewType': viewType,
        },
        options: Options(headers: {
          'Accept-Language': langHeader,
        }),
      );
      return response.data;
    } catch (e) {
      print('❌ USD 상품 상세 API 호출 실패: $e');
      rethrow;
    }
  }
}
