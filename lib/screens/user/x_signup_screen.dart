import 'package:flutter/material.dart';
import '../../services/page_control.dart';

class XSignUpScreen extends StatefulWidget {
  const XSignUpScreen({super.key});

  @override
  State<XSignUpScreen> createState() => _XSignUpScreenState();
}

class _XSignUpScreenState extends State<XSignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final String _name = "정진영";

  String? _nicknameMessage;
  bool _isNicknameAvailable = false;
  bool _nicknameChecked = false;
  String? _emailErrorText;
  String? _nicknameErrorText;

  void _checkNickname() {
    setState(() {
      _nicknameChecked = true;
      final nickname = _nicknameController.text.trim();

      if (nickname.isEmpty) {
        _nicknameErrorText = "닉네임을 입력해주세요.";
        _nicknameMessage = null;
        _isNicknameAvailable = false;
        return;
      }

      if (nickname == "usednickname") {
        _nicknameMessage = "중복된 닉네임입니다.";
        _isNicknameAvailable = false;
      } else {
        _nicknameMessage = "사용 가능한 닉네임입니다.";
        _isNicknameAvailable = true;
      }

      _nicknameErrorText = null;
    });
  }

  void _submitSignUp() {
    final email = _emailController.text.trim();
    final nickname = _nicknameController.text.trim();

    setState(() {
      _emailErrorText = email.isEmpty ? "이메일을 입력해주세요." : null;
      _nicknameErrorText = nickname.isEmpty ? "닉네임을 입력해주세요." : null;
    });

    if (email.isEmpty || nickname.isEmpty) return;

    if (!_nicknameChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("닉네임 중복 확인을 해주세요."),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    if (!_isNicknameAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("중복된 닉네임입니다."),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    // TODO: 서버 API로 회원가입 로직 처리

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("회원가입이 완료되었습니다."),
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pushReplacementNamed(context, '/login');
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
            _buildLabelWithAsterisk("이메일"),
            const SizedBox(height: 4),
            SizedBox(
              height: 45,
              child: TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                  hintText: '이메일 입력',
                  errorText: _emailErrorText,
                ),
              ),
            ),
            if (_emailErrorText != null)
              _buildErrorText(_emailErrorText!),

            const SizedBox(height: 16),
            const Text('이름', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 4),
            SizedBox(
              height: 45,
              child: TextFormField(
                initialValue: _name,
                enabled: false,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(),
              ),
            ),

            const SizedBox(height: 16),
            _buildLabelWithAsterisk("닉네임"),
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
                        errorText: _nicknameErrorText,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _checkNickname,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A1B9A),
                    elevation: 0,
                    minimumSize: const Size(80, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    '중복 확인',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
            if (_nicknameErrorText != null)
              _buildErrorText(_nicknameErrorText!),
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
                  backgroundColor: const Color(0xFF6A1B9A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '회원 가입',
                  style: TextStyle(
                    color: Colors.white,
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

  Widget _buildLabelWithAsterisk(String label) {
    return Row(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const Text(' *', style: TextStyle(color: Colors.red, fontSize: 18)),
      ],
    );
  }

  Widget _buildErrorText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: const TextStyle(color: Colors.redAccent, fontSize: 13),
      ),
    );
  }

  InputDecoration _inputDecoration({
    String? hintText,
    Color fillColor = const Color(0xFF2C2C2C),
    Color hintColor = Colors.white38,
    String? errorText,
  }) {
    return InputDecoration(
      hintText: hintText,
      errorText: null, // 기본 errorText는 null
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
