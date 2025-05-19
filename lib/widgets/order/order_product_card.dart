import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/language_provider.dart';
import '../common/translate_text.dart';

class OrderProductCard extends StatelessWidget {
  final String eventName;
  final String imageUrl;
  final String productName;
  final int quantity;
  final double totalPrice;

  const OrderProductCard({
    super.key,
    required this.eventName,
    required this.imageUrl,
    required this.productName,
    required this.quantity,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;
    final symbol = lang == 'kr' ? '₩' : '\$';
    final formattedTotal = lang == 'kr'
        ? '$symbol${NumberFormat('#,###').format(totalPrice)}'
        : '$symbol${totalPrice.toStringAsFixed(2)}';
    final totalLabel = lang == 'kr' ? '총 상품 금액' : 'Total';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 160,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TranslatedText(
                  '총 $quantity건',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                TranslatedText(
                  eventName,
                  style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  productName,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                const Divider(color: Colors.white12),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(totalLabel,
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      formattedTotal,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}