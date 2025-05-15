import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/user/user_me_provider.dart';
import '../../providers/user/user_provider.dart';
import '../../screens/mypage/my_profile_screen.dart';
import '../../screens/mypage/ticket_management_screen.dart';
import '../../screens/mypage/reward_history_screen.dart';
import '../../screens/info/faq_screen.dart';
import '../../screens/info/notice_screen.dart';
import '../../screens/mypage/purchase_history_screen.dart';
import '../../screens/store/store_main_screen.dart';
import '../../screens/vote/vote_main_screen.dart';
import '../../services/user/user_service.dart';
import '../muniverse_logo.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _navigate(BuildContext context, Widget screen, String routeName) {
    Navigator.of(context).pop();
    Future.delayed(const Duration(milliseconds: 250), () {
      Navigator.of(context).push(
        PageRouteBuilder(
          settings: RouteSettings(name: routeName),
          pageBuilder: (_, __, ___) => screen,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final userMeProvider = context.watch<UserMeProvider>();
    final userNickName = userMeProvider.userMe?.userNickName ?? '사용자';
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;
    final titleMyPage = lang == 'kr' ? '마이페이지' : 'MY PAGE';
    final purchaseLabel = lang == 'kr' ? '구매 내역' : 'PURCHASE HISTORY';
    final passLabel = lang == 'kr' ? '보유 이용권' : 'MY PASS';
    final winnerLabel = lang == 'kr' ? '당첨 내역' : 'WINNER LIST';
    final profileLabel = lang == 'kr' ? '내 정보 조회' : 'MY PROFILE';
    final titleNotice = lang == 'kr' ? '공지사항' : 'NOTICE';
    final logoutText = lang == 'kr' ? '로그아웃' : 'LOGOUT';
    final greeting = lang == 'kr' ? '안녕하세요, $userNickName님!' : 'Hi, $userNickName!';

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: 270,
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.only(
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
                child: Row(
                  children: [
                    Expanded(
                      child: Consumer<UserMeProvider>(
                        builder: (context, userMeProvider, _) {
                          if (userMeProvider.isLoading) {
                            return const CircularProgressIndicator();
                          }
                          return Text(
                            greeting,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white24, height: 1),
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 20, 16, 6),
                      child: Text(
                        titleMyPage,
                        style: TextStyle(
                          color: Color(0xFF2EFFAA),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildItem(context, Icons.shopping_cart_outlined, purchaseLabel, const PurchaseHistoryScreen(), '/purchase', currentRoute),
                    _buildItem(context, Icons.subscriptions_outlined, passLabel, const TicketManagementScreen(), '/ticket', currentRoute),
                    _buildItem(context, Icons.event_note, winnerLabel, const RewardHistoryScreen(), '/winner', currentRoute),
                    _buildItem(context, Icons.person, profileLabel, const MyProfileScreen(), '/profile', currentRoute),
                    const Divider(color: Colors.white24, indent: 16, endIndent: 16),
                    _buildItem(context, Icons.announcement_outlined, titleNotice, const NoticeScreen(), '/notice', currentRoute),
                    _buildItem(context, Icons.help_outline, 'FAQ', const FAQScreen(), '/faq', currentRoute),
                    const Divider(color: Colors.white24, indent: 16, endIndent: 16),
                    _buildItem(context, Icons.how_to_vote, lang == 'kr' ? '투표' : 'VOTE', const VoteMainScreen(), '/voteMainScreen', currentRoute),
                    _buildItem(context, Icons.storefront, lang == 'kr' ? '스토어' : 'STORE', const StoreMainScreen(), '/storeMainScreen', currentRoute),
                  ],
                ),
              ),
              const Divider(color: Colors.white24, height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();

                    final userService = UserService();
                    await userService.logout();

                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false); // 로그인 화면으로 이동
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.redAccent, size: 20),
                      SizedBox(width: 10),
                      Text(
                        logoutText,
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

  Widget _buildItem(
      BuildContext context,
      IconData icon,
      String label,
      Widget screen,
      String routeName,
      String? currentRoute,
      ) {
    final isSelected = currentRoute == routeName;
    final textColor = isSelected ? const Color(0xFF2EFFAA) : Colors.white;
    final iconColor = isSelected ? const Color(0xFF2EFFAA) : Colors.white70;

    return InkWell(
      onTap: () => _navigate(context, screen, routeName),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
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