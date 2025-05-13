import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import '../../providers/event/detail/event_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/translate_text.dart';
import 'title_related_video_tab.dart';
import 'title_live_tab.dart';
import '../../models/event/detail/event_model.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/back_fab.dart';
import '../../widgets/common/header.dart';
import '../../widgets/common/dday_timer.dart';

import 'title_description_tab.dart';
import 'title_ticket_tab.dart';
import 'title_vod_tab.dart';
import 'title_vote_tab.dart';

class TitleHomeScreen extends StatefulWidget {
  final String eventCode;

  const TitleHomeScreen({super.key, required this.eventCode});

  @override
  State<TitleHomeScreen> createState() => _TitleHomeScreenState();
}

class _TitleHomeScreenState extends State<TitleHomeScreen> {
  EventModel? event;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEvent();
  }

  Future<void> _fetchEvent() async {
    try {
      await context.read<EventProvider>().fetchAndAddEvent(widget.eventCode);
      final fetched = context.read<EventProvider>().getEventByCode(widget.eventCode);
      if (fetched != null) {
        setState(() {
          event = fetched;
          isLoading = false;
        });
      }
    } catch (_) {
      print('❌ 이벤트 불러오기 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || event == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final showLiveTab = ['BEFORE_OPEN', 'OPEN', 'PRE_OPEN', 'END'].contains(event!.status);

    final lang = context.watch<LanguageProvider>().selectedLanguageCode;

    final tabList = [
      Tab(text: lang == 'kr' ? '상세정보' : 'DETAILS'),
      Tab(text: lang == 'kr' ? '상품' : 'TICKETS'),
      Tab(text: lang == 'kr' ? '투표' : 'VOTE'),
      if (showLiveTab) Tab(text: lang == 'kr' ? '라이브' : 'LIVE'),
      Tab(text: lang == 'kr' ? 'VOD' : 'VOD'),
      Tab(text: lang == 'kr' ? '관련 영상' : 'RELATED VIDEO'),
    ];

    final tabViews = [
      TitleDescriptionTab(event: event!),
      TitleTicketTab(),
      TitleVoteTab(
        event: event!,
      ),
      if (showLiveTab)
        TitleLiveTab(
          eventCode: event!.eventCode,
          eventYear: event!.performanceStartTime.year,
        ),
      TitleVodTab(
        eventCode: event!.eventCode,
        eventYear: event!.performanceStartTime.year,
      ),
      TitleRelatedVideoTab(
        eventCode: event!.eventCode,
        eventYear: event!.performanceStartTime.year,
      ),
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
                    imagePath: event!.bannerUrl,
                    profileUrl: event!.profileUrl,
                    title: event!.name,
                    introContent: event!.introContent,
                    performanceStartTime: event!.performanceStartTime,
                    performanceEndTime: event!.performanceEndTime,
                  ),
                  const SizedBox(height: 10),
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
  final String profileUrl;
  final String title;
  final String introContent;
  final DateTime performanceStartTime;
  final DateTime performanceEndTime;

  const BannerSection({
    super.key,
    required this.imagePath,
    required this.profileUrl,
    required this.title,
    required this.introContent,
    required this.performanceStartTime,
    required this.performanceEndTime,
  });

  int getStreamingRound(DateTime now) {
    final diff = now.difference(performanceStartTime).inHours;
    if (diff < 0) return 1;
    return (diff ~/ 24) + 2;
  }

  static String _formatDate(DateTime dt) {
    return '${dt.year}.${_pad(dt.month)}.${_pad(dt.day)} ${_pad(dt.hour)}:${_pad(dt.minute)} (KST)';
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');

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
          Image.network(imagePath, fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.6)),

          Positioned(
            top: 80,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(profileUrl),
                        radius: 16,
                      ),
                      const SizedBox(width: 8),
                      TranslatedText(
                        title,
                        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TranslatedText(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TranslatedText(
                    introContent.replaceAll('<br>', '\n'),
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_formatDate(performanceStartTime)} ~ ${_formatDate(performanceEndTime)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (isBeforePerformance || round <= 3)
            Positioned(
              bottom: 10,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TranslatedText(
                    '$round 회차 스트리밍까지 남은시간',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
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
