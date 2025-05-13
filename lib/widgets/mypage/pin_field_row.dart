import 'package:flutter/material.dart';

import '../common/translate_text.dart';

class PinFieldRow extends StatelessWidget {
  const PinFieldRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF212225),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.centerLeft,
              child: const Text('XXXX-XXXX-XXXX', style: TextStyle(color: Color(0xFF353C49), fontSize: 12)),
            ),
          ),
          const SizedBox(width: 10),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white, width: 1),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: TranslatedText(
              'PIN 복사',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    ); // 지금 _buildPinFieldRow 내용
  }
}
