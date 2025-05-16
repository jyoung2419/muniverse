import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/product/product_usd_provider.dart';
import '../../providers/product/product_kr_provider.dart';
import '../../widgets/common/translate_text.dart';
import '../../widgets/product/product_card_usd.dart';
import '../../widgets/product/product_card_kr.dart';

class ProductMainTab extends StatefulWidget {
  const ProductMainTab({super.key});

  @override
  State<ProductMainTab> createState() => _ProductMainTabState();
}

class _ProductMainTabState extends State<ProductMainTab> {
  String? _lastLang;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;

    if (!_initialized || _lastLang != lang) {
      _lastLang = lang;
      _initialized = true;

      Future.microtask(() {
        if (!mounted) return;
        if (lang == 'kr') {
          context.read<ProductKRProvider>().fetchProducts();
        } else {
          context.read<ProductUSDProvider>().fetchProducts();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;
    final isKR = lang == 'kr';

    if (isKR) {
      final krProvider = context.watch<ProductKRProvider>();
      final products = [...krProvider.vods, ...krProvider.lives];

      if (krProvider.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (krProvider.error != null) {
        return Center(child: Text('⚠️ 에러 발생: ${krProvider.error}', style: TextStyle(color: Colors.red)));
      }
      if (products.isEmpty) {
        return const Center(child: TranslatedText('상품이 없습니다.'));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) => ProductCardKR(product: products[index]),
      );
    } else {
      final usdProvider = context.watch<ProductUSDProvider>();
      final products = [...usdProvider.vods, ...usdProvider.lives];

      if (usdProvider.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (usdProvider.error != null) {
        return Center(child: Text('⚠️ 에러 발생: ${usdProvider.error}', style: TextStyle(color: Colors.red)));
      }
      if (products.isEmpty) {
        return const Center(child: TranslatedText('No products available.'));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) => ProductCardUSD(product: products[index]),
      );
    }
  }
}
