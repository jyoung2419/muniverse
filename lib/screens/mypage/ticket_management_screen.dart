import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/ticket/user_pass_provider.dart';
import 'package:flutter/material.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/header.dart';
import '../../widgets/common/back_fab.dart';
import '../../widgets/common/translate_text.dart';
import '../../widgets/mypage/user_pass_card_list.dart';

class TicketManagementScreen extends StatefulWidget {
  const TicketManagementScreen({super.key});

  @override
  State<TicketManagementScreen> createState() => _TicketManagementScreenState();
}

class _TicketManagementScreenState extends State<TicketManagementScreen> {
  late final TextEditingController pinController;

  @override
  void initState() {
    super.initState();
    pinController = TextEditingController();
    Future.microtask(() {
      context.read<UserPassProvider>().fetchUserPasses();
    });
  }

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;
    final passes = context.watch<UserPassProvider>().userPasses;
    final pinController = TextEditingController();
    final isLoading = context.watch<UserPassProvider>().isLoading;

    final countText = lang == 'kr'
        ? '총 ${passes.length}건'
        : 'Total ${passes.length} Cases';
    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0C),
      appBar: const Header(),
      endDrawer: const AppDrawer(),
      floatingActionButton: const BackFAB(),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Text(
                  lang == 'kr' ? '보유 이용권' : 'TICKET',
                  style: const TextStyle(
                    color: Color(0xFF2EFFAA),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: pinController,
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
                  GestureDetector(
                    onTap: isLoading ? null : () async {
                      final pin = pinController.text.trim().toUpperCase();
                      final pinRegExp = RegExp(r'^\d{4}-\d{4}-\d{4}$');

                      if (pin.isEmpty) return;

                      if (!pinRegExp.hasMatch(pin)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                lang == 'kr' ? '올바른 형식의 핀 번호를 입력해주세요. (예: 1111-2222-3333)' : 'Please enter a valid PIN number. (e.g., 1111-2222-3333)',
                            ),
                            behavior: SnackBarBehavior.fixed,
                          ),
                        );
                        return;
                      }

                      try {
                        final provider = context.read<UserPassProvider>();
                        await provider.registerUserPass(pin);
                        pinController.clear();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              lang == 'kr'
                                  ? '이용권이 등록되었습니다.'
                                  : 'The ticket has been successfully registered.',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      } catch (e) {
                        final msg = e.toString().contains('이미 등록')
                            ? (lang == 'kr' ? '이미 등록된 이용권입니다.' : 'This ticket has already been registered.')
                            : (lang == 'kr' ? '등록 실패: $e' : 'Registration failed: $e');

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(msg),
                            behavior: SnackBarBehavior.fixed,
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF2EFFAA)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: isLoading
                            ? const SizedBox(
                          height: 10,
                          width: 10,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF2EFFAA)),
                        )
                            : Text(
                          lang == 'kr' ? '이용권 등록' : 'TICKET REGISTRATION',
                          style: const TextStyle(
                            color: Color(0xFF2EFFAA),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(countText,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 12),
              if (passes.isEmpty) ...[
                const Divider(color: Color(0xFF212225)),
                const SizedBox(height: 100),
                Center(
                  child: Text(
                    lang == 'kr' ? '현재 보유 중인 이용권이 없습니다.' : 'You currently have no tickets.',
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
