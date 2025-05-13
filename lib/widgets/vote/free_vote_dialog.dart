import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/vote/vote_availability_provider.dart';
import '../../providers/vote/vote_detail_provider.dart';
import '../../services/vote/vote_submit_service.dart';
import '../../utils/dio_client.dart';
import '../common/translate_text.dart';

class FreeVoteDialog extends StatefulWidget {
  final String voteCode;
  final String? voteArtistSeq;

  const FreeVoteDialog({super.key, required this.voteCode, required this.voteArtistSeq});

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
    final lang = context.read<LanguageProvider>().selectedLanguageCode;
    final voteAvailableText = lang == 'kr'
        ? '총 $remainingCount회 투표 가능합니다.'
        : 'You can vote $remainingCount times.';
    final unitLabel = lang == 'kr' ? '장' : 'tickets';

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
                TranslatedText('무료 투표권',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const TranslatedText('사용할 투표권 수 선택', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 4),
            Text(
              voteAvailableText,
              style: const TextStyle(color: Colors.white),
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
                Text(unitLabel, style: TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (widget.voteArtistSeq == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('❌ artistSeq 없음')),
                    );
                    return;
                  }
                  try {
                    final dio = DioClient().dio;
                    final result = await VoteSubmitService(dio).submitVote(
                      voteArtistSeq: widget.voteArtistSeq!,
                      voteRequestCount: selectedCount,
                    );
                    if (result.success) {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          backgroundColor: const Color(0xFF1B1B1D),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle, color: Color(0xFF2EFFAA), size: 30),
                                const SizedBox(height: 12),
                                const TranslatedText(
                                  '투표 완료!',
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.of(context, rootNavigator: true).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        context.read<VoteDetailProvider>().fetchVoteDetail(widget.voteCode);
                      });
                    }
                  } catch (e) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('❌ 투표 중 오류 발생')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2EFFAA),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const TranslatedText('투표권 사용'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
