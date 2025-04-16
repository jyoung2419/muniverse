import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/event/event_model.dart';
import '../../models/vote_model.dart';
import '../../providers/vote_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    if (selectedVote != null) {
      return EventVoteDetailTab(
        vote: selectedVote!,
        event: widget.event,
        onBack: () => setState(() => selectedVote = null), // ✅ 리스트로 전환
      );
    }

    final votes = Provider.of<VoteProvider>(context).votes;
    final filteredVotes = votes.where((v) => v.status == selectedStatus).toList();

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
                activeColor: Color(0xFF2EFFAA),
                visualDensity: VisualDensity(horizontal: -2, vertical: -4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const Text('진행', style: TextStyle(color: Colors.white)),
              const SizedBox(width: 8),
              Radio<String>(
                value: '종료',
                groupValue: selectedStatus,
                onChanged: (value) => setState(() => selectedStatus = value!),
                activeColor: Color(0xFF2EFFAA),
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
              child: VoteCard(vote: filteredVotes[index], event: widget.event,
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
          // 왼쪽 이미지 (패딩 없음, 전체 높이 꽉 채움)
          Stack(
            children: [
              Container(
                width: 180, // 고정 넓이
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  image: DecorationImage(
                    image: AssetImage(vote.imageUrl),
                    fit: BoxFit.cover, // 또는 BoxFit.none
                    alignment: Alignment.center, // ✅ 중심 기준
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
                    vote.status,
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

          // 오른쪽 내용
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12), // 오른쪽 내부 여백만 유지
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min, // ✅ 추가

                children: [
                  Text(
                    vote.topic,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '기간 : ${vote.dateRange}',
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
                        onPressed: onPressed, // ✅ 이걸로 교체
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
                          vote.status == '진행중' ? '투표 하기' : '결과 보기',
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


