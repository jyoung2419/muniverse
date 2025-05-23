import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/vote/vote_main_model.dart';
import '../../providers/language_provider.dart';
import '../common/build_badge.dart';
import 'base_vote_card.dart';
import 'vote_card_button.dart';

class VoteCardForMain extends StatelessWidget {
  final VoteMainModel vote;
  final String selectedStatus;
  final VoidCallback onPressed;

  const VoteCardForMain({
    super.key,
    required this.vote,
    required this.selectedStatus,
    required this.onPressed,
  });

  String getDateRange(DateTime start, DateTime end) {
    final formatter = DateFormat('yyyy.MM.dd');
    return '${formatter.format(start)} ~ ${formatter.format(end)}';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final statusKey = selectedStatus.toLowerCase();

    final isRunning = now.isAfter(vote.startTime) && now.isBefore(vote.endTime);
    final isUpcoming = now.isBefore(vote.startTime);
    final isEnded = now.isAfter(vote.endTime);

    final shouldShow = statusKey == 'all' ||
        (statusKey == 'open' && isRunning) ||
        (statusKey == 'before' && isUpcoming) ||
        (statusKey == 'closed' && isEnded);

    if (!shouldShow) return const SizedBox.shrink();

    final lang = context.watch<LanguageProvider>().selectedLanguageCode;
    final upcomingText = lang == 'kr' ? '투표 예정' : 'UPCOMING';
    final closedText = lang == 'kr' ? '종료' : 'CLOSED';
    final ongoingText = lang == 'kr' ? '진행중' : 'ONGOING';
    final rewardText = vote.rewards.isNotEmpty
        ? vote.rewards.map((r) => r.rewardContent).join(', ')
        : (lang == 'kr' ? '리워드 정보 없음' : 'No reward info');
    final periodText = lang == 'kr'
        ? '기간 : ${getDateRange(vote.startTime, vote.endTime)} (KST)'
        : 'Period : ${getDateRange(vote.startTime, vote.endTime)} (KST)';
    final ddayText = lang == 'kr' ? '남은 투표기간 ${vote.voteRestDay}일' : 'D-${vote.voteRestDay}';

    late Widget badge;
    if (vote.voteStatus == VoteStatus.OPEN) {
      badge = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BuildBadge(text: ongoingText, color: const Color(0xFF2EFFAA), textColor: Colors.black),
          const SizedBox(width: 6),
          BuildBadge(text: ddayText, color: Colors.black.withOpacity(0.7), textColor: Colors.white),
        ],
      );
    } else if (vote.voteStatus == VoteStatus.BE_OPEN) {
      badge = BuildBadge(text: upcomingText, color: const Color(0xFF2EFFAA), textColor: Colors.black);
    } else {
      badge = BuildBadge(text: closedText, color: Colors.black, textColor: const Color(0xFF2EFFAA));
    }

    return BaseVoteCard(
      badge: badge,
      eventName: vote.eventName,
      voteName: vote.voteName,
      periodText: periodText,
      rewardText: rewardText,
      imageUrl: vote.voteImageURL,
      actionButton: VoteCardButton(
        status: vote.voteStatus.name,
        voteCode: vote.voteCode,
        eventName: vote.eventName,
        voteText: lang == 'kr' ? '투표하기' : 'VOTE',
        resultText: lang == 'kr' ? '결과보기' : 'RESULT',
        closedText: closedText,
        upcomingText: upcomingText,
      ),
    );
  }
}
