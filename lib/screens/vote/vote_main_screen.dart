import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/vote/vote_main_model.dart';
import '../../providers/language_provider.dart';
import '../../providers/vote/vote_main_provider.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/back_fab.dart';
import '../../widgets/common/header.dart';
import '../../widgets/vote/vote_card.dart';
import '../../widgets/vote/vote_card_for_main.dart';
import '../../widgets/vote/vote_filter_widget.dart';
import '../vote/vote_detail_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VoteMainScreen extends StatefulWidget {
  const VoteMainScreen({super.key});

  @override
  State<VoteMainScreen> createState() => _VoteMainScreenState();
}

class _VoteMainScreenState extends State<VoteMainScreen> {
  String selectedStatus = '전체';
  final ScrollController _scrollController = ScrollController();

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
  @override
  void initState() {
    super.initState();
    final lang = context.read<LanguageProvider>().selectedLanguageCode;
    selectedStatus = lang == 'kr' ? '전체' : 'all';

    Future.microtask(() {
      context.read<VoteMainProvider>().fetchVotesByStatus(_mapStatus(selectedStatus));
    });
  }

  String _mapStatus(String status) {
    final lang = context.read<LanguageProvider>().selectedLanguageCode;
    final statusMap = lang == 'kr'
        ? {
      '전체': 'all',
      '진행중': 'open',
      '진행완료': 'closed',
      '진행예정': 'before',
    }
        : {
      'all': 'all',
      'ongoing': 'open',
      'closed': 'closed',
      'upcoming': 'before',
    };
    return statusMap[status] ?? 'all';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VoteMainProvider>();
    final statusKey = _mapStatus(selectedStatus.toLowerCase());
    final votes = provider.votes;

    final filteredVotes = votes.where((vote) {
      return statusKey == 'all' ||
          (statusKey == 'open' && vote.voteStatus == VoteStatus.OPEN) ||
          (statusKey == 'before' && vote.voteStatus == VoteStatus.BE_OPEN) ||
          (statusKey == 'closed' && (vote.voteStatus == VoteStatus.CLOSED || vote.voteStatus == VoteStatus.WAITING));
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0C),
      appBar: const Header(),
      endDrawer: const AppDrawer(),
      floatingActionButton: const BackFAB(),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Transform.translate(
                            offset: const Offset(1, -2),
                            child: SvgPicture.asset(
                              'assets/svg/m_logo.svg',
                              height: 26,
                            ),
                          ),
                        ),
                        const TextSpan(
                          text: '-Pick',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: VoteFilterWidget(
                  selectedFilter: selectedStatus,
                  onChanged: (status) {
                    setState(() {
                      selectedStatus = status;
                      context.read<VoteMainProvider>().fetchVotesByStatus(_mapStatus(status));
                    });
                  },
                ),
              ),
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : provider.error != null
                    ? Center(child: Text(provider.error!, style: const TextStyle(color: Colors.red)))
                    : ListView.builder(
                  controller: _scrollController,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: filteredVotes.length,
                  itemBuilder: (context, index) {
                    final vote = filteredVotes[index];
                    return VoteCardForMain(
                      vote: vote,
                      selectedStatus: statusKey,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VoteDetailScreen(
                              voteCode: vote.voteCode,
                              eventName: vote.eventName,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 40,
            right: 16,
            child: GestureDetector(
              onTap: _scrollToTop,
              child: SvgPicture.asset(
                'assets/svg/scroll_top.svg',
                width: 80,
                height: 80,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
