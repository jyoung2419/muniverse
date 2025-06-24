import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/product/product_usd_provider.dart';
import '../../providers/product/product_kr_provider.dart';
import '../../widgets/common/translate_text.dart';
import '../../widgets/product/product_card_usd.dart';
import '../../widgets/product/product_card_kr.dart';

class ProductMainTab extends ConsumerStatefulWidget {
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
  ConsumerState<ProductMainTab> createState() => _ProductMainTabState();
}

class _ProductMainTabState extends ConsumerState<ProductMainTab> {
  String? _lastLang;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final lang = context.read<LanguageProvider>().selectedLanguageCode;

    if (!_initialized || _lastLang != lang) {
      _lastLang = lang;
      _initialized = true;

      Future.microtask(() {
        if (!mounted) return;
        if (lang == 'kr') {
          ref.read(productKRProvider.notifier).fetchProducts();
        } else {
          ref.read(productUSDProvider.notifier).fetchProducts();
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
      final krState = ref.watch(productKRProvider);
      final products = getMixedProducts(krState.vods, krState.lives);

      if (krState.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (krState.error != null) {
        return Center(child: Text('⚠️ 에러 발생: ${krState.error}', style: TextStyle(color: Colors.red)));
      }
      if (products.isEmpty) {
        return const Center(child: TranslatedText('상품이 없습니다.'));
      }

      return ListView.builder(
        controller: ProductMainTab.scrollController,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length + 1,
        itemBuilder: (context, index) {
          if (index == products.length) {
            return const SizedBox(height: 85);
          }
          final item = products[index];
          return ProductCardKR(product: item['product'], viewTypes: item['type']);
        },
      );
    } else {
      final usdState = ref.watch(productUSDProvider);
      final products = getMixedProducts(usdState.vods, usdState.lives);

      if (usdState.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (usdState.error != null) {
        return Center(child: Text('⚠️ 에러 발생: ${usdState.error}', style: TextStyle(color: Colors.red)));
      }
      if (products.isEmpty) {
        return const Center(child: TranslatedText('No products available.'));
      }

      return ListView.builder(
        controller: ProductMainTab.scrollController,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length + 1,
        itemBuilder: (context, index) {
          if (index == products.length) {
            return const SizedBox(height: 85);
          }
          final item = products[index];
          return ProductCardKR(product: item['product'], viewTypes: item['type']);
        },
      );
    }
  }
}
