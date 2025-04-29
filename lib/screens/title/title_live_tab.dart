import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/event/event_live_provider.dart';

class TitleLiveTab extends StatelessWidget {
  const TitleLiveTab({super.key});

  @override
  Widget build(BuildContext context) {
    final streamings = context.watch<EventLiveProvider>().streamings;
    final now = DateTime.now();

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
        // 📺 스트리밍 리스트
        Expanded(
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            itemCount: streamings.length,
            itemBuilder: (context, index) {
              final item = streamings[index];

              // 상태 계산
              String status;
              if (now.isBefore(item.taskDate)) {
                status = '진행예정';
              } else if (now.isAfter(item.taskEndDate)) {
                status = '종료';
              } else {
                status = '진행중';
              }

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
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            width: 170,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: AssetImage(item.profileImageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        // 상태 뱃지
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: status == '종료' ? Colors.black : const Color(0xFF2EFFAA),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: status == '종료'
                                    ? const Color(0xFF2EFFAA)
                                    : Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // 오른쪽 영역
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 12, 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${DateFormat('yyyy.MM.dd HH:mm').format(item.taskDate)} ~ ${DateFormat('HH:mm').format(item.taskEndDate)}(KST)',
                              style: const TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.content,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // TODO: 시청하기 버튼 처리
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
                                    '시청하기',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            )
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
