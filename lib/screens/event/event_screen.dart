import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patrol_management_app/screens/event/event_live_tab.dart';
import '../../models/event/event_model.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/back_fab.dart';
import '../../widgets/common/header.dart';
import '../../widgets/common/dday_timer.dart';

import 'event_description_tab.dart';
import 'event_ticket_tab.dart';
import 'event_vod_tab.dart';
import 'event_vote_tab.dart';

class EventScreen extends StatelessWidget {
  final EventModel event;

  const EventScreen({super.key, required this.event});

  String getFormattedDateRange(DateTime start, DateTime end) {
    final formatter = DateFormat('yyyy.MM.dd (E)', 'ko');
    return '${formatter.format(start)} ~ ${formatter.format(end)}';
  }

  String getDDay(DateTime target) {
    final now = DateTime.now();
    final difference =
        target.difference(DateTime(now.year, now.month, now.day)).inDays;
    if (difference > 0) {
      return 'D-$difference';
    } else if (difference == 0) {
      return 'D-DAY';
    } else {
      return '종료됨';
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final showLiveTab = now.isBefore(event.openDateTime); // ✅ 라이브 탭 노출 여부

    final tabList = [
      const Tab(text: '상세정보'),
      const Tab(text: '상품'),
      const Tab(text: '투표'),
      if (showLiveTab) const Tab(text: '라이브'), // ✅ 조건부 추가
      const Tab(text: 'VOD'),
    ];

    final tabViews = [
      EventDescriptionTab(event: event),
      EventTicketTab(),
      EventVoteTab(event: event),
      if (showLiveTab) EventLiveTab(), // ✅ 조건부 추가
      EventVodTab(),
    ];

    return DefaultTabController(
      length: tabList.length,
      child: Scaffold(
        backgroundColor: const Color(0xFF171719),
        extendBodyBehindAppBar: true,
        appBar: const Header(),
        endDrawer: const AppDrawer(),
        floatingActionButton: const BackFAB(),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: kToolbarHeight),
                  BannerSection(
                    imagePath: event.bannerUrl,
                    title: event.name,
                    description: event.content,
                    startDate: event.openDateTime,
                    endDate: event.endDateTime,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: TabBar(
                      isScrollable: true,
                      tabAlignment: TabAlignment.center,
                      labelColor: Color(0xFF2EFFAA),
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
                      indicatorWeight: 0.1,
                      indicatorColor: const Color(0xFF2EFFAA),
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
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;

  const BannerSection({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.38,
          width: double.infinity,
          child: ClipRRect(child: Image.asset(imagePath, fit: BoxFit.cover)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            description,
            style: const TextStyle(color: Colors.white60, fontSize: 14),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: _buildStyledDate(startDate, endDate),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
          child: DateTime.now().isBefore(startDate)
              ? DdayTimer(target: startDate)
              : const SizedBox.shrink(), // D-day 대신 비움
        ),
      ],
    );
  }
}

Widget _buildStyledDate(DateTime start, DateTime end) {
  final dateFormat = DateFormat('yyyy.MM.dd', 'en');
  final dayFormat = DateFormat('EEE', 'en');

  final startDate = dateFormat.format(start);
  final startDay = dayFormat.format(start);
  final endDate = dateFormat.format(end);
  final endDay = dayFormat.format(end);

  return Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: '$startDate.',
          style: const TextStyle(
            color: Color(0xFF2EFFAA),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'NotoSans',
            height: 1.0,
          ),
        ),
        TextSpan(
          text: '$startDay (KST) ~ ',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'NotoSans',
            height: 1.0,
          ),
        ),
        TextSpan(
          text: '$endDate.',
          style: const TextStyle(
            color: Color(0xFF2EFFAA),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'NotoSans',
            height: 1.0,
          ),
        ),
        TextSpan(
          text: '$endDay',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'NotoSans',
            height: 1.0,
          ),
        ),
        TextSpan(
          text: ' (KST)',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'NotoSans',
            height: 1.0,
          ),
        ),
      ],
    ),
  );
}
