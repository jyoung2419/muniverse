import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/event/event_model.dart';
import '../../models/vote/vote_model.dart';
import '../../providers/vote/vote_provider.dart';
import '../../widgets/common/vote/vote_filter_widget.dart';
import 'title_vote_detail_tab.dart';
import '../../providers/vote/vote_reward_media_provider.dart';

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
      context.read<VoteRewardMediaProvider>().fetchRewardMedia(votes);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (selectedVote != null) {
      return TitleVoteDetailTab(
        vote: selectedVote!,
        event: widget.event,
        onBack: () => setState(() => selectedVote = null),
      );
    }

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

class VoteCard extends StatelessWidget {
  final VoteModel vote;
  final EventModel event;
  final VoidCallback onPressed;
  final String selectedStatus;

  const VoteCard({
    super.key,
    required this.vote,
    required this.event,
    required this.onPressed,
    required this.selectedStatus,
  });

  String getDateRange(DateTime start, DateTime end) {
    final formatter = DateFormat('yyyy.MM.dd');
    return '${formatter.format(start)} ~ ${formatter.format(end)}';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isRunning = now.isAfter(vote.startTime) && now.isBefore(vote.endTime);
    final isUpcoming = now.isBefore(vote.startTime);
    final isEnded = now.isAfter(vote.endTime);
    final remainingDays = vote.endTime.difference(now).inDays;
    final rewardMediaList = context.watch<VoteRewardMediaProvider>().getMediaByVoteCode(vote.voteCode);
    final rewardText = rewardMediaList.isNotEmpty ? rewardMediaList.first.rewardContent : '리워드 정보 없음';

    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF212225),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Stack(
                children: [
                  Container(
                    width: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(vote.voteImageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (isRunning && selectedStatus != '진행완료') ...[
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2EFFAA),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '진행중',
                          style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 52,
                      child: Container(
                        alignment: Alignment.center,
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
                              'D-DAY $remainingDays',
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else if (isUpcoming && selectedStatus != '진행완료' && selectedStatus != '진행중') ...[
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2EFFAA),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '투표 예정',
                          style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ] else if (isEnded && selectedStatus != '진행중') ...[
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '종료',
                          style: TextStyle(color: Color(0xFF2EFFAA), fontSize: 10, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 12, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.content, style: const TextStyle(color: Colors.white, fontSize: 10)),
                    const SizedBox(height: 6),
                    Text(vote.voteName, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text('기간 : ${getDateRange(vote.startTime, vote.endTime)}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    const SizedBox(height: 6),
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
                          Text(rewardText, style: const TextStyle(color: Colors.white, fontSize: 11)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: isRunning
                          ? ElevatedButton(
                        onPressed: onPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2EFFAA),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: const Size(60, 30),
                          elevation: 0,
                        ),
                        child: const Text('투표 하기', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                      )
                          : OutlinedButton(
                        onPressed: onPressed,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF2EFFAA),
                          side: const BorderSide(color: Color(0xFF2EFFAA), width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: const Size(60, 30),
                        ),
                        child: Text(
                          isUpcoming ? '투표 예정' : '결과 보기',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF2EFFAA)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}