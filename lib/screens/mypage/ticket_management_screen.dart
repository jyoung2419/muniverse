import 'package:provider/provider.dart';
import '../../providers/ticket/user_pass_provider.dart';
import 'package:flutter/material.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/header.dart';
import '../../widgets/common/back_fab.dart';
import '../../widgets/common/translate_text.dart';
import '../../widgets/mypage/user_pass_card_list.dart';

class TicketManagementScreen extends StatelessWidget {
  const TicketManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final passes = context.watch<UserPassProvider>().passes;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0C),
      appBar: const Header(),
      endDrawer: const AppDrawer(),
      floatingActionButton: const BackFAB(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Center(
                child: TranslatedText(
                  '보유 이용권',
                  style: TextStyle(
                    color: Color(0xFF2EFFAA),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'XXXX-XXXX-XXXX',
                        hintStyle: TextStyle(color: Colors.white54, fontSize: 16),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF2EFFAA)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: TranslatedText(
                        '이용권 등록',
                        style: TextStyle(
                          color: Color(0xFF2EFFAA),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              if (passes.isEmpty) ...[
                const Divider(color: Color(0xFF212225)),
                const SizedBox(height: 100),
                const Center(
                  child: TranslatedText(
                    '이용권을 등록해 주세요.',
                    style: TextStyle(color: Color(0xFF6D7582)),
                  ),
                ),
                const SizedBox(height: 100),
                const Divider(color: Color(0xFF212225)),
              ] else ...[
                UserPassCardList(passes: passes),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
