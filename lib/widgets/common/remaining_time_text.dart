import 'dart:async';
import 'package:flutter/material.dart';

class RemainingTimeText extends StatefulWidget {
  final DateTime endTime;
  const RemainingTimeText({super.key, required this.endTime});

  @override
  State<RemainingTimeText> createState() => _RemainingTimeTextState();
}

class _RemainingTimeTextState extends State<RemainingTimeText> {
  late Timer _timer;
  late Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _calculateRemaining());
  }

  void _calculateRemaining() {
    final now = DateTime.now();
    final diff = widget.endTime.difference(now);
    setState(() {
      _remaining = diff.isNegative ? Duration.zero : diff;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String formatRemainingTime(Duration remaining) {
    final days = remaining.inDays.toString().padLeft(2, '0');
    final hours = (remaining.inHours % 24).toString().padLeft(2, '0');
    final minutes = (remaining.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$days일 $hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '남은시간',
          style: TextStyle(
            color: Colors.white60,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          formatRemainingTime(_remaining),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
