import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../widgets/common/translate_text.dart';

class ProductCardBase extends StatelessWidget {
  final String eventName;
  final String productName;
  final String imageUrl;
  final String priceLabel;
  final bool isVod;
  final VoidCallback onPressed;
  final String buttonText;

  const ProductCardBase({
    super.key,
    required this.eventName,
    required this.productName,
    required this.imageUrl,
    required this.priceLabel,
    required this.isVod,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 176,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF212225),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x5270737C), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              width: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 12, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TranslatedText(
                        eventName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Html(
                        data: productName,
                        style: {
                          'body': Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                            fontSize: FontSize(14),
                            color: Colors.white,
                            maxLines: 2,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        priceLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isVod ? Colors.black : const Color(0xFF2EFFAA),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isVod ? 'VOD' : 'LIVE',
                          style: TextStyle(
                            color: isVod ? const Color(0xFF2EFFAA) : Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: onPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2EFFAA),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: const Size(60, 30),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          elevation: 0,
                        ),
                        child: Text(
                          buttonText,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
