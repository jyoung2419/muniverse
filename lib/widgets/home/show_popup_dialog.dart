import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../models/popup/popup_model.dart';

void showPopupDialog(BuildContext context, PopupListResponse popupList) {
  if (popupList.textPopups.isNotEmpty) {
    final textPopup = popupList.textPopups.first;

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
                    child: Text(
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
                data: textPopup.popupContent,
                style: {
                  'body': Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                    fontSize: FontSize(14),
                    color: Colors.black,
                  ),
                },
              ),
            ],
          ),
        ),
      ),
    );
  } else if (popupList.imagePopups.isNotEmpty) {
    final imagePopup = popupList.imagePopups.first;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 16, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                imagePopup.popupName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        content: Image.network(imagePopup.popupImageUrl),
      ),
    );
  }
}
