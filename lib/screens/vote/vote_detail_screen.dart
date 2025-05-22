import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:muniverse_app/widgets/common/translate_text.dart';
import 'package:provider/provider.dart';
import '../../models/vote/vote_detail_content_model.dart';
import '../../providers/vote/vote_detail_provider.dart';
import '../../providers/vote/vote_reward_media_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/back_fab.dart';
import '../../widgets/common/header.dart';
import '../../utils/vote_text_util.dart';
import '../vote/detail/vote_detail_info_tab.dart';
import '../vote/detail/vote_detail_progress_tab.dart';
import '../vote/detail/vote_detail_result_tab.dart';
import '../vote/detail/vote_detail_reward_tab.dart';
import '../../models/vote/vote_detail_content_model.dart';

class VoteDetailScreen extends StatefulWidget {
  final String voteCode;
  final String eventName;
  const VoteDetailScreen({super.key, required this.voteCode, required this.eventName});

  @override
  State<VoteDetailScreen> createState() => _VoteDetailScreenState();
}

class _VoteDetailScreenState extends State<VoteDetailScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _showTopButton = false;
  bool _tabInitialized = false;
  bool _isLoading = true;
  late final LanguageProvider _languageProvider;
  int _currentTabIndex = 1;

  @override
  void initState() {
    super.initState();
    _languageProvider = context.read<LanguageProvider>();
    _languageProvider.addListener(_onLanguageChanged);
    _fetchVoteDetail();

    _scrollController.addListener(() {
      if (_scrollController.offset > 300 && !_showTopButton) {
        setState(() => _showTopButton = true);
      } else if (_scrollController.offset <= 300 && _showTopButton) {
        setState(() => _showTopButton = false);
      }
    });
  }

  void _onLanguageChanged() {
    context.read<VoteDetailProvider>().fetchVoteDetail(widget.voteCode);
    context.read<VoteRewardMediaProvider>().fetchVoteRewardMedia(widget.voteCode);
  }

  Future<void> _fetchVoteDetail() async {
    await context.read<VoteDetailProvider>().fetchVoteDetail(widget.voteCode);
    await context.read<VoteRewardMediaProvider>().fetchVoteRewardMedia(widget.voteCode);
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _languageProvider.removeListener(_onLanguageChanged);
    if (_tabInitialized) _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final voteDetail = context.watch<VoteDetailProvider>().voteDetail;

    if (_isLoading || voteDetail == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0B0C0C),
        appBar: Header(),
        endDrawer: AppDrawer(),
        floatingActionButton: BackFAB(),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF2EFFAA))),
      );
    }

    if (!_tabInitialized) {
      _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
      _tabInitialized = true;
    }

    final vote = voteDetail.detailContent;
    final labels = VoteTextUtil.getLabelsForDetailContent(context, vote);
    final now = DateTime.now();
    final isRunning = now.isAfter(vote.startTime) && now.isBefore(vote.endTime);
    final isUpcoming = now.isBefore(vote.startTime);
    final isEnded = now.isAfter(vote.endTime);
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;
    final tabs = lang == 'kr' ? ['상세정보', '후보', '리워드'] : ['DETAILS', 'CANDIDATE', 'REWARD'];

    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0C),
      appBar: const Header(),
      endDrawer: const AppDrawer(),
      floatingActionButton: const BackFAB(),
      body: Stack(
        children: [
          NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Center(
                      child: TranslatedText('투표', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    const SizedBox(height: 16),
                    _buildVoteSummaryCard(vote, labels, isRunning, isUpcoming, isEnded),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TabBar(
                        controller: _tabController,
                        onTap: (index) => setState(() => _currentTabIndex = index),
                        labelColor: const Color(0xFF2EFFAA),
                        unselectedLabelColor: Colors.white60,
                        indicatorColor: const Color(0xFF2EFFAA),
                        tabs: tabs.map((label) => Tab(text: label)).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                VoteDetailInfoTab(voteCode: widget.voteCode),
                vote.voteStatusEnum == VoteStatus.OPEN
                    ? VoteDetailProgressTab(voteCode: widget.voteCode)
                    : VoteDetailResultTab(voteCode: widget.voteCode),
                VoteDetailRewardTab(voteCode: widget.voteCode),
              ],
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

  Widget _buildVoteSummaryCard(VoteDetailContentModel vote, Map<String, String> labels, bool isRunning, bool isUpcoming, bool isEnded) {
    return IntrinsicHeight(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
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
                        image: vote.voteImageUrl.isNotEmpty
                            ? NetworkImage(vote.voteImageUrl)
                            : const AssetImage('assets/images/default_vote_image.png') as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (isRunning)
                    _buildBadge(labels['vote_ongoing']!, bg: const Color(0xFF2EFFAA), fg: Colors.black),
                  if (isUpcoming)
                    _buildBadge(labels['vote_upcoming']!, bg: const Color(0xFF2EFFAA), fg: Colors.black),
                  if (isEnded)
                    _buildBadge(labels['vote_closed']!, bg: Colors.black.withOpacity(0.7), fg: const Color(0xFF2EFFAA)),
                ],
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TranslatedText(widget.eventName, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                    const SizedBox(height: 4),
                    TranslatedText(vote.voteName, style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(labels['vote_period']!, style: const TextStyle(fontSize: 11, color: Colors.white70)),
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
                            children: [
                              const Icon(Icons.card_giftcard, size: 14, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(labels['vote_reward']!, style: const TextStyle(color: Colors.white, fontSize: 11)),
                            ],
                          ),
                          const SizedBox(height: 2),
                          TranslatedText(
                            context.read<VoteDetailProvider>().voteDetail?.rewards.map((r) => r.rewardContent).join(', ') ?? labels['vote_reward_empty']!,
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
    );
  }

  Widget _buildBadge(String text, {required Color bg, required Color fg}) {
    return Positioned(
      top: 8,
      left: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(text, style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
