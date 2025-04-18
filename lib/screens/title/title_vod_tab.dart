import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/event/event_vod_provider.dart';

class TitleVodTab extends StatefulWidget {
  const TitleVodTab({super.key});

  @override
  State<TitleVodTab> createState() => _TitleVodTabState();
}

class _TitleVodTabState extends State<TitleVodTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventVODProvider>(context, listen: false).fetchDummyVODs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vodList = context.watch<EventVODProvider>().vods;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 필터 (년도)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.filter_alt, color: Colors.white, size: 12),
                    SizedBox(width: 4),
                    Text(
                      '년도',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // VOD 리스트
        Expanded(
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
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
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0, top: 0, right: 10, bottom: 0),
                      child: Container(
                        width: 170,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: AssetImage(
                              vod.profileImageUrl.isNotEmpty
                                  ? vod.profileImageUrl
                                  : 'assets/images/vod.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    // 오른쪽 텍스트 + 버튼
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 12, 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('yyyy.MM.dd').format(vod.createDate),
                              style: const TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              vod.event.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              vod.event.content,
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
                                    // 구매하기 클릭 시 처리 로직
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
