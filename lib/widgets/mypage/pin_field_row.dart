import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Clipboard 기능 사용
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart'; // lang 사용을 위한 import

class PinFieldRow extends StatelessWidget {
  const PinFieldRow({super.key});

  @override
  Widget build(BuildContext context) {
    const pinCode = 'XXXX-XXXX-XXXX';
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;
    final copyText = lang == 'kr' ? 'PIN 복사' : 'Copy PIN';
    final snackbarText = lang == 'kr' ? '복사되었습니다.' : 'Copied to clipboard.';

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
              child: const Text(
                pinCode,
                style: TextStyle(color: Color(0xFF353C49), fontSize: 12),
              ),
            ),
          ),
          const SizedBox(width: 10),
          OutlinedButton(
            onPressed: () {
              Clipboard.setData(const ClipboardData(text: pinCode));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(snackbarText),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white, width: 1),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              copyText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
