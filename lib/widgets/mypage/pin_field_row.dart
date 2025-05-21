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
    final snackbarText = lang == 'kr' ? '복사되었습니다.' : 'Copied to clipboard.';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(5)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                pinCode,
                style: const TextStyle(
                  color: Color(0xFFEFEFEF),
                  fontSize: 13,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: pinCode));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(snackbarText),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: const Icon(Icons.copy, color: Color(0xFF2EFFAA), size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
