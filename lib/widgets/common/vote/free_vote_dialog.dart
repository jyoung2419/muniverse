import 'package:flutter/material.dart';

class FreeVoteDialog extends StatefulWidget {
  final int totalVotes;

  const FreeVoteDialog({super.key, required this.totalVotes});

  @override
  State<FreeVoteDialog> createState() => _FreeVoteDialogState();
}

class _FreeVoteDialogState extends State<FreeVoteDialog> {
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
                const Text('무료 투표권',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),

            const Text('사용할 투표권 수 선택', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 4),
            Text.rich(
              TextSpan(
                text: '총 ',
                style: const TextStyle(color: Colors.white),
                children: [
                  TextSpan(
                    text: '${widget.totalVotes}',
                    style: const TextStyle(color: Color(0xFF2EFFAA), fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: '회 투표 가능합니다.'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white70),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_left, color: Colors.white),
                          onPressed: decrease,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 25),
                        Text(
                          '$selectedCount',
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(width: 25),
                        IconButton(
                          icon: const Icon(Icons.arrow_right, color: Colors.white),
                          onPressed: increase,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('장', style: TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 투표 실행 로직
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2EFFAA),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('투표 하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
