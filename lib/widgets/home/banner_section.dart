import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../common/dday_timer.dart';
import '../common/translate_text.dart';

class BannerSection extends StatelessWidget {
  final String imagePath;
  final String profileUrl;
  final String title;
  final String introContent;
  final DateTime performanceStartTime;
  final DateTime performanceEndTime;
  final int round;
  final String status;
  final DateTime restNextPerformanceStartTime;

  const BannerSection({
    super.key,
    required this.imagePath,
    required this.profileUrl,
    required this.title,
    required this.introContent,
    required this.performanceStartTime,
    required this.performanceEndTime,
    required this.round,
    required this.status,
    required this.restNextPerformanceStartTime,
  });

  int getStreamingRound(DateTime now) {
    final diff = now
        .difference(performanceStartTime)
        .inHours;
    if (diff < 0) return 1;
    return (diff ~/ 24) + 2;
  }

  static String _formatDate(DateTime dt) {
    return '${dt.year}.${_pad(dt.month)}.${_pad(dt.day)} ${_pad(
        dt.hour)}:${_pad(dt.minute)} (KST)';
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isBeforePerformance = now.isBefore(performanceStartTime);
    final lang = context
        .watch<LanguageProvider>()
        .selectedLanguageCode;

    return SizedBox(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.45,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(imagePath, fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.6)),

          Positioned(
            top: 85,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(profileUrl),
                        radius: 16,
                      ),
                      const SizedBox(width: 8),
                      TranslatedText(
                        title,
                        style: TextStyle(color: Colors.white70,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TranslatedText(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TranslatedText(
                    introContent.replaceAll('<br>', '\n'),
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_formatDate(performanceStartTime)} ~ ${_formatDate(
                        performanceEndTime)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (status == 'DURING')
            Positioned(
              bottom: 40,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TranslatedText(
                    '$round회차 스트리밍 시작',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 180,
                    height: 36,
                    child: OutlinedButton(
                      onPressed: () {
                        // 시청하기 동작
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.3),
                        // 반투명 어두운 회색 배경
                        side: const BorderSide(
                            color: Color(0xFF2EFFAA), width: 1),
                        // 연두색 테두리
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: const Size(60, 30),
                      ),
                      child: Text(
                        lang == 'kr' ? '시청하기' : 'WATCH',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2EFFAA),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            if ((isBeforePerformance || round <= 5) &&
                restNextPerformanceStartTime.isAfter(DateTime.now()))
              Positioned(
                bottom: 10,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TranslatedText(
                      '$round 회차 스트리밍까지 남은시간',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    DdayTimer(
                      target: restNextPerformanceStartTime,
                      alignStart: true,
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}