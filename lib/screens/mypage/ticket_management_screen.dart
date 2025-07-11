import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/ticket/user_pass_provider.dart';
import 'package:flutter/material.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/header.dart';
import '../../widgets/common/back_fab.dart';
import '../../widgets/common/translate_text.dart';
import '../../widgets/mypage/user_pass_card_list.dart';
import '../../widgets/mypage/show_ticket_dialog.dart';

class TicketManagementScreen extends StatefulWidget {
  const TicketManagementScreen({super.key});

  @override
  State<TicketManagementScreen> createState() => _TicketManagementScreenState();
}

class _TicketManagementScreenState extends State<TicketManagementScreen> {
  late final TextEditingController pinController;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    pinController = TextEditingController();
    Future.microtask(() {
      context.read<UserPassProvider>().fetchUserPasses();
    });
    _scrollController = ScrollController();
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
        controller: _scrollController,
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
                        hintText: 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX',
                        hintStyle: TextStyle(color: Colors.white54, fontSize: 12),
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
                      final pin = pinController.text.trim();
                      final pinRegExp = RegExp(r'^[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$');

                      if (pin.isEmpty) return;

                      if (!pinRegExp.hasMatch(pin)) {
                        await showTicketDialog(
                          context,
                          message: '등록번호를 다시 확인해주세요.',
                          isError: true,
                        );
                        return;
                      }

                      try {
                        final provider = context.read<UserPassProvider>();
                        await provider.registerUserPass(pin);
                        pinController.clear();

                        await showTicketDialog(
                          context,
                          message: '이용권이 등록되었습니다.',
                        );
                      } catch (e) {
                        String msg;

                        if (e is DioException) {
                          final statusCode = e.response?.statusCode;

                          if (statusCode == 500) {
                            msg = '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
                          } else {
                            msg = e.response?.data['message'] ?? '등록에 실패했습니다.';
                          }
                        } else {
                          msg = '알 수 없는 오류가 발생했습니다.';
                        }

                        await showTicketDialog(
                          context,
                          message: msg,
                          isError: true,
                        );
                      }

                    },
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  child: TranslatedText('현재 보유 중인 이용권이 없습니다.',
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
