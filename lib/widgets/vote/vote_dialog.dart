import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/artist/artist_provider.dart';
import 'free_vote_dialog.dart';

class VoteDialog extends StatefulWidget {
  final int totalVotes;
  final String artistCode;
  final String voteCode;

  const VoteDialog({
    super.key,
    required this.totalVotes,
    required this.artistCode,
    required this.voteCode,
  });

  @override
  State<VoteDialog> createState() => _VoteDialogState();
}

class _VoteDialogState extends State<VoteDialog> {
  int selectedCount = 1;

  void increase() {
    if (selectedCount < widget.totalVotes) {
      setState(() => selectedCount++);
    }
  }

  void decrease() {
    if (selectedCount > 1) {
      setState(() => selectedCount--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final artist = context.read<ArtistProvider>().getArtistByCode(widget.artistCode);

    return Dialog(
      backgroundColor: const Color(0xFF1B1B1D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 상단 타이틀 + 닫기
            Row(
              children: [
                const Text('투표권',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (artist != null)
              Column(
                children: [
                  Text(
                    '${artist.name} (${artist.content})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  const Text('투표를 진행하시겠습니까?',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                ],
              ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => FreeVoteDialog(voteCode: widget.voteCode),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2EFFAA),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('무료 투표권 선택', style: TextStyle(fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 6), // 버튼 사이 간격
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // 유료 투표 실행
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2EFFAA),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('유료 투표권 선택',style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
