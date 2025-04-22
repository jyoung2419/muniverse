import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/vote/vote_model.dart';
import '../../models/vote/vote_model.dart';
import '../../providers/vote/vote_artist_provider.dart';
import '../../providers/vote/vote_reward_media_provider.dart';
import '../../providers/vote/vote_provider.dart';
import '../../providers/vote/vote_artist_provider.dart';
import '../../providers/vote/vote_reward_media_provider.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/back_fab.dart';
import '../../widgets/common/header.dart';
import '../../widgets/common/dday_timer.dart';
import '../../widgets/vote/vote_artist_progress_tile.dart';

class VoteDetailScreen extends StatefulWidget {
  final VoteModel vote;
  const VoteDetailScreen({super.key, required this.vote});

  @override
  State<VoteDetailScreen> createState() => _VoteDetailScreen();
}

class _VoteDetailScreen extends State<VoteDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vote = widget.vote;
    final rewardImages =
        Provider.of<VoteRewardMediaProvider>(context).voteRewardMediaUrl;
    final artists = Provider.of<VoteArtistProvider>(context).voteArtists;
    final totalVotes = artists.fold(0, (sum, a) => sum + a.voteCount);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
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
                fontFamily: 'Inter',
                fontSize: 24,
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
              tabs: const [
                Tab(text: '상세정보'),
                Tab(text: '투표'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 상세정보 탭
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DdayTimer(target: vote.endTime),
                        const SizedBox(height: 8),
                        Text(
                          '${DateFormat('yyyy.MM.dd').format(vote.startTime)} ~ ${DateFormat('yyyy.MM.dd').format(vote.endTime)}',
                          style: const TextStyle(color: Colors.white60),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          vote.content,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: rewardImages.length,
                            itemBuilder: (context, index) => Card(
                              clipBehavior: Clip.antiAlias,
                              margin: const EdgeInsets.only(right: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              child: Image.asset(
                                rewardImages[index],
                                width: 200,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 투표 탭
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('총 참여 인원: $totalVotes명',
                              style: const TextStyle(color: Colors.white)),
                          const SizedBox(height: 12),
                          Expanded(
                            child: ListView.builder(
                              itemCount: artists.length,
                                itemBuilder: (context, index) {
                                  final artist = artists[index];
                                  final String percent = totalVotes == 0
                                      ? '0'
                                      : (artist.voteCount / totalVotes * 100).toStringAsFixed(1);

                                  return VoteArtistProgressTile(
                                    rank: index + 1,
                                    artistModel: artist,
                                    percent: percent,
                                  );
                                }
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: FloatingActionButton(
                        onPressed: () =>
                            Scrollable.ensureVisible(context), // 단순 예시
                        backgroundColor: const Color(0xFF2EFFAA),
                        child: const Icon(Icons.arrow_upward, color: Colors.black),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}