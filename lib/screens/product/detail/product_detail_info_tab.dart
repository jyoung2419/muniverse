import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Html(
            data: content,
            style: {
              "body": Style(color: Colors.white),
              "li": Style(color: Colors.white),
              "p": Style(color: Colors.white),
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
