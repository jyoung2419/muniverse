import 'package:flutter/material.dart';
import '../../models/vote/vote_model.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/back_fab.dart';
import '../../widgets/common/header.dart';
import '../../widgets/vote/vote_detail_info_tab.dart';
import '../../widgets/vote/vote_detail_progress_tab.dart';
import '../../widgets/vote/vote_detail_reward_tab.dart';

class VoteDetailScreen extends StatefulWidget {
  final VoteModel vote;
  const VoteDetailScreen({super.key, required this.vote});

  @override
  State<VoteDetailScreen> createState() => _VoteDetailScreen();
}

class _VoteDetailScreen extends State<VoteDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late List<Tab> _tabs;
  late List<Widget> _tabViews;

  @override
  void initState() {
    super.initState();
    final vote = widget.vote;
    final now = DateTime.now();
    final showRewardTab = now.isAfter(vote.resultOpenTime);

    _tabs = [
      const Tab(text: '상세정보'),
      const Tab(text: '후보'),
      if (showRewardTab) const Tab(text: '리워드'),
    ];

    _tabViews = [
      VoteDetailInfoTab(vote: vote),
      VoteDetailProgressTab(vote: vote),
      if (showRewardTab) VoteDetailRewardTab(vote: vote),
    ];

    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vote = widget.vote;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0C),
      appBar: const Header(),
      endDrawer: const AppDrawer(),
      floatingActionButton: const BackFAB(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Center(
            child: Text(
              vote.voteName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF2EFFAA),
              unselectedLabelColor: Colors.white60,
              indicatorColor: const Color(0xFF2EFFAA),
              tabs: _tabs,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabViews,
            ),
          ),
        ],
      ),
    );
  }
}