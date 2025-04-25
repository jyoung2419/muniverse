import 'package:flutter/material.dart';
import '../../../models/vote/vote_artist_model.dart';

class VoteArtistProgressTile extends StatelessWidget {
  final int rank;
  final VoteArtistModel artistModel;
  final String percent;

  const VoteArtistProgressTile({
    super.key,
    required this.rank,
    required this.artistModel,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    final artist = artistModel.artist;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Text(
              '$rank',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2EFFAA),
              ),
            ),
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                artist.profileUrl ?? 'assets/images/default_profile.png',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artist.name, // 수정된 부분
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    artist.content, // 수정된 부분
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: double.tryParse(percent)! / 100,
                    minHeight: 8,
                    backgroundColor: Colors.white10,
                    color: const Color(0xFF2EFFAA),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$percent%',
                    style: const TextStyle(fontSize: 10, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {
                // TODO: 투표 로직
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2EFFAA),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('투표'),
            ),
          ],
        ),
      ),
    );
  }
}
