import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/flutter_html.dart' as html;
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import '../../../providers/product/product_detail_provider.dart';

class ProductDetailInfoTab extends StatelessWidget {
  const ProductDetailInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;
    final provider = context.watch<ProductDetailProvider>();

    final content = lang == 'kr'
        ? provider.krDetail?.content ?? ''
        : provider.usdDetail?.content ?? '';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Html(
        data: content,
        style: {
          "*": Style(color: Colors.white),
          "body": Style(color: Colors.white),
          "li": Style(color: Colors.white),
          "p": Style(color: Colors.white),
        },
        extensions: [
          html.TagExtension(
            tagsToExtend: {"img"},
            builder: (context) {
              final src = context.attributes['src'] ?? '';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Image.network(
                  src,
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context.buildContext!).size.width - 32, // 패딩 고려
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
