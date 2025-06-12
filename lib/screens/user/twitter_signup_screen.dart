import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../services/page_control.dart';
import '../../services/user/twitter_oauth_service.dart';
import '../../services/user/user_validation_service.dart';
import '../../utils/shared_prefs_util.dart';

class TwitterSignUpScreen extends StatefulWidget {
  final String userId;
  final String name;

  const TwitterSignUpScreen({
    super.key,
    required this.userId,
    required this.name,
  });

  @override
  State<TwitterSignUpScreen> createState() => _TwitterSignUpScreenState();
}

class _TwitterSignUpScreenState extends State<TwitterSignUpScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _validationService = UserValidationService();
  final _twitterOauthService = TwitterOauthService();

  String? _nicknameMessage;
  String? _nicknameErrorText;
  bool _isNicknameAvailable = false;
  bool _nicknameChecked = false;

  bool _emailChecked = false;
  bool _isEmailAvailable = false;
  String? _emailMessage;
  String? _emailErrorText;

  bool? _isLocalFlag = false;

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
      }
      setState(() {
        _nicknameMessage = "🚨 서버 오류가 발생했습니다.";
        _isNicknameAvailable = false;
      });
    }
  }

  void _checkEmail() async {
    final email = _emailController.text.trim();
    _emailChecked = true;

    setState(() {
      if (email.isEmpty) {
        _emailErrorText = "이메일을 입력해주세요.";
        _emailMessage = null;
        _isEmailAvailable = false;
        return;
      }
      _emailErrorText = null;
    });

    try {
      final result = await _validationService.checkEmail(email);
      final isDuplicate = result['duplicated'] == true;

      setState(() {
        if (isDuplicate) {
          _emailMessage = "❌ 이미 사용 중인 이메일입니다.";
          _isEmailAvailable = false;
        } else {
          _emailMessage = "✅ 사용 가능한 이메일입니다.";
          _isEmailAvailable = true;
        }
      });
    } catch (e) {
      setState(() {
        _emailMessage = "🚨 서버 오류가 발생했습니다.";
        _isEmailAvailable = false;
      });
    }
  }

  void _submitSignUp() async {
    final nickname = _nicknameController.text.trim();
    final email = _emailController.text.trim();

    if (nickname.isEmpty) {
      setState(() {
        _nicknameErrorText = "닉네임을 입력해주세요.";
      });
      return;
    }
    if (!_nicknameChecked) {
      _showSnackBar("닉네임 중복 확인을 해주세요.");
      return;
    }
    if (!_isNicknameAvailable) {
      _showSnackBar(_nicknameMessage ?? "사용할 수 없는 닉네임입니다.");
      return;
    }
    if (!_emailChecked) {
      _showSnackBar("이메일 중복 확인을 해주세요.");
      return;
    }

    if (!_isEmailAvailable) {
      _showSnackBar(_emailMessage ?? "사용할 수 없는 이메일입니다.");
      return;
    }
    if (_isLocalFlag == null) {
      _showSnackBar("거주지를 선택해주세요.");
      return;
    }

    try {
      final userId = await SharedPrefsUtil.getUserId();

      await _twitterOauthService.completeTwitterUserInfo(
        userId: userId,
        nickName: nickname,
        email: email,
        isLocalFlag: _isLocalFlag!,
      );

      _showSnackBar("회원가입이 완료되었습니다.");
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      _showSnackBar("❌ 회원가입 실패: ${e.toString()}");
    }
  }

  void _showSnackBar(String message, {int duration = 2}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: duration),
      ),
    );
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
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: TextField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration(
                        hintText: '이메일 입력',
                        fillColor: const Color(0xFF2C2C2C),
                        hintColor: Colors.white38,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _emailChecked = false;
                          _isEmailAvailable = false;
                          _emailMessage = null;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _checkEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    minimumSize: const Size(80, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: Color(0xFF2EFFAA),
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: const Text(
                    '중복 확인',
                    style: TextStyle(color: Color(0xFF2EFFAA)),
                  ),
                ),
              ],
            ),
            if (_emailErrorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _emailErrorText!,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                ),
              ),
            if (_emailMessage != null && _emailErrorText == null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _emailMessage!,
                  style: TextStyle(
                    color: _isEmailAvailable ? Colors.green : Colors.redAccent,
                  ),
                ),
              ),
            const SizedBox(height: 16),
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
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    initialValue: widget.name,
                    enabled: false,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
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
              ],
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
                      onChanged: (value) {
                        setState(() {
                          _nicknameChecked = false;
                          _isNicknameAvailable = false;
                          _nicknameMessage = null;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _checkNickname,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    minimumSize: const Size(80, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: Color(0xFF2EFFAA),
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: const Text(
                    '중복 확인',
                    style: TextStyle(color: Color(0xFF2EFFAA)),
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

  Widget _buildLabel(String text) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: const TextStyle(color: Colors.white70, fontSize: 14),
    ),
  );

  Widget _buildToggleButton(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
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
