import 'package:flutter/material.dart';
import '../common/dotted_divider.dart';

class ProductCard extends StatelessWidget {
  final String productName;
  final String productImageUrl;
  final int quantity;
  final double totalPriceForAmount;

  const ProductCard({
    super.key,
    required this.productName,
    required this.productImageUrl,
    required this.quantity,
    required this.totalPriceForAmount,
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
          child: Image.asset(
            productImageUrl,
            fit: BoxFit.fitWidth,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text( // eventName (하드코딩)
                'Muniverse Special Event',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                productName,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '₩$unitPrice',
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
                  Text(
                    '총 상품금액 ($quantity개)',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '₩$totalPrice',
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