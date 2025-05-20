import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import '../../providers/language_provider.dart';
import '../../providers/user/user_profile_provider.dart';
import '../../services/user/user_validation_service.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/back_fab.dart';
import '../../widgets/common/header.dart';
import '../../widgets/common/translate_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  TextEditingController? _nicknameController;
  String? _originalNickname;
  String? _nicknameMessage;
  bool _isNicknameAvailable = false;
  final _validationService = UserValidationService();
  final ImagePicker _picker = ImagePicker();
  String? _imagePath;
  bool? _isLocalFlag;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final dir = await getTemporaryDirectory();
      final targetPath = path.join(dir.path, 'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        image.path,
        targetPath,
        quality: 85,
        minWidth: 800,
        minHeight: 800,
        format: CompressFormat.jpeg,
      );

      if (compressedFile != null) {
        final file = File(compressedFile.path);
        print('📏 압축된 이미지 크기: ${(file.lengthSync() / 1024 / 1024).toStringAsFixed(2)} MB');

        setState(() {
          _imagePath = compressedFile.path;
        });
      } else {
        print('❌ 이미지 압축 실패');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<UserProfileProvider>();
      await provider.fetchUserDetail();
      final user = provider.user;
      _originalNickname = user?.nickname ?? '';
      _nicknameController = TextEditingController(text: _originalNickname);
      _nicknameController?.addListener(() {
        if (_nicknameController!.text.trim() != _originalNickname) {
          setState(() {
            _isNicknameAvailable = false;
            _nicknameMessage = null;
          });
        }
      });

      _isLocalFlag = user?.localFlag ?? false;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nicknameController?.dispose();
    super.dispose();
  }

  Future<void> _checkNickname() async {
    final nickname = _nicknameController?.text.trim() ?? '';
    if (nickname.isEmpty) {
      setState(() {
        _nicknameMessage = '닉네임을 입력해주세요.';
        _isNicknameAvailable = false;
      });
      return;
    }

    try {
      final result = await _validationService.checkNickname(nickname);
      final isDuplicate = result['duplicated'] == true;
      final message = result['message'] as String;

      setState(() {
        if (isDuplicate) {
          _nicknameMessage = message.contains('형식')
              ? "❌ 닉네임 형식이 올바르지 않습니다."
              : "❌ ${message}";
          _isNicknameAvailable = false;
        } else {
          _nicknameMessage = "✅ 사용 가능한 닉네임입니다.";
          _isNicknameAvailable = true;
        }
      });
    } catch (e) {
      setState(() {
        _nicknameMessage = "🚨 서버 오류가 발생했습니다.";
        _isNicknameAvailable = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    final provider = context.read<UserProfileProvider>();
    final user = provider.user;
    final newNickname = _nicknameController?.text.trim();

    if (newNickname == null || newNickname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❗ 닉네임을 입력해주세요.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (newNickname != _originalNickname && !_isNicknameAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❗ 닉네임 중복 확인을 해주세요.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      await provider.updateUserProfile(
        userId: user!.id,
        nickname: newNickname,
        profileImagePath: _imagePath,
        localFlag: _isLocalFlag,
      );

      await provider.fetchUserDetail();

      final updatedUser = provider.user;
      setState(() {
        _nicknameController?.text = updatedUser?.nickname ?? '';
        _imagePath = null;
        _isNicknameAvailable = false;
        _nicknameMessage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ 수정 완료'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🚨 수정 실패. 이미지 형식 또는 서버 오류입니다.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<UserProfileProvider>().user;
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0C),
      appBar: const Header(),
      endDrawer: const AppDrawer(),
      floatingActionButton: const BackFAB(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: userProfile == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Center(
              child: Text(
                lang == 'kr' ? '내 정보 조회' : 'MY INFO',
                style: const TextStyle(
                  color: Color(0xFF2EFFAA),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: _imagePath != null
                            ? FileImage(File(_imagePath!))
                            : userProfile.profileUrl != null
                            ? NetworkImage(userProfile.profileUrl!)
                            : const AssetImage('assets/images/user_profile.png')
                        as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      backgroundColor: const Color(0xFF0B0C0C),
                      side: const BorderSide(color: Color(0xFF2EFFAA), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const TranslatedText(
                      '사진 등록',
                      style: TextStyle(color: Color(0xFF2EFFAA), fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildLabel('이메일'),
            const SizedBox(height: 5),
            _buildReadOnlyField(userProfile.email),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(flex: 3, child: _buildLabel('이름')),
                const SizedBox(width: 10),
                Expanded(flex: 2, child: _buildLabel('거주지')),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(flex: 3,
                  child: _buildReadOnlyField(userProfile.name),
                ),
                const SizedBox(width: 10),
                Expanded(flex: 2,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildToggleButton('국내', _isLocalFlag == false, () {
                            setState(() {
                              _isLocalFlag = false;
                            });
                          }),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _buildToggleButton('국외', _isLocalFlag == true, () {
                            setState(() {
                              _isLocalFlag = true;
                            });
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                  onPressed: _checkNickname,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    backgroundColor: Color(0xFF0B0C0C),
                    side: const BorderSide(color: Colors.white70, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const TranslatedText(
                    '중복 확인',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            if (_nicknameMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _nicknameMessage!,
                  style: TextStyle(
                    color: _isNicknameAvailable ? Colors.green : Colors.redAccent,
                  ),
                ),
              ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Color(0xFF212225),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const TranslatedText(
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
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2EFFAA),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const TranslatedText('저장',
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Align(
    alignment: Alignment.centerLeft,
    child: TranslatedText(
      text,
      style: const TextStyle(color: Colors.white70, fontSize: 14),
    ),
  );

  Widget _buildReadOnlyField(String value) => TextFormField(
    initialValue: value,
    enabled: false,
    style: const TextStyle(color: Color(0xFF353C49), fontSize: 13),
    decoration: InputDecoration(
      filled: true,
      fillColor: const Color(0xFF212225),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
  );

  InputDecoration _inputDecoration() => InputDecoration(
    filled: true,
    fillColor: const Color(0xFF0B0C0C),
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.white12),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.white12),
    ),
  );

  Widget _buildToggleButton(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF2EFFAA) : Colors.white,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? const Color(0xFF2EFFAA) : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
