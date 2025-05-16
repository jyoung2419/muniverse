import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product/product_vod_usd_model.dart';
import '../../providers/language_provider.dart';
import 'product_card_base.dart';

class ProductCardForMain extends StatelessWidget {
  final dynamic product;

  const ProductCardForMain({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isVod = product is ProductVodUSDModel;
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;
    final buyText = lang == 'kr' ? '구매하기' : 'BUY';
    return ProductCardBase(
      eventName: product.eventName ?? 'Unknown Event',
      productName: product.name,
      imageUrl: product.productImageUrl,
      priceLabel: '\$${(product.totalPrice ?? 0).toStringAsFixed(2)}',
      isVod: isVod,
      buttonText: buyText,
      onPressed: () {
        print('💰 메인화면 구매 클릭: ${product.productCode}');
      },
    );
  }
}
