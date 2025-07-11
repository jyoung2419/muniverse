import 'package:flutter/material.dart';
import '../common/dotted_divider.dart';
import '../common/translate_text.dart';

class ProductCard extends StatelessWidget {
  final String productName;
  final String productImageUrl;
  final int quantity;
  final double totalPriceForAmount;
  final String currency;
  final String? eventName;

  const ProductCard({
    super.key,
    required this.productName,
    required this.productImageUrl,
    required this.quantity,
    required this.totalPriceForAmount,
    required this.currency,
    required this.eventName,
  });

  @override
  Widget build(BuildContext context) {
    final unitPrice = (totalPriceForAmount / quantity).round();
    final totalPrice = totalPriceForAmount.round();

    return Row(
      children: [
        Container(
          width: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.network(
            productImageUrl,
            fit: BoxFit.fitWidth,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (eventName != null && eventName!.isNotEmpty)
                Text(
                  eventName!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 4),
              TranslatedText(
                productName,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '$currency$unitPrice',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              const DottedDivider(),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TranslatedText(
                    '총 상품금액 ($quantity개)',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '$currency$totalPrice',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}