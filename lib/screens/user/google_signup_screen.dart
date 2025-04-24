import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../services/page_control.dart';
import '../../services/user/google_oauth_service.dart';
import '../../services/user/user_validation_service.dart';
import '../../utils/shared_prefs_util.dart';

class GoogleSignUpScreen extends StatefulWidget {
  final String email;
  final String name;

  const GoogleSignUpScreen({
    super.key,
    required this.email,
    required this.name,
  });

  @override
  State<GoogleSignUpScreen> createState() => _GoogleSignUpScreenState();
}

class _GoogleSignUpScreenState extends State<GoogleSignUpScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final _validationService = UserValidationService();
  final _googleOauthService = GoogleOauthService();

  String? _nicknameMessage;
  String? _nicknameErrorText;
  bool _isNicknameAvailable = false;
  bool _nicknameChecked = false;

  void _checkNickname() async {
    final nickname = _nicknameController.text.trim();
    _nicknameChecked = true;

    setState(() {
      if (nickname.isEmpty) {
        _nicknameErrorText = "닉네임을 입력해주세요.";
        _nicknameMessage = null;
        _isNicknameAvailable = false;
        return;
      }
      _nicknameErrorText = null;
    });

    try {
      final result = await _validationService.checkNickname(nickname);
      final isDuplicate = result['duplicated'] == true;
      final message = result['message'] as String;

      setState(() {
        if (isDuplicate) {
          if (message == "허용되지 않은 닉네임 형식입니다.") {
            _nicknameMessage = "❌ 닉네임 형식이 올바르지 않습니다.";
          } else if (message == "이미 사용 중인 닉네임입니다.") {
            _nicknameMessage = "❌ 이미 사용 중인 닉네임입니다.";
          } else {
            _nicknameMessage = "❌ 사용 불가능한 닉네임입니다.";
          }
          _isNicknameAvailable = false;
        } else {
          _nicknameMessage = "✅ 사용 가능한 닉네임입니다.";
          _isNicknameAvailable = true;
        }
      });
    } catch (e) {
      print('❌ 예외 발생: $e');
      if (e is DioException) {
        print('서버 응답: ${e.response?.data}');
        print('상태 코드: ${e.response?.statusCode}');
      }

      setState(() {
        _nicknameMessage = "🚨 서버 오류가 발생했습니다.";
        _isNicknameAvailable = false;
      });
    }
  }

  void _submitSignUp() async {
    final nickname = _nicknameController.text.trim();

    if (nickname.isEmpty) {
      setState(() {
        _nicknameErrorText = "닉네임을 입력해주세요.";
      });
      return;
    }

    if (!_nicknameChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("닉네임 중복 확인을 해주세요.")),
      );
      return;
    }

    if (!_isNicknameAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_nicknameMessage ?? "사용할 수 없는 닉네임입니다.")),
      );
      return;
    }

    try {
      final userId = await SharedPrefsUtil.getUserId();

      await _googleOauthService.completeGoogleUserInfo(
        userId: userId,
        nickName: nickname,
        phoneNumber: '00000000000',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("회원가입이 완료되었습니다.")),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ 회원가입 실패: ${e.toString()}")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    print("email: ${widget.email}, name: ${widget.name}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          iconSize: 18,
          padding: const EdgeInsets.only(left: 12),
          onPressed: () => PageControl.back(context),
        ),
        title: const Text(
          '회원가입',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('이메일', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 4),
            SizedBox(
              height: 45,
              child: TextFormField(
                initialValue: widget.email,
                enabled: false,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(),
              ),
            ),
            const SizedBox(height: 16),

            const Text('이름', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 4),
            SizedBox(
              height: 45,
              child: TextFormField(
                initialValue: widget.name,
                enabled: false,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: const [
                Text('닉네임', style: TextStyle(color: Colors.white70)),
                Text(' *', style: TextStyle(color: Colors.red, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: TextField(
                      controller: _nicknameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration(
                        hintText: '닉네임 입력',
                        fillColor: const Color(0xFF2C2C2C),
                        hintColor: Colors.white38,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _checkNickname,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2EFFAA),
                    elevation: 0,
                    minimumSize: const Size(80, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    '중복 확인',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ],
            ),
            if (_nicknameErrorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _nicknameErrorText!,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                ),
              ),
            if (_nicknameMessage != null && _nicknameErrorText == null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _nicknameMessage!,
                  style: TextStyle(
                    color: _isNicknameAvailable ? Colors.green : Colors.redAccent,
                  ),
                ),
              ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2EFFAA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '회원 가입',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    String? hintText,
    Color fillColor = const Color(0xFF2C2C2C),
    Color hintColor = Colors.white38,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: hintColor, fontSize: 15),
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.white38),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    );
  }
}
