import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/event/detail/event_model.dart';
import '../../providers/event/detail/event_vote_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/translate_text.dart';
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
    final lang = context
        .read<LanguageProvider>()
        .selectedLanguageCode;
    selectedStatus = lang == 'kr' ? '전체' : 'all';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchVotes();
    });
  }

  Future<void> _fetchVotes() async {
    final mappedStatus = _mapStatus(selectedStatus);
    await context.read<EventVoteProvider>().fetchVotes(
        widget.event.eventCode, mappedStatus);
  }

  String _mapStatus(String status) {
    final lang = context
        .read<LanguageProvider>()
        .selectedLanguageCode;

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

  void _onFilterChanged(String status) async {
    final newMappedStatus = _mapStatus(status);
    setState(() {
      selectedStatus = status.toLowerCase();
    });
    await context.read<EventVoteProvider>().fetchVotes(widget.event.eventCode, newMappedStatus);
  }

  @override
  Widget build(BuildContext context) {
    final votes = context
        .watch<EventVoteProvider>()
        .votes;
    final statusKey = _mapStatus(selectedStatus).toLowerCase();
    final now = DateTime.now();

    final filteredVotes = votes.where((vote) {
      final isRunning = now.isAfter(vote.startTime) &&
          now.isBefore(vote.endTime);
      final isUpcoming = now.isBefore(vote.startTime);
      final isEnded = now.isAfter(vote.endTime);

      return statusKey == 'all' ||
          (statusKey == 'open' && isRunning) ||
          (statusKey == 'before' && isUpcoming) ||
          (statusKey == 'closed' && isEnded);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: VoteFilterWidget(
            selectedFilter: selectedStatus,
            onChanged: _onFilterChanged,
          ),
        ),
        Expanded(
          child: filteredVotes.isEmpty
              ? const Center(
            child: TranslatedText(
              '현재 등록된 투표가 없습니다.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          )
              : ListView.builder(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filteredVotes.length,
            itemBuilder: (context, index) {
              final vote = filteredVotes[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: VoteCard(
                  vote: vote,
                  event: widget.event,
                  selectedStatus: statusKey,
                  onPressed: () {
                    print('투표 클릭: ${vote.voteCode}');
                  },
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
