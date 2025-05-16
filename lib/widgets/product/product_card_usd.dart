import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product/product_vod_usd_model.dart';
import '../../providers/event/detail/event_provider.dart';
import 'product_card_base.dart';

class ProductCardUSD extends StatelessWidget {
  final dynamic product;
  final String eventCode;

  const ProductCardUSD({super.key, required this.product, required this.eventCode});

  @override
  Widget build(BuildContext context) {
    final eventName = context
        .read<EventProvider>()
        .getEventByCode(eventCode)
        ?.name ?? 'Unknown Event';

    return ProductCardBase(
      eventName: eventName,
      productName: product.name,
      imageUrl: product.productImageUrl,
      priceLabel: '\$${(product.totalPrice ?? 0).toStringAsFixed(2)}',
      isVod: product is ProductVodUSDModel,
      buttonText: 'BUY',
      onPressed: () {
        print('💰 USD 구매 클릭: ${product.productCode}');
      },
    );
  }
}
