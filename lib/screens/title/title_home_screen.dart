import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'title_live_tab.dart';
import '../../models/event/event_model.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/back_fab.dart';
import '../../widgets/common/header.dart';
import '../../widgets/common/dday_timer.dart';

import 'title_description_tab.dart';
import 'title_ticket_tab.dart';
import 'title_vod_tab.dart';
import 'title_vote_tab.dart';

class TitleHomeScreen extends StatelessWidget {
  final EventModel event;

  const TitleHomeScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final showLiveTab = now.isAfter(event.openDateTime);

    final tabList = [
      const Tab(text: '상세정보'),
      const Tab(text: '상품'),
      const Tab(text: '투표'),
      if (showLiveTab) const Tab(text: '라이브'),
      const Tab(text: 'VOD'),
    ];

    final tabViews = [
      TitleDescriptionTab(event: event),
      TitleTicketTab(),
      TitleVoteTab(event: event),
      if (showLiveTab) TitleLiveTab(),
      TitleVodTab(),
    ];

    return DefaultTabController(
      length: tabList.length,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B0C0C),
        extendBodyBehindAppBar: true,
        appBar: const Header(),
        endDrawer: const AppDrawer(),
        floatingActionButton: const BackFAB(),
        body: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: kToolbarHeight),
                  BannerSection(
                    imagePath: event.bannerUrl,
                    performanceStartTime: event.performanceStartTime,
                  ),
                  const SizedBox(height: 10),
                  // ✅ 여기 핵심 적용
                  Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                      tabBarTheme: const TabBarTheme(
                        dividerColor: Colors.transparent,
                        overlayColor: MaterialStatePropertyAll(Colors.transparent),
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(width: 2, color: Color(0xFF2EFFAA)),
                          insets: EdgeInsets.symmetric(horizontal: 20),
                        ),
                      ),
                    ),
                    child: TabBar(
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabAlignment: TabAlignment.center,
                      labelColor: const Color(0xFF2EFFAA),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 20),
                      unselectedLabelColor: Colors.white60,
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0,
                      ),
                      tabs: tabList,
                    ),
                  ),
                ],
              ),
            ),
          ],
          body: TabBarView(children: tabViews),
        ),
      ),
    );
  }
}

class BannerSection extends StatelessWidget {
  final String imagePath;
  final DateTime performanceStartTime;

  const BannerSection({
    super.key,
    required this.imagePath,
    required this.performanceStartTime,
  });

  int getStreamingRound(DateTime now) {
    final diff = now.difference(performanceStartTime).inHours;
    if (diff < 0) return 1;
    return (diff ~/ 24) + 2;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isBeforePerformance = now.isBefore(performanceStartTime);
    final round = getStreamingRound(now);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.45,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(imagePath, fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.7)),
          if (isBeforePerformance || round <= 3)
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$round 회차 스트리밍까지 남은시간',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  DdayTimer(
                    target: performanceStartTime.add(Duration(hours: (round - 1) * 24)),
                    alignStart: true,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
