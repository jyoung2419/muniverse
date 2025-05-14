import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/reward/reward_user_info_model.dart';
import '../../providers/language_provider.dart';
import '../../providers/reward/reward_provider.dart';
import '../common/translate_text.dart';

class RewardFormModal extends StatefulWidget {
  final String rewardCode;
  const RewardFormModal({super.key, required this.rewardCode});

  @override
  State<RewardFormModal> createState() => _RewardFormModalState();
}

class _RewardFormModalState extends State<RewardFormModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  late bool isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final data = await Provider.of<RewardProvider>(context, listen: false)
          .fetchRewardUserInfo(widget.rewardCode);
      if (data['exists'] == true) {
        setState(() {
          isSubmitted = true;
          _nameController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? '';
          _phoneController.text = data['phone'] ?? '';
        });
      }
    } catch (e) {
      print('❌ 유저 정보 불러오기 실패: $e');
    }
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final model = RewardUserInfoModel(
        rewardCode: widget.rewardCode,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
      );

      try {
        await Provider.of<RewardProvider>(context, listen: false)
            .submitRewardUserInfo(model);
        print('✅ 제출 완료: ${model.toJson()}');
        Navigator.of(context).pop();
      } catch (e) {
        print('❌ 제출 실패: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('정보 제출에 실패했습니다.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context, listen: false).selectedLanguageCode;

    return Dialog(
      backgroundColor: const Color(0xFF121212),
      insetPadding: const EdgeInsets.symmetric(horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 36),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Center(
                        child: TranslatedText(
                          '당첨을 축하합니다!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Center(
                        child: TranslatedText(
                          '아래 정보를 입력해주세요.',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildTextField(_nameController, lang == 'kr' ? '이름' : 'Name'),
                      const SizedBox(height: 16),
                      _buildTextField(_emailController, lang == 'kr' ? '이메일' : 'Email'),
                      const SizedBox(height: 16),
                      _buildTextField(_phoneController, lang == 'kr' ? '전화번호' : 'Phone Number'),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isSubmitted
                              ? () => Navigator.of(context).pop()
                              : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2EFFAA),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: TranslatedText(
                            isSubmitted ? '확인' : '제출',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return TextFormField(
      controller: controller,
      readOnly: isSubmitted,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: const Color(0xFF1F1F1F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '필수 입력 항목입니다.';
        }
        return null;
      },
    );
  }
}