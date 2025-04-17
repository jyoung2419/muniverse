import 'package:flutter/material.dart';

class PurchaseHistoryScreen extends StatelessWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171719),
      appBar: AppBar(
        title: const Text('구매 내역'),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text(
          '구매 내역이 없습니다.',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
