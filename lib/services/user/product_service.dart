import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductService {
  final Dio _dio = Dio();

  ProductService() {
    final baseUrl = dotenv.env['BASE_URL']!;
    final port = dotenv.env['PORT'];
    final fullUrl = port != null ? '$baseUrl:$port' : baseUrl;
    _dio.options.baseUrl = fullUrl;
  }

  /// KR 상품 조회
  Future<Map<String, dynamic>> fetchKRProducts() async {
    try {
      final response = await _dio.get(
        '/api/v1/product/kr',
        options: Options(headers: {'Accept-Language': 'kr'}),
      );
      return response.data;
    } catch (e) {
      print('❌ KR Products API 호출 실패: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchUSDProducts({required String langHeader}) async {
    try {
      final response = await _dio.get(
        '/api/v1/product/usd',
        options: Options(headers: {'Accept-Language': langHeader}),
      );
      return response.data;
    } catch (e) {
      print('❌ USD Products API 호출 실패: $e');
      rethrow;
    }
  }
}
