import 'package:flutter/material.dart';
import '../../widgets/common/translate_text.dart';

class TitleTicketTab extends StatelessWidget {
  const TitleTicketTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: TranslatedText(
          '🎫 티켓 상품은 추후 추가될 예정입니다.\n조금만 기다려주세요!',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
