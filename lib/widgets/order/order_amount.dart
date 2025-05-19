import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderAmount extends StatelessWidget {
  final String lang;
  final double price;        // 단가
  final double fee;          // 단가 수수료
  final double totalPrice;   // 이미 곱해진 총합
  final int quantity;

  const OrderAmount({
    super.key,
    required this.lang,
    required this.price,
    required this.fee,
    required this.totalPrice,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final symbol = lang == 'kr' ? '₩' : '\$';
    final priceText = lang == 'kr'
        ? '$symbol${NumberFormat('#,###').format(price)}'
        : '$symbol${price.toStringAsFixed(2)}';
    final feeText = lang == 'kr'
        ? '$symbol${NumberFormat('#,###').format(fee)}'
        : '$symbol${fee.toStringAsFixed(2)}';
    final totalText = lang == 'kr'
        ? '$symbol${NumberFormat('#,###').format(totalPrice)}'
        : '$symbol${totalPrice.toStringAsFixed(2)}';

    final priceLabel = lang == 'kr' ? '상품 금액' : 'Product Price';
    final feeLabel = lang == 'kr' ? '수수료' : 'Fee';
    final totalLabel = lang == 'kr' ? '총 상품 금액' : 'Total';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(priceLabel, style: TextStyle(color: Colors.white, fontSize: 13)),
            Row(
              children: [
                Text(priceText, style: const TextStyle(color: Colors.white, fontSize: 13)),
                const SizedBox(width: 4),
                Text('(x$quantity)', style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(feeLabel, style: TextStyle(color: Colors.white, fontSize: 13)),
            Row(
              children: [
                Text(feeText, style: const TextStyle(color: Colors.white, fontSize: 13)),
                const SizedBox(width: 4),
                Text('(x$quantity)', style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ],
        ),
        const Divider(color: Colors.white12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(totalLabel, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(
              totalText,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
