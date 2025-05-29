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

  static final ScrollController scrollController = ScrollController();

  static void scrollToTop() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

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

  List<Map<String, dynamic>> getMixedProducts(List vods, List lives) {
    final List<Map<String, dynamic>> result = [];
    final liveMap = {for (var live in lives) live.productCode: live};

    for (final vod in vods) {
      final code = vod.productCode;
      if (liveMap.containsKey(code)) {
        result.add({
          'type': vod.categories.isNotEmpty ? vod.categories : ['VOD', 'LIVE', 'PACKAGE'],
          'product': vod,
        });
        liveMap.remove(code);
      } else {
        result.add({
          'type': vod.categories.isNotEmpty ? vod.categories : ['VOD'],
          'product': vod,
        });
      }
    }

    for (final live in liveMap.values) {
      result.add({
        'type': live.categories.isNotEmpty ? live.categories : ['LIVE'],
        'product': live,
      });
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;
    final isKR = lang == 'kr';

    if (isKR) {
      final krProvider = context.watch<ProductKRProvider>();
      final products = getMixedProducts(krProvider.vods, krProvider.lives);

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
        controller: ProductMainTab.scrollController,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final item = products[index];
          return ProductCardKR(product: item['product'], viewTypes: item['type']);
        },
      );
    } else {
      final usdProvider = context.watch<ProductUSDProvider>();
      final products = getMixedProducts(usdProvider.vods, usdProvider.lives);

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
        controller: ProductMainTab.scrollController,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final item = products[index];
          return ProductCardUSD(product: item['product'], viewTypes: item['type']);
        },
      );
    }
  }
}
