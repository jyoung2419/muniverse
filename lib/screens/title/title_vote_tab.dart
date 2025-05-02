import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/event/detail/event_model.dart';
import '../../providers/event/detail/event_vote_provider.dart';
import '../../widgets/vote/vote_card.dart';
import '../../widgets/vote/vote_filter_widget.dart';

class TitleVoteTab extends StatefulWidget {
  final EventModel event;

  const TitleVoteTab({
    super.key,
    required this.event,
  });

  @override
  State<TitleVoteTab> createState() => _TitleVoteTabState();
}

class _TitleVoteTabState extends State<TitleVoteTab> {
  String selectedStatus = '전체';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchVotes();
    });
  }

  Future<void> _fetchVotes() async {
    final mappedStatus = _mapStatus(selectedStatus);
    await context.read<EventVoteProvider>().fetchVotes(widget.event.eventCode, mappedStatus);
  }

  String _mapStatus(String status) {
    switch (status) {
      case '진행중':
        return 'open';
      case '진행완료':
        return 'closed';
      case '진행예정':
        return 'before';
      default:
        return 'all';
    }
  }

  void _onFilterChanged(String status) async {
    setState(() {
      selectedStatus = status;
    });
    await _fetchVotes();
  }

  @override
  Widget build(BuildContext context) {
    final votes = context.watch<EventVoteProvider>().votes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: VoteFilterWidget(
            filters: const ['전체', '진행중', '진행완료', '진행예정'],
            selectedFilter: selectedStatus,
            onChanged: _onFilterChanged,
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: votes.length,
            itemBuilder: (context, index) {
              final vote = votes[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: VoteCard(
                  vote: vote,
                  event: widget.event,
                  selectedStatus: selectedStatus,
                  onPressed: () {
                    print('투표 클릭: ${vote.voteCode}');
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
