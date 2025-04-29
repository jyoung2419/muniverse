import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/vote/vote_detail_provider.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/back_fab.dart';
import '../../widgets/common/header.dart';
import '../vote/detail/vote_detail_info_tab.dart';
import '../vote/detail/vote_detail_progress_tab.dart';
import '../vote/detail/vote_detail_result_tab.dart';
import '../vote/detail/vote_detail_reward_tab.dart';

class VoteDetailScreen extends StatefulWidget {
  final String voteCode;
  final String eventName;
  const VoteDetailScreen({super.key, required this.voteCode, required this.eventName});

  @override
  State<VoteDetailScreen> createState() => _VoteDetailScreenState();
}

class _VoteDetailScreenState extends State<VoteDetailScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 1;
  final ScrollController _scrollController = ScrollController();
  bool _showTopButton = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVoteDetail();
    _scrollController.addListener(() {
      if (_scrollController.offset > 300 && !_showTopButton) {
        setState(() => _showTopButton = true);
      } else if (_scrollController.offset <= 300 && _showTopButton) {
        setState(() => _showTopButton = false);
      }
    });
  }

  Future<void> _fetchVoteDetail() async {
    await context.read<VoteDetailProvider>().fetchVoteDetail(widget.voteCode);
    final voteDetail = context.read<VoteDetailProvider>().voteDetail;
    final now = DateTime.now();
    final showRewardTab = now.isAfter(voteDetail!.detailContent.endTime);

    _tabController = TabController(
      length: showRewardTab ? 3 : 2,
      vsync: this,
      initialIndex: 1,
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
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
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF0B0C0C),
        appBar: const Header(),
        endDrawer: const AppDrawer(),
        floatingActionButton: const BackFAB(),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF2EFFAA)),
        ),
      );
    }

    final voteDetail = context.watch<VoteDetailProvider>().voteDetail;

    if (voteDetail == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0B0C0C),
        appBar: const Header(),
        endDrawer: const AppDrawer(),
        floatingActionButton: const BackFAB(),
        body: const Center(
          child: Text('데이터를 불러올 수 없습니다.', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    final vote = voteDetail.detailContent;
    final now = DateTime.now();
    final isRunning = now.isAfter(vote.startTime) && now.isBefore(vote.endTime);
    final isUpcoming = now.isBefore(vote.startTime);
    final isEnded = now.isAfter(vote.endTime);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0C),
      appBar: const Header(),
      endDrawer: const AppDrawer(),
      floatingActionButton: const BackFAB(),
      body: Stack(
        children: [
          RawScrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            radius: const Radius.circular(4),
            thickness: 6,
            thumbColor: const Color(0xFFD9D9D9),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      '투표',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  IntrinsicHeight(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF212225),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Stack(
                              children: [
                                Container(
                                  width: 170,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: (vote.voteImageUrl.isNotEmpty)
                                          ? NetworkImage(vote.voteImageUrl)
                                          : const AssetImage('assets/images/default_vote_image.png') as ImageProvider,                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                if (isRunning)
                                  _buildBadge('진행중', color: const Color(0xFF2EFFAA), textColor: Colors.black),
                                if (isRunning)
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8, left: 50),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.7),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.access_time_filled, color: Colors.white, size: 12),
                                            const SizedBox(width: 3),
                                            Text(
                                              '남은 투표기간 ${vote.voteRestDay}일',
                                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                if (isUpcoming)
                                  _buildBadge('투표 예정', color: const Color(0xFF2EFFAA), textColor: Colors.black),
                                if (isEnded)
                                  _buildBadge('종료', color: Colors.black.withOpacity(0.7), textColor: const Color(0xFF2EFFAA)),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.eventName,
                                        style: const TextStyle(fontSize: 12, color: Colors.white70),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        vote.voteName,
                                        style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '기간: ${DateFormat('yyyy.MM.dd').format(vote.startTime)} ~ ${DateFormat('yyyy.MM.dd').format(vote.endTime)}(KST)',
                                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: const BoxDecoration(color: Color(0xFF121212)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Icon(Icons.card_giftcard, size: 14, color: Colors.white),
                                            SizedBox(width: 4),
                                            Text('리워드', style: TextStyle(color: Colors.white, fontSize: 11)),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          voteDetail.rewards.isNotEmpty
                                              ? voteDetail.rewards.join(', ')
                                              : '리워드 정보 없음',
                                          style: const TextStyle(color: Colors.white, fontSize: 11),
                                        ),
                                      ],
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
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TabBar(
                      controller: _tabController,
                      onTap: (index) => setState(() => _currentTabIndex = index),
                      labelColor: const Color(0xFF2EFFAA),
                      unselectedLabelColor: Colors.white60,
                      indicatorColor: const Color(0xFF2EFFAA),
                      tabs: _tabController.length == 3
                          ? const [
                        Tab(text: '상세정보'),
                        Tab(text: '후보'),
                        Tab(text: '리워드'),
                      ]
                          : const [
                        Tab(text: '상세정보'),
                        Tab(text: '후보'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_currentTabIndex == 0) VoteDetailInfoTab(voteCode: widget.voteCode),
                  if (_currentTabIndex == 1)
                        () {
                      final now = DateTime.now();
                      if (now.isAfter(vote.startTime) && now.isBefore(vote.endTime)) {
                        return VoteDetailProgressTab(voteCode: widget.voteCode);
                      } else if (now.isAfter(vote.endTime)) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: Text(
                              '결과 집계중입니다!',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        );
                      } else {
                        return VoteDetailResultTab(voteCode: widget.voteCode);
                      }
                      return const SizedBox();
                    }(),
                  if (_currentTabIndex == 2 && _tabController.length == 3) VoteDetailRewardTab(voteCode: widget.voteCode),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          if (_showTopButton)
            Positioned(
              bottom: 40,
              right: 10,
              child: GestureDetector(
                onTap: _scrollToTop,
                child: SvgPicture.asset(
                  'assets/svg/scroll_top.svg',
                  width: 100,
                  height: 100,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text,
      {Alignment alignment = Alignment.topLeft,
        EdgeInsets padding = const EdgeInsets.only(top: 8, left: 8),
        Color color = Colors.black,
        Color textColor = Colors.white}) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}