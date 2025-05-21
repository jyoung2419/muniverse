import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import '../../models/popup/popup_model.dart';
import '../../providers/language_provider.dart';
import '../../utils/shared_prefs_util.dart';
import '../common/translate_text.dart';

void showPopupDialog(BuildContext context, PopupListResponse popupList) async {
  final lang = context.read<LanguageProvider>().selectedLanguageCode;

  for (final textPopup in popupList.textPopups) {
    final key = 'text_${textPopup.popupTitle}';
    final isHidden = await SharedPrefsUtil.isPopupHiddenTodayWithKey(key);
    if (isHidden) continue;
    final content = lang == 'kr'
        ? textPopup.popupContent
        : (textPopup.popupContentEn ?? textPopup.popupContent);

    await showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TranslatedText(
                      textPopup.popupTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Html(
                data: content,
                style: {
                  'body': Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                    fontSize: FontSize(14),
                    color: Colors.black,
                  ),
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  await SharedPrefsUtil.setPopupHiddenUntilTomorrowWithKey(key);
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    lang == 'kr' ? '오늘 하루 보지 않기' : "Don't show again today",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      decoration: TextDecoration.underline,
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

  for (int i = 0; i < popupList.imagePopups.length; i++) {
    final imagePopup = popupList.imagePopups[i];
    final key = 'popup_hidden_${imagePopup.popupName}';

    final isHidden = await SharedPrefsUtil.isPopupHiddenTodayWithKey(key);
    if (isHidden) continue;
    final result = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context, true); // 팝업 닫고 true 리턴
                Navigator.pushNamed(context, '/voteMainScreen');
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imagePopup.popupImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    await SharedPrefsUtil.setPopupHiddenUntilTomorrowWithKey(key);
                    Navigator.pop(context, false);
                  },
                  child: const Text(
                    '오늘 하루 보지 않기',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white70,
                    ),
                  ),
                ),
                const SizedBox(width: 60),
                GestureDetector(
                  onTap: () => Navigator.pop(context, false),
                  child: const Text(
                    '닫기',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (result == true) {
      break;
    }
  }
}
