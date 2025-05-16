import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderAmount extends StatelessWidget {
  final String lang;
  final double unitPrice;
  final String formattedTotalPrice;
  final int quantity;

  const OrderAmount({
    super.key,
    required this.lang,
    required this.unitPrice,
    required this.quantity,
    required this.formattedTotalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final fee = lang == 'kr' ? '₩ 1,400' : '\$ 1';
    final symbol = lang == 'kr' ? '₩' : '\$';
    final totalPrice = unitPrice * quantity;

    final totalText = lang == 'kr'
        ? '$symbol${NumberFormat('#,###').format(totalPrice)}'
        : '$symbol${totalPrice.toStringAsFixed(2)}';
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('상품금액', style: TextStyle(color: Colors.white, fontSize: 13)),
              Text(
                lang == 'kr'
                    ? '₩ ${NumberFormat('#,###').format(unitPrice)}'
                    : '\$ ${unitPrice.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('수수료', style: TextStyle(color: Colors.white, fontSize: 13)),
              Text(fee, style: const TextStyle(color: Colors.white, fontSize: 13)),
            ],
          ),
          const Divider(color: Colors.white12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('총 상품금액', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text(
                totalText,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
