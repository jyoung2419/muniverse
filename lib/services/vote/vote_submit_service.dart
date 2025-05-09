import 'package:dio/dio.dart';
import '../../models/vote/vote_response_model.dart';
import '../../utils/shared_prefs_util.dart';

class VoteSubmitService {
  final Dio _dio;

  VoteSubmitService(this._dio);

  Future<VoteResponseModel> submitVote({
    required String voteArtistSeq,
    required int voteRequestCount,
  }) async {
    final token = await SharedPrefsUtil.getAccessToken();

    try {
      final response = await _dio.post(
        '/api/v1/vote',
        data: {
          'voteArtistSeq': voteArtistSeq,
          'voteRequestCount': voteRequestCount,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      return VoteResponseModel.fromJson(response.data);
    } catch (e) {
      print('❌ Dio Exception: $e');
      rethrow;
    }
  }
}
