import 'package:flutter/material.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/header.dart';
import '../../widgets/common/back_fab.dart';
import '../../widgets/common/translate_text.dart';

class WinnerHistoryScreen extends StatelessWidget {
  const WinnerHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0C),
      appBar: const Header(),
      endDrawer: const AppDrawer(),
      floatingActionButton: const BackFAB(),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.only(top: kToolbarHeight + 24),
          child: TranslatedText(
            '당첨된 내역이 없습니다.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
