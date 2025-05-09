import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/vote/vote_availability_provider.dart';

class FreeVoteDialog extends StatefulWidget {
  final String voteCode;

  const FreeVoteDialog({super.key, required this.voteCode});

  @override
  State<FreeVoteDialog> createState() => _FreeVoteDialogState();
}

class _FreeVoteDialogState extends State<FreeVoteDialog> {
  int selectedCount = 1;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<VoteAvailabilityProvider>().fetchVoteAvailability(widget.voteCode);
    });
  }

  void increase(int remainingCount) {
    if (selectedCount < remainingCount) {
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
    final availabilityProvider = context.watch<VoteAvailabilityProvider>();
    final remainingCount = availabilityProvider.availability?.remainingCount ?? 0;

    return Dialog(
      backgroundColor: const Color(0xFF1B1B1D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        child: availabilityProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : availabilityProvider.error != null
            ? Text(
          availabilityProvider.error!,
          style: const TextStyle(color: Colors.red),
        )
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text('무료 투표권',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
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
                    text: '$remainingCount',
                    style: const TextStyle(
                        color: Color(0xFFFFFF00),
                        fontWeight: FontWeight.bold),
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
                          icon: const Icon(Icons.arrow_left,
                              color: Colors.white),
                          onPressed: decrease,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 25),
                        Text(
                          '$selectedCount',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(width: 25),
                        IconButton(
                          icon: const Icon(Icons.arrow_right,
                              color: Colors.white),
                          onPressed: () => increase(remainingCount),
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
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2EFFAA),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('투표권 사용'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
