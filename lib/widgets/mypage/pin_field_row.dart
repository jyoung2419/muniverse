import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';

class PinFieldRow extends StatelessWidget {
  final String pinCode;

  const PinFieldRow({super.key, required this.pinCode});

  @override
  Widget build(BuildContext context) {
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
              child: Text(
                pinCode,
                style: const TextStyle(color: Color(0xFF353C49), fontSize: 12),
              ),
            ),
          ),
          const SizedBox(width: 10),
          OutlinedButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: pinCode));
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
