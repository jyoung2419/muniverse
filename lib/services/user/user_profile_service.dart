import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../../models/user/user_profile_model.dart';
import 'package:path/path.dart' as path;

class UserProfileService {
  final Dio _dio;
  UserProfileService(this._dio);

  Future<UserProfileModel> getUserDetail() async {
    try {
      final res = await _dio.get('/api/v1/user/detail');
      return UserProfileModel.fromJson(res.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> patchUserProfile({
    required String userId,
    String? nickName,
    String? name,
    bool? localFlag,
    String? profileImagePath,
  }) async {
    final formData = FormData();

    formData.fields.add(MapEntry('userId', userId));
    if (nickName != null) formData.fields.add(MapEntry('nickName', nickName));
    if (name != null) formData.fields.add(MapEntry('name', name));
    if (localFlag != null) formData.fields.add(MapEntry('localFlag', localFlag.toString()));

    if (profileImagePath != null) {
      print('🖼 이미지 경로: $profileImagePath');
      final file = File(profileImagePath);
      final exists = await file.exists();
      print('📁 파일 존재 여부: $exists');

      if (exists) {
        final fileName = profileImagePath.split('/').last;
        final extension = path.extension(profileImagePath).replaceFirst('.', '').toLowerCase();
        final mimeType = {
          'jpg': MediaType('image', 'jpeg'),
          'jpeg': MediaType('image', 'jpeg'),
          'png': MediaType('image', 'png'),
        }[extension] ?? MediaType('image', 'jpeg'); // 기본값도 jpeg로

        final multipart = await MultipartFile.fromFile(
          profileImagePath,
          filename: fileName,
          contentType: mimeType,
        );

        formData.files.add(MapEntry('profileImage', multipart));
      }
    }

    // ✅ FormData 디버깅 로그
    formData.fields.forEach((f) => print('📦 field: ${f.key} = ${f.value}'));
    formData.files.forEach((f) => print('📎 file: ${f.key} = ${f.value.filename}'));

    try {
      await _dio.patch(
        '/api/v1/user/profile',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
    } catch (e) {
      rethrow;
    }
  }
}
