import 'dart:async';
import 'package:flutter/material.dart';

class DdayTimer extends StatefulWidget {
  final DateTime target;

  const DdayTimer({super.key, required this.target});

  @override
  State<DdayTimer> createState() => _DdayTimerState();
}

class _DdayTimerState extends State<DdayTimer> {
  late Duration _duration;
  late Timer _timer;

  void _updateDuration() {
    final now = DateTime.now();
    setState(() {
      _duration = widget.target.difference(now);
      if (_duration.isNegative) {
        _duration = Duration.zero;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _updateDuration();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateDuration());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String formatDuration(Duration d) {
    final days = d.inDays.toString().padLeft(2, '0');
    final hours = (d.inHours % 24).toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$days:$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // ✅ 왼쪽 정렬
      children: [
        const SizedBox(height: 6),
        const Text(
          '스트리밍까지 남은시간',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          formatDuration(_duration),
          style: const TextStyle(
            color: Color(0xFF2EFFAA),
            fontSize: 35,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
