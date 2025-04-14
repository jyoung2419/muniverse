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
    final target = widget.target;
    setState(() {
      _duration = target.difference(now);
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

  @override
  Widget build(BuildContext context) {
    final days = _duration.inDays;
    final hours = _duration.inHours % 24;
    final minutes = _duration.inMinutes % 60;
    final seconds = _duration.inSeconds % 60;

    Widget timeUnit(String label, int value) {
      return Container(
        width: 60,
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value.toString().padLeft(2, '0'),
              style: const TextStyle(
                fontSize: 20,
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      );
    }


    Widget colon() {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Text(":", style: TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold)),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          timeUnit('DAYS', days),
          colon(),
          timeUnit('HOURS', hours),
          colon(),
          timeUnit('MINUTES', minutes),
          colon(),
          timeUnit('SECONDS', seconds),
        ],
      ),
    );
  }
}
