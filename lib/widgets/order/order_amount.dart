import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderAmount extends StatelessWidget {
  final String lang;
  final double price;
  final double fee;
  final double totalPrice;
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

    final priceLabel = lang == 'kr' ? '상품금액' : 'Product Price';
    final feeLabel = lang == 'kr' ? '수수료' : 'Fee';
    final totalLabel = lang == 'kr' ? '총 상품금액' : 'Total';

    return Column(
      children: [
        _buildRow(priceLabel, priceText, quantity),
        _buildRow(feeLabel, feeText, quantity),
        const SizedBox(height: 10),
        const Divider(color: Colors.white10, height: 1.0),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(totalLabel, style: const TextStyle(color: Colors.white)),
            Text(totalText, style: const TextStyle(color: Colors.white)),
          ],
        ),
        const SizedBox(height: 15),
        const Divider(color: Colors.white10, height: 1.0),
      ],
    );
  }

  Widget _buildRow(String label, String value, int quantity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          Row(
            children: [
              Text(value, style: const TextStyle(color: Colors.white)),
              const SizedBox(width: 4),
              Text('(x$quantity)', style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
