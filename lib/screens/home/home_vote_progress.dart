import 'package:flutter/material.dart';

class HomeVoteProgress extends StatelessWidget {
  final double progress; // 0.0 ~ 1.0
  final String remainingTime; // 예: "D-2", "투표 마감"

  const HomeVoteProgress({
    super.key,
    required this.progress,
    required this.remainingTime,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '투표 진행률',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            Container(
              height: 12,
              width: MediaQuery.of(context).size.width * progress,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF30CEFD), Color(0xFF8439FA)],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$percentage%',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            Text(
              remainingTime,
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }
}
