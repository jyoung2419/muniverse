import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/event/detail/event_vod_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/translate_text.dart';
import '../../widgets/common/year_filter_drop_down.dart';
import '../../widgets/info/vod_faq.dart';
import '../../widgets/info/vod_notice.dart';

class TitleVodTab extends StatefulWidget {
  final String eventCode;
  final int? eventYear;

  const TitleVodTab({
    super.key,
    required this.eventCode,
    required this.eventYear,
  });

  @override
  State<TitleVodTab> createState() => _TitleVodTabState();
}

class _TitleVodTabState extends State<TitleVodTab> {
  late int? _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventVODProvider>(context, listen: false)
          .fetchVODs(widget.eventCode, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vodList = context.watch<EventVODProvider>().vods;
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;

    final faqText = 'FAQ';
    final infoText = lang == 'kr' ? '이용안내' : 'INFORMATION';
    final buyText = lang == 'kr' ? '구매하기' : 'BUY';

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
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const VodFAQ(),
                      );
                    },
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      splashFactory: NoSplash.splashFactory,
                    ),
                    icon: const Icon(Icons.help, color: Colors.white, size: 13),
                    label: Text(faqText, style: const TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const VodNotice(),
                      );
                    },
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      splashFactory: NoSplash.splashFactory,
                    ),
                    icon: const Icon(Icons.help, color: Colors.white, size: 13),
                    label: Text(infoText, style: const TextStyle(color: Colors.white, fontSize: 13)),
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
                      Provider.of<EventVODProvider>(context, listen: false)
                          .fetchVODs(widget.eventCode, newYear);
                      setState(() {
                        _selectedYear = newYear;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: vodList.isEmpty
              ? const Center(
            child: TranslatedText(
              '현재 등록된 VOD가 없습니다.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          )
              : ListView.builder(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            itemCount: vodList.length,
            itemBuilder: (context, index) {
              final vod = vodList[index];

              // 👇 여기에 추가
              late String status;
              late String buttonLabel;
              late bool isEnded;

              switch (vod.vodStatus) {
                case 'BE_OPEN':
                  status = lang == 'kr' ? '진행예정' : 'UPCOMING';
                  buttonLabel = lang == 'kr' ? '구매하기' : 'BUY';
                  isEnded = false;
                  break;
                case 'OPEN':
                  status = lang == 'kr' ? '진행중' : 'ONGOING';
                  buttonLabel = lang == 'kr' ? '시청하기' : 'Watch';
                  isEnded = false;
                  break;
                case 'CLOSED':
                  status = lang == 'kr' ? '종료' : 'CLOSED';
                  buttonLabel = lang == 'kr' ? '시청종료' : 'Ended';
                  isEnded = true;
                  break;
                default:
                  status = '';
                  buttonLabel = '';
                  isEnded = true;
              }

              return Container(
                height: 160,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF1A1A1A),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Stack(
                        children: [
                          Container(
                            width: 170,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage(vod.profileImageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isEnded ? Colors.black : const Color(0xFF2EFFAA),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  color: isEnded ? const Color(0xFF2EFFAA) : Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 12, 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${DateFormat('yyyy.MM.dd HH:mm').format(vod.openDate)} ~ ${DateFormat('yyyy.MM.dd HH:mm').format(vod.endDate)}(KST)',
                              style: const TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                            const SizedBox(height: 4),
                            TranslatedText(
                              vod.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TranslatedText(
                              vod.content,
                              style: const TextStyle(color: Colors.white54, fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (buttonLabel == '구매하기' || buttonLabel == 'BUY')
                                  ElevatedButton(
                                    onPressed: () {
                                      print('VOD 구매: ${vod.vodCode}');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2EFFAA),
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      minimumSize: const Size(60, 30),
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
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
                                    onPressed: () {
                                      print('VOD 시청: ${vod.vodCode}');
                                    },
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
                                    onPressed: () {}, // 종료된 경우
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
