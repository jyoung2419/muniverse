import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import '../../../providers/vote/vote_detail_provider.dart';
import '../../../widgets/common/translate_text.dart';
import '../../../widgets/vote/vote_dialog.dart';

class VoteDetailProgressTab extends StatefulWidget {
  final String voteCode;
  const VoteDetailProgressTab({super.key, required this.voteCode});

  @override
  State<VoteDetailProgressTab> createState() => _VoteDetailProgressTabState();
}

class _VoteDetailProgressTabState extends State<VoteDetailProgressTab> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final voteDetail = context.watch<VoteDetailProvider>().voteDetail;
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;

    if (voteDetail == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final lineUp = voteDetail.lineUp;
    final sortedLineUp = [...lineUp]..sort((a, b) => b.votePercent.compareTo(a.votePercent));

    final filteredLineUp = sortedLineUp.where((artist) {
      return artist.artistName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: '검색',
              hintStyle: const TextStyle(color: Colors.white54),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width:0.5),
              ),filled: true,
              fillColor: Colors.black,
            ),
            style: const TextStyle(color: Colors.white, fontSize: 13),
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
          ),
          const SizedBox(height: 16),
          if (filteredLineUp.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  '일치하는 후보가 없습니다.',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredLineUp.length,
              itemBuilder: (context, index) {
                final artist = filteredLineUp[index];
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
                          errorBuilder: (_, __, ___) =>
                              Image.asset('assets/images/default_profile.png', width: 60, height: 60),
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
                                TranslatedText(
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
                            LinearProgressIndicator(
                              value: artist.votePercent / 100,
                              minHeight: 8,
                              backgroundColor: Colors.grey.shade800,
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2EFFAA)),
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
                                  voteCode: widget.voteCode,
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
                            child: Text(
                              lang == 'kr' ? '투표하기' : 'VOTE',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
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
              },
            ),
        ],
      ),
    );
  }
}
