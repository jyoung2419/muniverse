import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/event/main/event_main_provider.dart';
import '../../providers/event/main/event_main_vote_provider.dart';
import '../../providers/popup/popup_provider.dart';
import '../../providers/user/user_me_provider.dart';
import '../../utils/shared_prefs_util.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/header.dart';
import '../../widgets/home/home_related_video_section.dart';
import '../../widgets/home/show_popup_dialog.dart';
import 'home_award.dart';
import '../../widgets/home/home_banner_section.dart';
import '../../widgets/home/home_award_section.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  @override
  @override
  void initState() {
    super.initState();
    _printCurrentUserId();

    Future.microtask(() async {
      ref.read(eventMainProvider.notifier).fetchMainEvents();
      ref.read(eventMainVoteProvider.notifier).fetchEventMainVotes();
      context.read<UserMeProvider>().fetchUserMe(); // 이건 provider 방식 유지

      final popupNotifier = ref.read(popupProvider.notifier);
      await popupNotifier.loadPopups();

      final popupState = ref.read(popupProvider);
      popupState.when(
        data: (popupList) async {
          if (popupList != null && !await SharedPrefsUtil.isPopupHiddenToday()) {
            showPopupDialog(context, popupList);
          }
        },
        loading: () {},
        error: (e, _) => print('❌ 팝업 로딩 실패: $e'),
      );
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
    final mainVotes = ref.watch(eventMainVoteProvider);
    final mainVote = mainVotes.isNotEmpty ? mainVotes.first : null;
    final allEvents = ref.watch(eventMainProvider);
    final opened = allEvents.where((e) => e.status != 'PRE_OPEN').toList();
    final upcoming = allEvents.where((e) => e.status == 'PRE_OPEN').toList();
    final filteredEvents = [...opened, ...upcoming];
    final matchingEvents = filteredEvents.take(7).toList();
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final appBarHeight = const Header(isHome: true).preferredSize.height;

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
            SizedBox(height: statusBarHeight + appBarHeight * 0.9),
            HomeBannerSection(events: matchingEvents),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  HomeAward(vote: mainVote),

                  if (mainVote != null) ...[
                    const SizedBox(height: 24),
                    HomeAwardSection(vote: mainVote),
                  ] else ...[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Color(0xFF1E1E1E)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '내 손으로 뽑는 글로벌 원픽!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '🎁 쇼음중 방청권 + MBC전광판 + 팬카페\n5/23(금) 10AM, 엠픽이 열린다!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
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
