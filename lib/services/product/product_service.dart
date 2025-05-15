import 'package:dio/dio.dart';

class ProductService {
  final Dio _dio;
  ProductService(this._dio);

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
        options: Options(headers: {'Accept-Language': 'kr'}),
      );
      return response.data;
    } catch (e) {
      print('❌ USD Products API 호출 실패: $e');
      rethrow;
    }
  }
}
