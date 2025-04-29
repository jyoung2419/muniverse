import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/event/event_vod_provider.dart';

class TitleVodTab extends StatefulWidget {
  final String eventCode;
  final int eventYear;

  const TitleVodTab({
    super.key,
    required this.eventCode,
    required this.eventYear,
  });

  @override
  State<TitleVodTab> createState() => _TitleVodTabState();
}

class _TitleVodTabState extends State<TitleVodTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventVODProvider>(context, listen: false)
          .fetchVODs(widget.eventCode, widget.eventYear);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vodList = context.watch<EventVODProvider>().vods;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left:20, top:14, right:20, bottom:0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // TODO: FAQ 동작
                    },
                    icon: const Icon(Icons.help, color: Colors.white, size: 13),
                    label: const Text('FAQ', style: TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // TODO: 이용안내 동작
                    },
                    icon: const Icon(Icons.help, color: Colors.white, size: 13),
                    label: const Text('이용안내', style: TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                ],
              ),

              // 필터 연도
              Row(
                children: const [
                  Icon(Icons.filter_alt, color: Colors.white, size: 13),
                  SizedBox(width: 4),
                  Text(
                    '2025년',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ),
        // VOD 리스트
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            itemCount: vodList.length,
            itemBuilder: (context, index) {
              final vod = vodList[index];

              return Container(
                height: 140,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF212225),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0x5270737C),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 썸네일
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        width: 170,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(
                              vod.profileImageUrl,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    // 텍스트 + 버튼
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 12, 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Text(
                            //   DateFormat('yyyy.MM.dd').format(vod.createDate),
                            //   style: const TextStyle(color: Colors.white70, fontSize: 11),
                            // ),
                            const SizedBox(height: 4),
                            Text(
                              vod.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              vod.content,
                              style: const TextStyle(color: Colors.white54, fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // TODO: 구매하기 버튼 로직
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
                                  child: const Text(
                                    '구매하기',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
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
