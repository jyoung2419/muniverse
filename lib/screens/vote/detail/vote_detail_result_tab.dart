import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../models/vote/vote_model.dart';
import '../../../providers/vote/vote_artist_provider.dart';
import '../../../widgets/vote/winner_card.dart';
import '../../../widgets/vote/rank_card.dart';

class VoteDetailResultTab extends StatefulWidget {
  final String voteCode;
  const VoteDetailResultTab({super.key, required this.voteCode});

  @override
  State<VoteDetailResultTab> createState() => _VoteDetailResultTabState();
}

class _VoteDetailResultTabState extends State<VoteDetailResultTab> {
  final ScrollController _scrollController = ScrollController();
  bool _showTopButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 300 && !_showTopButton) {
        setState(() => _showTopButton = true);
      } else if (_scrollController.offset <= 300 && _showTopButton) {
        setState(() => _showTopButton = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final voteArtists = context.watch<VoteArtistProvider>().getVoteArtistsByVoteCode(widget.voteCode);
    final totalVoteCount = voteArtists.fold(0, (sum, va) => sum + va.voteCount);
    final sorted = [...voteArtists]..sort((a, b) => b.voteCount.compareTo(a.voteCount));

    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('총 참여 인원', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 4),
              Text('$totalVoteCount명', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
              const SizedBox(height: 16),

              // ✅ WinnerCard
              if (sorted.isNotEmpty)
                WinnerCard(
                  name: sorted[0].artist.name,
                  nameEng: sorted[0].artist.content,
                  imageUrl: sorted[0].artist.profileUrl?? 'assets/images/default_profile.png',
                  percent: ((sorted[0].voteCount / totalVoteCount) * 100).round(),
                ),

              const SizedBox(height: 20),

              // ✅ RankCard 리스트 (2~5위)
              if (sorted.length > 1)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: List.generate(
                      (sorted.length - 1).clamp(0, 4),
                          (i) {
                        final artist = sorted[i + 1];
                        return RankCard(
                          index: i + 1,
                          name: artist.artist.name,
                          nameEng: artist.artist.content,
                          imageUrl: artist.artist.profileUrl?? 'assets/images/default_profile.png',
                          percent: ((artist.voteCount / totalVoteCount) * 100).round(),
                          icon: Icons.emoji_events,
                          iconColor: i == 0 ? Colors.grey : i == 1 ? const Color(0xFFCE9505) : Colors.white24,
                        );
                      },
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // ✅ 6위 이하
              ...sorted.asMap().entries.skip(5).map((entry) {
                final index = entry.key;
                final voteArtist = entry.value;
                final rate = totalVoteCount == 0 ? 0 : voteArtist.voteCount / totalVoteCount;
                final percentText = (rate * 100).toStringAsFixed(1);

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
                          voteArtist.artist.profileUrl ?? 'assets/images/default_profile.png',
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
                                Text('${index + 1}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF353C49),
                                    )),
                                const SizedBox(width: 10),
                                Text(
                                  voteArtist.artist.content,
                                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
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
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                              minimumSize: const Size(0, 30),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('투표종료', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
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
              const SizedBox(height: 80),
            ],
          ),
        ),
        if (_showTopButton)
          Positioned(
            bottom: 40,
            right: 10,
            child: GestureDetector(
              onTap: _scrollToTop,
              child: SvgPicture.asset(
                'assets/scroll_top.svg',
                width: 48,
                height: 48,
              ),
            ),
          ),
      ],
    );
  }
}