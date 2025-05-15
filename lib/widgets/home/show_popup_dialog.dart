import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import '../../models/popup/popup_model.dart';
import '../../providers/language_provider.dart';
import '../../utils/shared_prefs_util.dart';
import '../common/translate_text.dart';

void showPopupDialog(BuildContext context, PopupListResponse popupList) {
  final lang = context.read<LanguageProvider>().selectedLanguageCode;

  if (popupList.textPopups.isNotEmpty) {
    final textPopup = popupList.textPopups.first;
    final content = lang == 'kr'
        ? textPopup.popupContent
        : (textPopup.popupContentEn ?? textPopup.popupContent);

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
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
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
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
                  await SharedPrefsUtil.setPopupHiddenUntilTomorrow();
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

  else if (popupList.imagePopups.isNotEmpty) {
    final imagePopup = popupList.imagePopups.first;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: Colors.white,
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
                      imagePopup.popupName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Image.network(imagePopup.popupImageUrl),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  await SharedPrefsUtil.setPopupHiddenUntilTomorrow();
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
}
