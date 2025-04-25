import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/event/event_model.dart';
import '../../models/vote/vote_model.dart';
import '../../providers/artist/artist_provider.dart';
import '../../providers/vote/vote_artist_provider.dart';
import '../../providers/vote/vote_provider.dart';
import '../../widgets/vote/vote_card.dart';
import '../../widgets/vote/vote_filter_widget.dart';
import '../../providers/vote/vote_reward_media_provider.dart';
import '../vote/vote_detail_screen.dart';

class TitleVoteTab extends StatefulWidget {
  final EventModel event;

  const TitleVoteTab({super.key, required this.event});

  @override
  State<TitleVoteTab> createState() => _TitleVoteTabState();
}

class _TitleVoteTabState extends State<TitleVoteTab> {
  String selectedStatus = '전체';
  VoteModel? selectedVote;

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
    final filteredVotes = context
        .read<VoteProvider>()
        .filterVotes(selectedStatus, widget.event.eventCode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: VoteFilterWidget(
            filters: const ['전체', '진행중', '진행완료', '진행예정'],
            selectedFilter: selectedStatus,
            onChanged: (status) => setState(() => selectedStatus = status),
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filteredVotes.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: VoteCard(
                vote: filteredVotes[index],
                event: widget.event,
                selectedStatus: selectedStatus,
                onPressed: () => setState(() => selectedVote = filteredVotes[index]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}