import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/vote/vote_model.dart';
import '../../../providers/vote/vote_artist_provider.dart';

class VoteDetailProgressTab extends StatelessWidget {
  final VoteModel vote;
  const VoteDetailProgressTab({super.key, required this.vote});

  @override
  Widget build(BuildContext context) {
    final voteArtists = context.watch<VoteArtistProvider>().getVoteArtistsByVoteCode(vote.voteCode);
    final totalVoteCount = voteArtists.fold(0, (sum, va) => sum + va.voteCount);

    final sortedVoteArtists = [...voteArtists];
    sortedVoteArtists.sort((a, b) => b.voteCount.compareTo(a.voteCount));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('총 참여 인원', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 4),
            Text(
              '$totalVoteCount명',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
            ),
            const SizedBox(height: 16),
            ...sortedVoteArtists.asMap().entries.map((entry) {
              final index = entry.key;
              final voteArtist = entry.value;
              final rate = totalVoteCount == 0 ? 0 : voteArtist.voteCount / totalVoteCount;
              final percentText = (rate * 100).toStringAsFixed(1);
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
                      child: Image.asset(
                        voteArtist.artist.profileUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
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
                                voteArtist.artist.content,
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
                              value: rate.toDouble(),
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
