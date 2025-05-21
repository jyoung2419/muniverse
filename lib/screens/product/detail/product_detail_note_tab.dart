import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import '../../../providers/product/product_detail_provider.dart';

class ProductDetailNoteTab extends StatelessWidget {
  const ProductDetailNoteTab({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;
    final provider = context.watch<ProductDetailProvider>();

    final note = lang == 'kr'
        ? provider.krDetail?.note ?? ''
        : provider.usdDetail?.note ?? '';

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Html(
        data: note,
          style: {
            "*": Style(color: Colors.white),
            "body": Style(
              color: Colors.white70,
              lineHeight: LineHeight(1.2),
            ),
            "li": Style(color: Colors.white),
            "p": Style(color: Colors.white),
            "h1": Style(color: Colors.white, fontSize: FontSize(14), fontWeight: FontWeight.w600, margin: Margins.zero),
            "h2": Style(color: Colors.white, fontSize: FontSize(12), fontWeight: FontWeight.w600, margin: Margins.zero),
            "h3": Style(color: Colors.white, fontSize: FontSize(10), fontWeight: FontWeight.w600, margin: Margins.zero),
          }
      ),
    );
  }
}
