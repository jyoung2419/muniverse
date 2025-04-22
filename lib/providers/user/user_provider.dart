import 'package:flutter/material.dart';
import '../../models/user/user_model.dart';

class UserProvider with ChangeNotifier {
  final List<UserModel> _users = [
    UserModel(
      seq: 1,
      id: 'user001',
      password: 'password123',
      nickName: '뮤니',
      email: 'muniverse01@email.com',
      name: '김뮤니',
      phoneNumber: '01012345678',
      profileUrl: 'assets/images/user_profile.png',
      socialType: SocialType.GOOGLE,
      regisStatus: true,
      createDate: DateTime(2025, 4, 1),
      updateDate: null,
      deleteFlag: false,
    ),
    UserModel(
      seq: 2,
      id: 'user002',
      password: 'securepwd456',
      nickName: '우주',
      email: 'woojoo@email.com',
      name: '이우주',
      phoneNumber: '01087654321',
      profileUrl: 'assets/images/user_profile.png',
      socialType: SocialType.X,
      regisStatus: true,
      createDate: DateTime(2025, 4, 3),
      updateDate: DateTime(2025, 4, 10),
      deleteFlag: false,
    ),
  ];

  List<UserModel> get users => _users;

  UserModel? getUserById(String id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (_) {
      return null;
    }
  }
}
