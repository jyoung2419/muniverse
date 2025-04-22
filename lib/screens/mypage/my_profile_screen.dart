import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user/user_provider.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/back_fab.dart';
import '../../widgets/common/header.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  late TextEditingController _nicknameController;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().getUserById('user001'); // 실제 로그인 ID로 대체 예정
    _nicknameController = TextEditingController(text: user?.nickName ?? '');
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().getUserById('user001');

    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0C),
      appBar: const Header(),
      endDrawer: const AppDrawer(),
      floatingActionButton: const BackFAB(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Center(
              child: Text(
                '내 정보 조회',
                style: TextStyle(
                  color: Color(0xFF2EFFAA),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // 프로필 이미지 + 버튼
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: user?.profileUrl != null
                            ? AssetImage(user!.profileUrl!)
                            : const AssetImage('assets/images/user_profile.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: 사진 등록 로직
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      backgroundColor: Color(0xFF0B0C0C),
                      side: const BorderSide(color: Colors.white70, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '사진 등록',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 이메일
            _buildLabel('이메일'),
            const SizedBox(height: 5),
            _buildReadOnlyField(user?.email ?? ''),
            const SizedBox(height: 20),

            // 이름
            _buildLabel('이름'),
            const SizedBox(height: 5),
            _buildReadOnlyField(user?.name ?? ''),
            const SizedBox(height: 20),

            // 닉네임
            _buildLabel('닉네임'),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nicknameController,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: _inputDecoration(),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () {
                    // TODO: 중복 확인 로직
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    backgroundColor: Color(0xFF0B0C0C),
                    side: const BorderSide(color: Colors.white70, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '중복 확인',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
              ],
            ),

            const SizedBox(height: 40),

            // 하단 버튼
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Color(0xFF212225),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        ),
                    ),
                    child: const Text(
                      '취소',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: 저장 로직
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2EFFAA),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '저장',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String value) {
    return TextFormField(
      initialValue: value,
      enabled: false,
      style: const TextStyle(color: Color(0xFF353C49), fontSize: 13),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF212225),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none, // 선 제거
        ),
      ),
    );
  }


  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF0B0C0C),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white12),
      ),
    );
  }
}
