import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/event/event_live_provider.dart';
import '../../widgets/info/live_faq.dart';
import '../../widgets/info/live_notice.dart';

class TitleLiveTab extends StatefulWidget {
  final String eventCode;
  final int eventYear;

  const TitleLiveTab({
    super.key,
    required this.eventCode,
    required this.eventYear,
  });

  @override
  State<TitleLiveTab> createState() => _TitleLiveTabState();
}

class _TitleLiveTabState extends State<TitleLiveTab> {
  late int _selectedYear;
  @override
  void initState() {
    super.initState();
    _selectedYear = widget.eventYear;

  WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventLiveProvider>(context, listen: false)
          .fetchLives(widget.eventCode, widget.eventYear);
    });
  }

  @override
  Widget build(BuildContext context) {
    final lives = context.watch<EventLiveProvider>().lives;
    final now = DateTime.now();

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
                        builder: (context) => const LiveFAQ(),
                      );
                    },
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      splashFactory: NoSplash.splashFactory,
                    ),
                    icon: const Icon(Icons.help, color: Colors.white, size: 13),
                    label: const Text('FAQ', style: TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const LiveNotice(),
                      );
                    },
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      splashFactory: NoSplash.splashFactory,
                    ),
                    icon: const Icon(Icons.help, color: Colors.white, size: 13),
                    label: const Text('이용안내', style: TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.filter_alt, color: Colors.white, size: 13),
                  const SizedBox(width: 4),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _selectedYear,
                      dropdownColor: const Color(0xFF212225),
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      icon: const SizedBox.shrink(),
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          Provider.of<EventLiveProvider>(context, listen: false)
                              .fetchLives(widget.eventCode, newValue);
                          setState(() {
                            _selectedYear = newValue;
                          });
                        }
                      },
                      items: [2025, 2024, 2023].map((year) {
                        return DropdownMenuItem<int>(
                          value: year,
                          child: Text('$year년'),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            itemCount: lives.length,
            itemBuilder: (context, index) {
              final item = lives[index];

              // 상태 계산
              String status;
              if (now.isBefore(item.taskDateTime)) {
                status = '진행예정';
              } else if (now.isAfter(item.taskEndDateTime)) {
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
                                image: NetworkImage(item.profileImageURL),
                                fit: BoxFit.cover,
                              ),
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
                              color: status == '종료' ? Colors.black : const Color(0xFF2EFFAA),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: status == '종료' ? const Color(0xFF2EFFAA) : Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 12, 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${DateFormat('yyyy.MM.dd HH:mm').format(item.taskDateTime)} ~ ${DateFormat('HH:mm').format(item.taskEndDateTime)}(KST)',
                              style: const TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.name,
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.content,
                              style: const TextStyle(color: Colors.white54, fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // TODO: 시청하기 동작
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
