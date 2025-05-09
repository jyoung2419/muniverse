import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/vote/vote_availability_provider.dart';
import 'free_vote_dialog.dart';

class VoteDialog extends StatefulWidget {
  final String artistName;
  final String voteCode;
  final String? voteArtistSeq;

  const VoteDialog({
    super.key,
    required this.artistName,
    required this.voteCode,
    required this.voteArtistSeq,
  });

  @override
  State<VoteDialog> createState() => _VoteDialogState();
}

class _VoteDialogState extends State<VoteDialog> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<VoteAvailabilityProvider>().fetchVoteAvailability(widget.voteCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final availabilityProvider = context.watch<VoteAvailabilityProvider>();
    final remainingCount = availabilityProvider.availability?.remainingCount;

    return Dialog(
      backgroundColor: const Color(0xFF1B1B1D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
            Column(
              children: [
                Text(
                  '${widget.artistName}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                const Text('투표를 진행하시겠습니까?',
                    style: TextStyle(color: Colors.white, fontSize: 14)
                ),
                const SizedBox(height: 8),
                if (availabilityProvider.isLoading)
                  const CircularProgressIndicator()
                else if (availabilityProvider.error != null)
                  Text(
                    availabilityProvider.error!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  )
                else if (remainingCount != null)
                    Text(
                      '남은 무료 투표권: $remainingCount',
                      style: const TextStyle(
                        color: Color(0xFFFFFF00),
                        fontSize: 14,
                      ),
                    ),
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
                        builder: (_) => FreeVoteDialog(
                          voteCode: widget.voteCode,
                          voteArtistSeq: widget.voteArtistSeq,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2EFFAA),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('무료 투표권 선택', style: TextStyle(fontSize: 13)),
                  ),
                ),
                // const SizedBox(width: 6),
                // Expanded(
                //   child: ElevatedButton(
                //     onPressed: () {
                //       // 유료 투표 실행 - 1차 진행 x
                //       Navigator.of(context).pop();
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: const Color(0xFF2EFFAA),
                //       foregroundColor: Colors.black,
                //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                //     ),
                //     child: const Text('유료 투표권 선택',style: TextStyle(fontSize: 13)),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
