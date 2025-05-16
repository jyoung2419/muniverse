import 'package:flutter/material.dart';
import 'product_card_base.dart';
import 'package:provider/provider.dart';
import '../../models/product/product_vod_kr_model.dart';
import '../../providers/event/detail/event_provider.dart';

class ProductCardKR extends StatelessWidget {
  final dynamic product;
  final String eventCode;

  const ProductCardKR({super.key, required this.product, required this.eventCode});

  @override
  Widget build(BuildContext context) {
    final eventName = context.read<EventProvider>().getEventByCode(eventCode)?.name ?? '이벤트명 없음';

    return ProductCardBase(
      eventName: eventName,
      productName: product.name,
      imageUrl: product.productImageUrl,
      priceLabel: '₩${product.totalPrice ?? 0}',
      isVod: product is ProductVodKRModel,
      buttonText: '구매하기',
      onPressed: () => print('구매: ${product.productCode}'),
    );
  }
}
