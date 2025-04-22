import 'package:flutter/material.dart';
import 'dart:async';
import '../../models/vote/vote_model.dart';
import '../../widgets/vote/voting_progress_list.dart';
import '../../widgets/vote/voting_result_list.dart';

class HomeAwardSection extends StatefulWidget {
  final VoteModel vote;

  const HomeAwardSection({super.key, required this.vote});

  @override
  State<HomeAwardSection> createState() => _HomeAwardSectionState();
}

class _HomeAwardSectionState extends State<HomeAwardSection> {
  late Timer _timer;
  Duration _remaining = Duration.zero;
  late DateTime _deadline;

  @override
  void initState() {
    super.initState();
    _deadline = widget.vote.endTime;
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _remaining = _deadline.difference(now).isNegative
          ? Duration.zero
          : _deadline.difference(now);
    });
  }

  String get formattedTime {
    final d = _remaining;
    final days = d.inDays;
    final hours = d.inHours % 24;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;
    return '${days}일 ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')} 남음';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isVoting = now.isAfter(widget.vote.startTime) && now.isBefore(widget.vote.endTime);
    final isBeforeResultOpen = now.isAfter(widget.vote.endTime) && now.isBefore(widget.vote.resultOpenTime);
    final isResultOpen = now.isAfter(widget.vote.resultOpenTime);

    if (isResultOpen) {
      return const VotingResultList();
    }

    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                widget.vote.voteImageUrl,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: Row(
                children: [
                  if (isVoting)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2EFFAA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '진행중',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else if (isBeforeResultOpen)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '종료',
                        style: TextStyle(
                          color: Color(0xFF2EFFAA),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F1F1F),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      formattedTime,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (isVoting)
          const VotingProgressList()
        else
          const VotingProgressList(),
      ],
    );
  }
}
