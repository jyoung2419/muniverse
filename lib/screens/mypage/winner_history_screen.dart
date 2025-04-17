import 'package:flutter/material.dart';

class WinnerHistoryScreen extends StatelessWidget {
  const WinnerHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171719),
      appBar: AppBar(
        title: const Text('당첨 내역'),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text(
          '당첨된 내역이 없습니다.',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
