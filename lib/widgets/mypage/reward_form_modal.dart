import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/reward/reward_user_info_model.dart';
import '../../providers/language_provider.dart';
import '../../providers/reward/reward_provider.dart';
import '../common/translate_text.dart';
import 'package:intl/intl.dart';

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
  String? _selectedSex;
  DateTime? _selectedBirthDate;
  late bool isSubmitted = false;
  bool _showValidationError = false;

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

          _selectedSex = data['sex'];
          if (data['birthDate'] != null) {
            _selectedBirthDate = DateTime.tryParse(data['birthDate']);
          }
        });
      }
    } catch (e) {
      print('❌ 유저 정보 불러오기 실패: $e');
    }
  }

  void _submit() async {
    setState(() {
      _showValidationError = true;
    });
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedSex == null || _selectedBirthDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('성별과 생년월일을 모두 입력해주세요.')),
        );
        return;
      }
      final model = RewardUserInfoModel(
        rewardCode: widget.rewardCode,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        sex: _selectedSex,
        birthDate: _selectedBirthDate!.toIso8601String().split('T').first,
      );

      try {
        await Provider.of<RewardProvider>(context, listen: false)
            .submitRewardUserInfo(model);
        final scaffoldContext = context;
        Navigator.of(context).pop();

        Future.delayed(const Duration(milliseconds: 100), () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('제출이 완료되었습니다.'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        });
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
      child: AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: MediaQuery.of(context).viewInsets,
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
                      _buildTextField(
                        controller: _nameController,
                        hintText: lang == 'kr' ? '이름' : 'Name',
                        fieldType: 'name',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _emailController,
                        hintText: lang == 'kr' ? '이메일' : 'Email',
                        fieldType: 'email',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _phoneController,
                        hintText: lang == 'kr' ? '전화번호' : 'Phone Number',
                        fieldType: 'phone',
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('남자', style: TextStyle(color: Colors.white)),
                              value: 'MAN',
                              activeColor: Color(0xFF2EFFAA),
                              groupValue: _selectedSex,
                              onChanged: isSubmitted
                                  ? (_) {}
                                  : (value) {
                                setState(() {
                                  _selectedSex = value;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('여자', style: TextStyle(color: Colors.white)),
                              value: 'WOMAN',
                              activeColor: Color(0xFF2EFFAA),
                              groupValue: _selectedSex,
                              onChanged: isSubmitted
                                  ? (_) {}
                                  : (value) {
                                setState(() {
                                  _selectedSex = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      if (_showValidationError && !isSubmitted && _selectedSex == null)
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('필수 입력 항목입니다.', style: TextStyle(color: Colors.red, fontSize: 12)),
                        ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: isSubmitted
                            ? null
                            : () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              _selectedBirthDate = picked;
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: _selectedBirthDate == null
                                  ? '생년월일을 선택해주세요'
                                  : DateFormat('yyyy-MM-dd').format(_selectedBirthDate!),
                              hintStyle: const TextStyle(color: Colors.white38),
                              filled: true,
                              fillColor: const Color(0xFF1F1F1F),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              errorStyle: const TextStyle(
                                color: Colors.red,
                                fontSize: 12
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (_showValidationError && !isSubmitted && _selectedBirthDate == null)
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('필수 입력 항목입니다.', style: TextStyle(color: Colors.red, fontSize: 12)),
                        ),
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String fieldType, // 'name', 'email', 'phone'
  }) {
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
        if (value == null || value.trim().isEmpty) return '필수 입력 항목입니다.';

        if (fieldType == 'phone') {
          final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
          if (!RegExp(r'^[0-9]{10,11}$').hasMatch(digitsOnly)) {
            return '유효한 전화번호를 입력하세요.';
          }
        }

        if (fieldType == 'email') {
          if (!RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
            return '유효한 이메일을 입력하세요.';
          }
        }

        return null;
      },
    );
  }
}