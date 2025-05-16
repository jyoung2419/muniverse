import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';

class OrdererInfo extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  const OrdererInfo({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
  });

  InputDecoration _inputDecoration({
    required String hintText,
    Color fillColor = const Color(0xFF2C2C2C),
    Color hintColor = Colors.white38,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: hintColor, fontSize: 12),
      filled: true,
      fillColor: fillColor,
      isDense: true,
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
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;

    final nameHint = lang == 'kr' ? '이름' : 'name';
    final emailHint = lang == 'kr' ? '이메일' : 'email';
    final phoneHint = lang == 'kr' ? '전화번호' : 'phone number';

    return Column(
      children: [
        TextFormField(
          controller: nameController,
          style: const TextStyle(color: Colors.white),
          decoration: _inputDecoration(hintText: nameHint),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: emailController,
          style: const TextStyle(color: Colors.white),
          decoration: _inputDecoration(hintText: emailHint),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: phoneController,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.phone,
          decoration: _inputDecoration(hintText: phoneHint),
        ),
      ],
    );
  }
}
