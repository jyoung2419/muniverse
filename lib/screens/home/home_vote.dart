import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class HomeAwardSection extends StatefulWidget {
  const HomeAwardSection({super.key});

  @override
  State<HomeAwardSection> createState() => _HomeAwardSectionState();
}

class _HomeAwardSectionState extends State<HomeAwardSection> {
  late Timer _timer;
  Duration _remaining = Duration.zero;
  final DateTime _deadline = DateTime(2025, 4, 30, 23, 59, 59);

  @override
  void initState() {
    super.initState();
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
    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/vote1.png',
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2EFFAA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '진행중',
                      style: TextStyle(
                        color: Colors.black,
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
            )
          ],
        ),
        const SizedBox(height: 20),
        // 투표 리스트
        Column(
          children: List.generate(5, (index) {
            final rank = index + 1;
            final names = ['태민', '방탄소년단 뷔', '블랙핑크', 'The KingDom', '르세라핌'];
            final namesEng = ['SHINee', 'BTS V', 'BLACK PINK', 'The KingDom', 'LESSERAFIM'];
            final percents = [56, 23, 18, 12, 6];
            final images = [
              'shinee.png',
              'btsv.png',
              'blackpink.png',
              'thekingdom.png',
              'lesserafim.png',
            ];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Text('$rank ', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 6),
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFFC2C4C8E0), width: 1),
                      image: DecorationImage(
                        image: AssetImage('assets/images/${images[index]}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 이름
                        Text(
                          names[index],
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 2),
                        // 영어이름 + 퍼센트 같이
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                namesEng[index],
                                style: const TextStyle(color: Color(0xFFC2C4C8E0), fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Text(
                              '${percents[index]}%',
                              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // 프로그레스 바
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox(
                            height: 10,
                            child: LinearProgressIndicator(
                              value: percents[index] / 100,
                              color: const Color(0xFF2EFFAA),
                              backgroundColor: Colors.grey.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
