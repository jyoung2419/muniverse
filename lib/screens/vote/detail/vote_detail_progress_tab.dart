import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/vote/vote_detail_provider.dart';
import '../../../widgets/vote/vote_dialog.dart';

class VoteDetailProgressTab extends StatelessWidget {
  final String voteCode;
  const VoteDetailProgressTab({super.key, required this.voteCode});

  @override
  Widget build(BuildContext context) {
    final voteDetail = context.watch<VoteDetailProvider>().voteDetail;

    if (voteDetail == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final lineUp = voteDetail.lineUp;
    final sortedLineUp = [...lineUp]..sort((a, b) => b.votePercent.compareTo(a.votePercent));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            ...sortedLineUp.asMap().entries.map((entry) {
              final index = entry.key;
              final artist = entry.value;
              final percentText = artist.votePercent.toStringAsFixed(1);
              final isFirst = index == 0;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        artist.artistProfileImageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset('assets/images/default_profile.png', width: 60, height: 60),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isFirst ? const Color(0xFF2EFFAA) : const Color(0xFF353C49),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                artist.artistName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            child: LinearProgressIndicator(
                              value: artist.votePercent / 100,
                              minHeight: 8,
                              backgroundColor: Colors.grey.shade800,
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2EFFAA)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => VoteDialog(
                                artistName: artist.artistName,
                                voteCode: voteCode,
                                voteArtistSeq: artist.voteArtistSeq,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2EFFAA),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            minimumSize: const Size(0, 30),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('투표하기', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '$percentText%',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
