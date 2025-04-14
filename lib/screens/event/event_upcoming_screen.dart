import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/event_model.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/back_fab.dart';
import '../../widgets/common/header.dart';
import '../../widgets/common/dday_timer.dart';
import 'package:google_fonts/google_fonts.dart';

import 'event_vote_tab.dart';

class EventUpcomingScreen extends StatelessWidget {
  final EventModel event;

  const EventUpcomingScreen({super.key, required this.event});

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
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFF111111),
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
                    imagePath: event.bannerImg,
                    title: event.title,
                    description: event.description,
                    startDate: event.startDate,
                    endDate: event.endDate,
                    targetDate: event.startDate,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: TabBar(
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      labelColor: Colors.white,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 15),
                      unselectedLabelColor: Colors.white60,
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0,
                      ),

                      tabs: const [
                        Tab(text: '설명'),
                        Tab(text: '라인업'),
                        Tab(text: '투표'),
                        Tab(text: 'VOD'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
    body: SizedBox( // ✅ 높이 제한 추가
      height: MediaQuery.of(context).size.height * 0.5,
      child: const TabBarView(
        children: [
          Center(child: Text('설명 탭', style: TextStyle(color: Colors.white))),
          Center(child: Text('LINE UP 탭', style: TextStyle(color: Colors.white))),
          EventVoteTab(),
          Center(child: Text('VOD 탭', style: TextStyle(color: Colors.white))),
        ],
      ),
    ),
        ),
      ),);
  }
}

class BannerSection extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime targetDate;

  const BannerSection({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.targetDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.48,
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
          child: DdayTimer(target: targetDate),
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
            color: Color(0xFF9B51E0),
            fontSize: 22,
            fontWeight: FontWeight.w400,
            fontFamily: 'NotoSans',
            height: 1.0,
          ),
        ),
        TextSpan(
          text: '$startDay ~ ',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w400,
            fontFamily: 'NotoSans',
            height: 1.0,
          ),
        ),
        TextSpan(
          text: '$endDate.',
          style: const TextStyle(
            color: Color(0xFF9B51E0),
            fontSize: 22,
            fontWeight: FontWeight.w400,
            fontFamily: 'NotoSans',
            height: 1.0,
          ),
        ),
        TextSpan(
          text: '$endDay',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w400,
            fontFamily: 'NotoSans',
            height: 1.0,
          ),
        ),
      ],
    ),
  );
}
