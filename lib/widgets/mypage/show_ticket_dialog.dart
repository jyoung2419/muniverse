import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/translation_provider.dart';

Future<bool?> showTicketDialog(
    BuildContext context, {
      required String message,
      bool isError = false,
    }) async {
  final lang = Provider.of<LanguageProvider>(context, listen: false).selectedLanguageCode;
  final translationProvider = Provider.of<TranslationProvider>(context, listen: false);
  final translatedMessage = await translationProvider.translate(message);
  final title = lang == 'kr' ? '이용권 등록' : 'Ticket Registration';

  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: const EdgeInsets.fromLTRB(24, 20, 12, 16),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 25, 16, 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            translatedMessage,
            style: TextStyle(
              color: isError ? Colors.red : Colors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 45),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2EFFAA),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                lang == 'kr' ? '확인' : 'OK',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
