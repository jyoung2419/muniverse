import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/event/event_model.dart';
import '../../models/vote/vote_model.dart';
import '../../providers/vote/vote_provider.dart';
import 'title_vote_detail_tab.dart';

class TitleVoteTab extends StatefulWidget {
  final EventModel event;

  const TitleVoteTab({super.key, required this.event});

  @override
  State<TitleVoteTab> createState() => _TitleVoteTabState();
}

class _TitleVoteTabState extends State<TitleVoteTab> {
  String selectedStatus = '진행중';
  VoteModel? selectedVote;

  bool isVoteOngoing(VoteModel vote) {
    return DateTime.now().isBefore(vote.endTime);
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

    final votes = Provider.of<VoteProvider>(context).votes;
    final filteredVotes = votes.where((v) {
      final isSameEvent = v.eventCode == widget.event.eventCode;
      final isOngoing = isVoteOngoing(v);
      return isSameEvent && (selectedStatus == '진행중' ? isOngoing : !isOngoing);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            children: [
              const Spacer(),
              Radio<String>(
                value: '진행중',
                groupValue: selectedStatus,
                onChanged: (value) => setState(() => selectedStatus = value!),
                activeColor: const Color(0xFF2EFFAA),
                visualDensity: VisualDensity(horizontal: -2, vertical: -4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const Text('진행', style: TextStyle(color: Colors.white)),
              const SizedBox(width: 8),
              Radio<String>(
                value: '종료',
                groupValue: selectedStatus,
                onChanged: (value) => setState(() => selectedStatus = value!),
                activeColor: const Color(0xFF2EFFAA),
                visualDensity: VisualDensity(horizontal: -2, vertical: -4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const Text('종료', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            itemCount: filteredVotes.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: VoteCard(
                vote: filteredVotes[index],
                event: widget.event,
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

  const VoteCard({
    super.key,
    required this.vote,
    required this.event,
    required this.onPressed,
  });

  bool isOngoing() => DateTime.now().isBefore(vote.endTime);

  String getDateRange(DateTime start, DateTime end) {
    final formatter = DateFormat('yyyy.MM.dd');
    return '${formatter.format(start)} ~ ${formatter.format(end)}';
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF212225),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 이미지 영역
            Container(
              width: 180,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: AssetImage(vote.voteImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 텍스트 정보
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.content, style: const TextStyle(color: Colors.white, fontSize: 10)),
                    const SizedBox(height: 6),
                    Text(vote.voteName,
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text('기간 : ${getDateRange(vote.startTime, vote.endTime)}',
                        style: const TextStyle(color: Colors.white70, fontSize: 11)),
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
                          Text(vote.rewardContent,
                              style: const TextStyle(color: Colors.white, fontSize: 11)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
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
                        child: Text(
                          isOngoing() ? '투표 하기' : '결과 보기',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
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
