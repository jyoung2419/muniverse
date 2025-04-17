import 'package:flutter/material.dart';

class TicketManagementScreen extends StatelessWidget {
  const TicketManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171719),
      appBar: AppBar(
        title: const Text('이용권 관리'),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text(
          '보유한 이용권이 없습니다.',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
