import 'package:flutter/material.dart';
import '../common/tag_box.dart';

class WinnerCard extends StatelessWidget {
  final String name;
  final String artistCode;
  final String profileUrl;
  final double votePercent;

  const WinnerCard({
    super.key,
    required this.name,
    required this.artistCode,
    required this.profileUrl,
    required this.votePercent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 350),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF71C8C3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              TagBox(text: '종료'),
              Text('WINNER', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
              Icon(Icons.emoji_events, color: Colors.white, size: 28),
            ],
          ),
          const SizedBox(height: 8),
          const Text('이 주의 아이돌은?', style: TextStyle(color: Colors.black87, fontSize: 20)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              profileUrl,
              width: 185,
              height: 185,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$name ($artistCode)', // ✅ name (한글) + artistCode (영어명 대체)
            style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: votePercent / 100,
                    color: const Color(0xFF2EFFAA),
                    backgroundColor: Colors.grey.shade500,
                    minHeight: 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('${votePercent.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}
