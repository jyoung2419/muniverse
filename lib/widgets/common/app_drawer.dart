import 'package:flutter/material.dart';
import 'package:patrol_management_app/screens/mypage/ticket_management_screen.dart';
import 'package:patrol_management_app/screens/mypage/winner_history_screen.dart';
import '../../screens/info/faq_screen.dart';
import '../../screens/info/notice_screen.dart';
import '../../screens/mypage/purchase_history_screen.dart';
import '../muniverse_logo.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _navigate(BuildContext context, Widget screen) {
    Navigator.of(context).pop();
    Future.delayed(const Duration(milliseconds: 250), () {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => screen,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: 270,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 8),
                child: MuniverseLogo(),
              ),
              // 👤 사용자 정보
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  children: const [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage('assets/images/user_profile.png'),
                      backgroundColor: Colors.grey,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '안녕하세요, 정진영님!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white24, height: 1),
              Expanded(
                child: ListView(
                  children: [
                    _buildItem(context, Icons.shopping_cart_outlined, '구매 내역', const PurchaseHistoryScreen()),
                    _buildItem(context, Icons.subscriptions_outlined, '이용권 관리', const TicketManagementScreen()),
                    _buildItem(context, Icons.event_note, '당첨 내역', const WinnerHistoryScreen()),
                    const Divider(color: Colors.white24, indent: 16, endIndent: 16),
                    _buildItem(context, Icons.announcement_outlined, '공지사항', const NoticeScreen()),
                    _buildItem(context, Icons.help_outline, 'FAQ', const FAQScreen()),
                  ],
                ),
              ),
              const Divider(color: Colors.white24, height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: GestureDetector(
                  onTap: () {
                    // TODO: 로그아웃 처리
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.logout, color: Colors.redAccent, size: 20),
                      SizedBox(width: 10),
                      Text(
                        '로그아웃',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, IconData icon, String label, Widget screen) {
    return InkWell(
      onTap: () => _navigate(context, screen),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white38, size: 18),
          ],
        ),
      ),
    );
  }
}
