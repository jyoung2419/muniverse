import 'package:flutter/material.dart';
import '../../../models/candidate_model.dart';
import 'package:intl/intl.dart';

class HomeCandidateList extends StatelessWidget {
  final List<Candidate> candidates;

  const HomeCandidateList({super.key, required this.candidates});

  @override
  Widget build(BuildContext context) {
    final totalVotes = candidates.fold<int>(0, (sum, c) => sum + c.voteCount);
    final formatter = NumberFormat('#,###');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: candidates.map((candidate) {
        final percentage = totalVotes == 0
            ? 0.0
            : candidate.voteCount / totalVotes * 100;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  candidate.imageUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      candidate.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: percentage / 100,
                      color: const Color(0xFF8439FA),
                      backgroundColor: Colors.white10,
                      minHeight: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${formatter.format(candidate.voteCount)}표',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
