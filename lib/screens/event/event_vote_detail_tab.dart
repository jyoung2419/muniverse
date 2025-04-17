import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/vote/vote_model.dart';
import '../../models/event/event_model.dart';
import '../../widgets/common/free_vote_dialog.dart';

class EventVoteDetailTab extends StatelessWidget {
  final VoteModel vote;
  final EventModel event;
  final VoidCallback onBack;

  const EventVoteDetailTab({
    super.key,
    required this.vote,
    required this.event,
    required this.onBack,
  });

  String getDateRange(DateTime start, DateTime end) {
    final formatter = DateFormat('yyyy.MM.dd');
    return '${formatter.format(start)} ~ ${formatter.format(end)}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          vote.voteName, // ✅ 기존 vote.topic → voteName으로 수정
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          '기간: ${getDateRange(vote.startTime, vote.endTime)}', // ✅ dateRange 대신 직접 계산
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 16),
        const Text('여기에 투표 상세 UI 구현 예정', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onBack,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2EFFAA),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            minimumSize: const Size(60, 30),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            elevation: 0,
          ),
          child: const Text(
            '목록으로',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ),

        const SizedBox(height: 8),

        // 무료 투표 버튼
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => const FreeVoteDialog(totalVotes: 3),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2EFFAA),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            minimumSize: const Size(60, 30),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            elevation: 0,
          ),
          child: const Text(
            '무료 투표하기',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
