import 'package:flutter/material.dart';
import '../../screens/vote/vote_detail_screen.dart';

class VoteCardButton extends StatelessWidget {
  final String status; // e.g., 'OPEN', 'CLOSED', 'BE_OPEN', 'WAITING'
  final String voteCode;
  final String eventName;
  final String voteText;
  final String resultText;
  final String closedText;
  final String upcomingText;

  const VoteCardButton({
    super.key,
    required this.status,
    required this.voteCode,
    required this.eventName,
    required this.voteText,
    required this.resultText,
    required this.closedText,
    required this.upcomingText,
  });

  @override
  Widget build(BuildContext context) {
    if (status == 'OPEN') {
      return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VoteDetailScreen(
                voteCode: voteCode,
                eventName: eventName,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2EFFAA),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          minimumSize: const Size(60, 30),
          elevation: 0,
        ),
        child: Text(voteText, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
      );
    } else {
      final isDisabled = status == 'WAITING' || status == 'BE_OPEN';
      final label = status == 'BE_OPEN' ? upcomingText : resultText;

      return OutlinedButton(
        onPressed: isDisabled
            ? null
            : () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VoteDetailScreen(
                voteCode: voteCode,
                eventName: eventName,
              ),
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF2EFFAA),
          side: const BorderSide(color: Color(0xFF2EFFAA), width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          minimumSize: const Size(60, 30),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF2EFFAA)),
        ),
      );
    }
  }
}
