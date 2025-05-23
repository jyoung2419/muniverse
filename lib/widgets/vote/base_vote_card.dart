import 'package:flutter/material.dart';

class BaseVoteCard extends StatelessWidget {
  final Widget badge;               // 상태 배지 위젯
  final String eventName;          // 이벤트 이름
  final String voteName;           // 투표 이름
  final String periodText;         // 기간 (포맷된 문자열)
  final String rewardText;         // 리워드 내용
  final String? imageUrl;          // 이미지 URL
  final Widget actionButton;       // 투표/결과 버튼

  const BaseVoteCard({
    super.key,
    required this.badge,
    required this.eventName,
    required this.voteName,
    required this.periodText,
    required this.rewardText,
    required this.imageUrl,
    required this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Stack(
                children: [
                  Container(
                    width: 170,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: imageUrl != null && imageUrl!.isNotEmpty
                            ? NetworkImage(imageUrl!)
                            : const AssetImage('assets/images/default_image.png') as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(top: 8, left: 8, child: badge),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 12, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(eventName, style: const TextStyle(color: Colors.white, fontSize: 10)),
                    const SizedBox(height: 6),
                    Text(voteName, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text(periodText, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: const BoxDecoration(color: Color(0xFF121212)),
                      child: Row(
                        children: [
                          const Icon(Icons.card_giftcard, size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              rewardText,
                              style: const TextStyle(color: Colors.white, fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Align(alignment: Alignment.bottomRight, child: actionButton),
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
