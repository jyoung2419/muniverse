import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:muniverse_app/screens/title/title_product_tab.dart';
import 'package:provider/provider.dart';
import '../../providers/event/detail/event_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/translate_text.dart';
import '../../widgets/home/banner_section.dart';
import 'title_related_video_tab.dart';
import 'title_live_tab.dart';
import '../../models/event/detail/event_model.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/back_fab.dart';
import '../../widgets/common/header.dart';
import '../../widgets/common/dday_timer.dart';

import 'title_description_tab.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool _showTopButton = false;

  @override
  void initState() {
    super.initState();
    _fetchEvent();

    _scrollController.addListener(() {
      if (_scrollController.offset > 300 && !_showTopButton) {
        setState(() => _showTopButton = true);
      } else if (_scrollController.offset <= 300 && _showTopButton) {
        setState(() => _showTopButton = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(covariant TitleHomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.eventCode != widget.eventCode) {
      setState(() {
        isLoading = true;
      });
      _fetchEvent();
    }
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

    final lang = context.watch<LanguageProvider>().selectedLanguageCode;

    final tabList = [
      Tab(text: lang == 'kr' ? '상세정보' : 'DETAILS'),
      Tab(text: lang == 'kr' ? '상품' : 'TICKETS'),
      Tab(text: lang == 'kr' ? '투표' : 'VOTE'),
      Tab(text: lang == 'kr' ? '라이브' : 'LIVE'),
      Tab(text: lang == 'kr' ? 'VOD' : 'VOD'),
      Tab(text: lang == 'kr' ? '관련 영상' : 'RELATED VIDEO'),
    ];

    final tabViews = [
      TitleDescriptionTab(
          event: event!
      ),
      TitleProductTab(
          eventCode: event!.eventCode
      ),
      TitleVoteTab(
        event: event!,
      ),
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
        appBar: Header(eventCode: widget.eventCode),
        endDrawer: const AppDrawer(),
        floatingActionButton: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: BackFAB(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                },
              ),
            ),
            if (_showTopButton)
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _scrollToTop,
                  child: SvgPicture.asset(
                    'assets/svg/scroll_top.svg',
                    width: 90,
                    height: 90,
                  ),
                ),
              ),
          ],
        ),
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, _) => [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: kToolbarHeight),
                  BannerSection(
                    imagePath: event!.bannerUrl ?? '',
                    profileUrl: event!.profileUrl ?? '',
                    title: event!.name ?? '제목 없음',
                    introContent: event!.introContent ?? '',
                    performanceStartTime: event!.performanceStartTime,
                    performanceEndTime: event!.performanceEndTime,
                    round: event!.round,
                    status: event!.status ?? 'UNKNOWN',
                    restNextPerformanceStartTime: event?.restNextPerformanceStartTime ?? DateTime.now(),
                  ),
                  const SizedBox(height: 10),
                  Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                      tabBarTheme: const TabBarTheme(
                        dividerColor: Colors.transparent,
                        overlayColor: WidgetStatePropertyAll(Colors.transparent),
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
