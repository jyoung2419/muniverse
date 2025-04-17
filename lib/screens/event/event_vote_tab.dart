import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/event/event_model.dart';
import '../../models/vote/vote_model.dart';
import '../../providers/vote/vote_provider.dart';
import 'event_vote_detail_tab.dart';

class EventVoteTab extends StatefulWidget {
  final EventModel event;

  const EventVoteTab({super.key, required this.event});

  @override
  State<EventVoteTab> createState() => _EventVoteTabState();
}

class _EventVoteTabState extends State<EventVoteTab> {
  String selectedStatus = '진행중';
  VoteModel? selectedVote;

  bool isVoteOngoing(VoteModel vote) {
    return DateTime.now().isBefore(vote.endTime);
  }

  @override
  Widget build(BuildContext context) {
    if (selectedVote != null) {
      return EventVoteDetailTab(
        vote: selectedVote!,
        event: widget.event,
        onBack: () => setState(() => selectedVote = null),
      );
    }

    final votes = Provider.of<VoteProvider>(context).votes;
    final filteredVotes = votes.where((v) {
      final ongoing = isVoteOngoing(v);
      return selectedStatus == '진행중' ? ongoing : !ongoing;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    return Container(
      height: 155,
      decoration: BoxDecoration(
        color: const Color(0xFF212225),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // 이미지
          Stack(
            children: [
              Container(
                width: 180,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  image: DecorationImage(
                    image: AssetImage(vote.voteImageUrl),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2EFFAA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isOngoing() ? '진행중' : '종료',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 텍스트 정보
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    vote.voteName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '기간 : ${getDateRange(vote.startTime, vote.endTime)}',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${event.content}에서 가장 인기 있는 아이돌 그룹은 누구?',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: onPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2EFFAA),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: const Size(60, 30),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          elevation: 0,
                        ),
                        child: Text(
                          isOngoing() ? '투표 하기' : '결과 보기',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
