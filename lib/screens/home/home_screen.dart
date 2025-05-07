import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/event/main/event_main_provider.dart';
import '../../providers/event/main/event_main_vote_provider.dart';
import '../../providers/user/user_me_provider.dart';
import '../../utils/shared_prefs_util.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/header.dart';
import '../../widgets/home_related_video_section.dart';
import 'home_award.dart';
import 'home_banner_section.dart';
import 'home_event_profile_list.dart';
import 'home_award_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _printCurrentUserId();

    Future.microtask(() {
      context.read<EventMainProvider>().fetchMainEvents();
      context.read<EventMainVoteProvider>().fetchEventMainVotes();
      context.read<UserMeProvider>().fetchUserMe();
    });
  }
  Future<void> _printCurrentUserId() async {
    try {
      final userId = await SharedPrefsUtil.getUserId();
      print('🔥 현재 로그인한 유저 ID: $userId');
    } catch (e) {
      print('❌ 유저 ID 불러오기 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainVotes = context.watch<EventMainVoteProvider>().votes;
    final mainVote = mainVotes.isNotEmpty ? mainVotes.first : null;

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      extendBodyBehindAppBar: true,
      appBar: const Header(isHome: true),
      endDrawer: const AppDrawer(),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: kToolbarHeight),
            Stack(
              children: const [
                HomeBannerSection(),
                HomeEventProfileList(),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (mainVote != null) HomeAward(vote: mainVote),
                  const SizedBox(height: 24),
                  if (mainVote != null) HomeAwardSection(vote: mainVote),
                  const SizedBox(height: 40),
                  const HomeRelatedVideoSection(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
