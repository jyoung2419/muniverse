import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

class HomeAwardTimer extends StatefulWidget {
  const HomeAwardTimer({super.key});

  @override
  State<HomeAwardTimer> createState() => _HomeAwardTimerState();
}

class _HomeAwardTimerState extends State<HomeAwardTimer> {
  late Timer _timer;
  late Duration _remaining;

  final DateTime _deadline = DateTime(2025, 4, 15, 23, 59, 59);

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
    return '${days.toString().padLeft(2, '0')}일 ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Award',
          style: GoogleFonts.kodchasan(
            color: Colors.white70,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          '4월 15일까지 마감',
          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          formattedTime,
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          formatter.format(123456),
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
}
