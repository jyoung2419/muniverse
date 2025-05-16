import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/vote/vote_main_model.dart';
import '../../providers/language_provider.dart';
import '../../screens/vote/vote_detail_screen.dart';
import '../common/translate_text.dart';

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
    final rewardLabel = lang == 'kr' ? '리워드' : 'REWARD';
    final ddayText = lang == 'kr' ? '남은 투표기간 ${vote.voteRestDay}일' : 'D-${vote.voteRestDay}';
    final periodText = lang == 'kr' ? '기간 : ${getDateRange(vote.startTime, vote.endTime)} (KST)' : 'Period : ${getDateRange(vote.startTime, vote.endTime)} (KST)';
    final rewardText = vote.rewards.isNotEmpty
        ? vote.rewards.map((r) => r.rewardContent).join(', ')
        : (lang == 'kr' ? '리워드 정보 없음' : 'No reward info');

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
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(vote.voteImageURL ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (vote.voteStatus == VoteStatus.OPEN) ...[
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2EFFAA),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              ongoingText,
                              style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
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
                                  ddayText,
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (vote.voteStatus == VoteStatus.BE_OPEN) ...[
                    Positioned(
                      top: 8,
                      left: 8,
                      child: _buildBadge(upcomingText, color: const Color(0xFF2EFFAA), textColor: Colors.black),
                    ),
                  ] else if (vote.voteStatus == VoteStatus.WAITING) ...[
                    Positioned(
                      top: 8,
                      left: 8,
                      child: _buildBadge(closedText, color: Colors.black, textColor: const Color(0xFF2EFFAA)),
                    ),
                  ] else if (vote.voteStatus == VoteStatus.CLOSED) ...[
                    Positioned(
                      top: 8,
                      left: 8,
                      child: _buildBadge(closedText, color: Colors.black, textColor: const Color(0xFF2EFFAA)),
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
                    Text(vote.eventName, style: const TextStyle(color: Colors.white, fontSize: 10)),
                    const SizedBox(height: 6),
                    TranslatedText(vote.voteName, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text(periodText,
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
                            children: [
                              Icon(Icons.card_giftcard, size: 14, color: Colors.white),
                              SizedBox(width: 4),
                              Text(rewardLabel, style: const TextStyle(color: Colors.white, fontSize: 11)),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: vote.rewards.isNotEmpty
                                ? vote.rewards.map((r) => Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: TranslatedText(
                                r.rewardContent,
                                style: const TextStyle(color: Colors.white, fontSize: 11),
                              ),
                            )).toList()
                                : [
                              TranslatedText(
                                lang == 'kr' ? '리워드 정보 없음' : 'No reward info',
                                style: const TextStyle(color: Colors.white, fontSize: 11),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: _buildActionButton(context),
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

  Widget _buildBadge(String text, {required Color color, required Color textColor}) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final lang = context.read<LanguageProvider>().selectedLanguageCode;
    final voteText = lang == 'kr' ? '투표하기' : 'VOTE';
    final resultText = lang == 'kr' ? '결과보기' : 'RESULT';
    final closedText = lang == 'kr' ? '투표 종료' : 'CLOSED';
    final upcomingText = lang == 'kr' ? '투표 예정' : 'UPCOMING';
    if (vote.voteStatus == VoteStatus.OPEN) {
      return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VoteDetailScreen(
                voteCode: vote.voteCode,
                eventName: vote.eventName,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2EFFAA),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          minimumSize: const Size(60, 30),
          elevation: 0,
        ),
        child: Text(voteText, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
      );
    } else if (vote.voteStatus == VoteStatus.WAITING) {
      return OutlinedButton(
        onPressed: null, // 선택 불가
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF2EFFAA),
          side: const BorderSide(color: Color(0xFF2EFFAA), width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          minimumSize: const Size(60, 30),
        ),
        child: Text(
          closedText,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF2EFFAA)),
        ),
      );
    } else if (vote.voteStatus == VoteStatus.BE_OPEN) {
      return OutlinedButton(
        onPressed: null,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF2EFFAA),
          side: const BorderSide(color: Color(0xFF2EFFAA), width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          minimumSize: const Size(60, 30),
        ),
        child: Text(
          upcomingText,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF2EFFAA)),
        ),
      );
    } else {
      // CLOSED
      return OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VoteDetailScreen(
                voteCode: vote.voteCode,
                eventName: vote.eventName,
              ),
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF2EFFAA),
          side: const BorderSide(color: Color(0xFF2EFFAA), width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          minimumSize: const Size(60, 30),
        ),
        child: Text(
          resultText,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF2EFFAA)),
        ),
      );
    }
  }
}
