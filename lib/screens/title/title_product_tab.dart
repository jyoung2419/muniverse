import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product/product_live_kr_model.dart';
import '../../models/product/product_live_usd_model.dart';
import '../../models/product/product_vod_kr_model.dart';
import '../../models/product/product_vod_usd_model.dart';
import '../../providers/language_provider.dart';
import '../../providers/product/event_product_kr_provider.dart';
import '../../providers/product/event_product_usd_provider.dart';
import '../../widgets/common/translate_text.dart';
import '../../widgets/product/product_card_kr.dart';
import '../../widgets/product/product_card_usd.dart';

class TitleProductTab extends StatefulWidget {
  final String eventCode;

  const TitleProductTab({super.key, required this.eventCode});

  @override
  State<TitleProductTab> createState() => _TitleProductTabState();
}

class _TitleProductTabState extends State<TitleProductTab> {
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
          context.read<EventProductKRProvider>().loadProducts(widget.eventCode);
        } else {
          context.read<EventProductUSDProvider>().loadProducts(widget.eventCode);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;
    final isKR = lang == 'kr';

    if (isKR) {
      final krProvider = context.watch<EventProductKRProvider>();
      final products = krProvider.products;

      if (krProvider.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (krProvider.error != null) {
        return Center(child: Text('⚠️ 에러 발생: ${krProvider.error}', style: TextStyle(color: Colors.red)));
      }

      if (products == null || (products.vods.isEmpty && products.lives.isEmpty)) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: TranslatedText(
              '🎫 티켓 상품은 추후 추가될 예정입니다.\n조금만 기다려주세요!',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      final merged = [
        ...products.vods.map((vod) => {'type': 'VOD', 'product': vod}),
        ...products.lives.map((live) => {'type': 'LIVE', 'product': live}),
      ];

      return ListView.builder(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: merged.length + 1,
        itemBuilder: (context, index) {
          if (index == merged.length) return const SizedBox(height: 85);
          final item = merged[index];
          final product = item['product'];

          List<String> viewTypes;
          if (product is ProductVodKRModel) {
            if (product.isPackage) {
              viewTypes = product.categories;
            } else {
              viewTypes = product.categories.isNotEmpty ? [product.categories.first] : ['UNKNOWN'];
            }
          } else if (product is ProductLiveKRModel) {
            if (product.isPackage) {
              viewTypes = product.categories;
            } else {
              viewTypes = product.categories.isNotEmpty ? [product.categories.first] : ['UNKNOWN'];
            }
          } else {
            viewTypes = ['UNKNOWN'];
          }
          return ProductCardKR(
            product: product,
            viewTypes: viewTypes,
          );
        },
      );

    } else {
      final usdProvider = context.watch<EventProductUSDProvider>();
      final products = usdProvider.products;

      if (usdProvider.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (usdProvider.error != null) {
        return Center(child: Text('⚠️ 에러 발생: ${usdProvider.error}', style: TextStyle(color: Colors.red)));
      }

      if (products == null || (products.vods.isEmpty && products.lives.isEmpty)) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: TranslatedText(
              '🎫 티켓 상품은 추후 추가될 예정입니다.\n조금만 기다려주세요!',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      final merged = [
        ...products.vods.map((vod) => {'type': 'VOD', 'product': vod}),
        ...products.lives.map((live) => {'type': 'LIVE', 'product': live}),
      ];

      return ListView.builder(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: merged.length + 1,
        itemBuilder: (context, index) {
          if (index == merged.length) return const SizedBox(height: 85);
          final item = merged[index];
          final product = item['product'];

          List<String> viewTypes;
          if (product is ProductVodUSDModel) {
            if (product.isPackage) {
              viewTypes = product.categories;
            } else {
              viewTypes = product.categories.isNotEmpty ? [product.categories.first] : ['UNKNOWN'];
            }
          } else if (product is ProductLiveUSDModel) {
            if (product.isPackage) {
              viewTypes = product.categories;
            } else {
              viewTypes = product.categories.isNotEmpty ? [product.categories.first] : ['UNKNOWN'];
            }
          } else {
            viewTypes = ['UNKNOWN'];
          }          return ProductCardUSD(
            product: item['product'],
            viewTypes: viewTypes,
          );
        },
      );
    }
  }
}
