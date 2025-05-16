import 'package:flutter/material.dart';
import '../../screens/product/product_detail_screen.dart';
import 'product_card_base.dart';
import '../../models/product/product_vod_kr_model.dart';

class ProductCardKR extends StatelessWidget {
  final dynamic product;

  const ProductCardKR({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isVod = product is ProductVodKRModel;
    final viewType = isVod ? 'VOD' : 'LIVE';

    return ProductCardBase(
      eventName: product.eventName,
      productName: product.name,
      imageUrl: product.productImageUrl,
      priceLabel: '₩${product.totalPrice.toStringAsFixed(0)}',
      isVod: isVod,
      buttonText: '구매하기',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(
              productCode: product.productCode,
              viewType: viewType,
              eventName: product.eventName,
            ),
          ),
        );
      },
    );
  }
}
