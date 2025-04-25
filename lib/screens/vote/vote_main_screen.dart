import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/vote/vote_provider.dart';
import '../../providers/artist/artist_provider.dart';
import '../../providers/vote/vote_artist_provider.dart';
import '../../providers/vote/vote_reward_media_provider.dart';
import '../../providers/event/event_provider.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/back_fab.dart';
import '../../widgets/common/header.dart';
import '../../widgets/vote/vote_filter_widget.dart';
import '../vote/vote_detail_screen.dart';
import '../../widgets/vote/vote_card.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VoteMainScreen extends StatefulWidget {
  const VoteMainScreen({super.key});

  @override
  State<VoteMainScreen> createState() => _VoteMainScreenState();
}

class _VoteMainScreenState extends State<VoteMainScreen> {
  String selectedStatus = '전체';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final votes = context.read<VoteProvider>().votes;
      final artists = context.read<ArtistProvider>().artists;

      context.read<VoteArtistProvider>().fetchVoteArtists(
        votes: votes,
        artists: artists,
      );
      context.read<VoteRewardMediaProvider>().fetchRewardMedia(votes);
    });
  }

  @override
  Widget build(BuildContext context) {
    final voteProvider = context.read<VoteProvider>();
    final eventProvider = context.read<EventProvider>();
    final filteredVotes = voteProvider.filterAllVotes(selectedStatus);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0C),
      appBar: const Header(),
      endDrawer: const AppDrawer(),
      floatingActionButton: const BackFAB(),
      body: Column(
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
                      TextSpan(
                        text: '-Pick',
                        style: const TextStyle(
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
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
            child: VoteFilterWidget(
              filters: const ['전체', '진행중', '진행완료', '진행예정'],
              selectedFilter: selectedStatus,
              onChanged: (status) => setState(() => selectedStatus = status),
            ),
          ),

          Expanded(
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: filteredVotes.length,
              itemBuilder: (context, index) {
                final vote = filteredVotes[index];
                final event = eventProvider.getEventByCode(vote.eventCode);
                if (event == null) return const SizedBox();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: VoteCard(
                    vote: vote,
                    event: event,
                    selectedStatus: selectedStatus,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VoteDetailScreen(vote: vote),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}