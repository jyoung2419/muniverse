import 'package:flutter/material.dart';
import '../common/translate_text.dart';

class RewardExpiredDialog extends StatelessWidget {
  const RewardExpiredDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const TranslatedText(
        '입력 기간 종료',
        style: TextStyle(
          color: Color(0xFF2EFFAA),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const TranslatedText(
        '정보 입력 기간이 종료되었습니다.',
        style: TextStyle(color: Colors.white70, fontSize: 14),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: const Color(0xFF2EFFAA),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const TranslatedText(
            '확인',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
