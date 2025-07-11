import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/event/detail/event_live_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/build_badge.dart';
import '../../widgets/common/translate_text.dart';
import '../../widgets/common/year_filter_drop_down.dart';
import '../../widgets/info/live_faq.dart';
import '../../widgets/info/live_notice.dart';

class TitleLiveTab extends ConsumerStatefulWidget {
  final String eventCode;
  final int? eventYear;

  const TitleLiveTab({
    super.key,
    required this.eventCode,
    required this.eventYear,
  });

  @override
  ConsumerState<TitleLiveTab> createState() => _TitleLiveTabState();
}

class _TitleLiveTabState extends ConsumerState<TitleLiveTab> {
  late int? _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eventLiveProvider.notifier).fetchLives(widget.eventCode, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final lives = ref.watch(eventLiveProvider);
    final lang = context.read<LanguageProvider>().selectedLanguageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 14, right: 20, bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => const LiveFAQ(),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      overlayColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                    ),
                    icon: const Icon(Icons.help, color: Colors.white, size: 13),
                    label: const Text('FAQ', style: TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                  TextButton.icon(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => const LiveNotice(),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      overlayColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                    ),
                    icon: const Icon(Icons.help, color: Colors.white, size: 13),
                    label: Text(
                      lang == 'kr' ? '이용안내' : 'INFORMATION',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.filter_alt, color: Colors.white, size: 13),
                  const SizedBox(width: 4),
                  YearFilterDropdown(
                    selectedYear: _selectedYear,
                    years: [2025, 2024, 2023],
                    onChanged: (newYear) {
                      setState(() {
                        _selectedYear = newYear;
                      });
                      ref.read(eventLiveProvider.notifier).fetchLives(widget.eventCode, newYear);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: lives.isEmpty
              ? const Center(
            child: TranslatedText(
              '현재 예정된 LIVE가 없습니다.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          )
              : ListView.builder(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 85),
            itemCount: lives.length,
            itemBuilder: (context, index) {
              final item = lives[index];
              final now = DateTime.now();

              late String status;
              late String buttonLabel;
              late bool isEnded;

              if (now.isBefore(item.taskDateTime)) {
                status = lang == 'kr' ? '진행예정' : 'UPCOMING';
                buttonLabel = lang == 'kr' ? '구매하기' : 'BUY';
                isEnded = false;
              } else if (now.isAfter(item.taskEndDateTime)) {
                status = lang == 'kr' ? '종료' : 'CLOSED';
                buttonLabel = lang == 'kr' ? '시청종료' : 'Ended';
                isEnded = true;
              } else {
                status = lang == 'kr' ? '진행중' : 'ONGOING';
                buttonLabel = lang == 'kr' ? '시청하기' : 'Watch';
                isEnded = false;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: const Color(0xFF1A1A1A),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                          child: AspectRatio(
                            aspectRatio: 1.58,
                            child: Image.network(
                              item.profileImageURL,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: BuildBadge(
                            text: status,
                            color: isEnded ? Colors.black : const Color(0xFF2EFFAA),
                            textColor: isEnded ? const Color(0xFF2EFFAA) : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${DateFormat('yyyy.MM.dd HH:mm').format(item.taskDateTime)}(KST) ~ ${DateFormat('yyyy.MM.dd HH:mm').format(item.taskEndDateTime)}(KST)',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          TranslatedText(
                            item.name,
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          TranslatedText(
                            item.content,
                            style: const TextStyle(color: Colors.white54, fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (buttonLabel == '구매하기' || buttonLabel == 'BUY')
                                ElevatedButton(
                                  onPressed: () {
                                    DefaultTabController.of(context)?.animateTo(1);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2EFFAA),
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    minimumSize: const Size(60, 30),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    buttonLabel,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              else if (buttonLabel == '시청하기' || buttonLabel == 'Watch')
                                OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF2EFFAA),
                                    side: const BorderSide(color: Color(0xFF2EFFAA), width: 1),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    minimumSize: const Size(60, 30),
                                  ),
                                  child: Text(
                                    buttonLabel,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF2EFFAA),
                                    ),
                                  ),
                                )
                              else
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0x66B0B0B0),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    minimumSize: const Size(60, 30),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    buttonLabel,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF171719),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
