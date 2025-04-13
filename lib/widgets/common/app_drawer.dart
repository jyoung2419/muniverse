import 'package:flutter/material.dart';
import '../../screens/info/faq_screen.dart';
import '../../screens/info/notice_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _navigate(BuildContext context, Widget screen) {
    Navigator.of(context).pop(); // 🔹 Drawer 닫기 먼저

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
        width: 260,
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              offset: const Offset(-2, 0),
              blurRadius: 6,
            )
          ],
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF2E2E2E),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/images/user_profile.png'),
                    backgroundColor: Colors.grey,
                  ),
                  SizedBox(width: 12),
                  Text(
                    '안녕하세요, 정진영님!',
                    //Text('안녕하세요, ${user.nickname}님!')
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            _buildItem(context, Icons.shopping_cart, '구매 내역', Placeholder()),
            _buildItem(context, Icons.card_membership, '이용권 관리', Placeholder()),
            _buildItem(context, Icons.event, '이벤트 내역', Placeholder()),
            _buildItem(context, Icons.announcement, '공지사항', const NoticeScreen()),
            _buildItem(context, Icons.help_outline, 'FAQ', const FAQScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, IconData icon, String label, Widget screen) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 20),
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () => _navigate(context, screen),
    );
  }
}
