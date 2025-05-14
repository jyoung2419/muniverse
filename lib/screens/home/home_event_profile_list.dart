import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/event/main/event_main_model.dart';
import '../../providers/event/main/event_main_provider.dart';
import 'dart:math';
import '../../widgets/common/translate_text.dart';
import '../title/title_home_screen.dart';

class HomeEventProfileList extends StatefulWidget {
  const HomeEventProfileList({super.key});

  @override
  State<HomeEventProfileList> createState() => _HomeEventProfileListState();
}

class _HomeEventProfileListState extends State<HomeEventProfileList> {
  late final PageController controller;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = PageController(
      initialPage: 0,
      viewportFraction: 0.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    final allEvents = context.watch<EventMainProvider>().events;

    if (allEvents.isEmpty) return const SizedBox.shrink();

    final opened = allEvents.where((e) => e.status != 'PRE_OPEN').toList();
    final upcoming = allEvents.where((e) => e.status == 'PRE_OPEN').toList();
    final filteredEvents = [...opened, ...upcoming];

    if (filteredEvents.isNotEmpty) {
      filteredEvents.removeAt(0);
    }

    final isMultiple = filteredEvents.length > 2;
    final indicatorCount = (filteredEvents.length / 2).ceil();

    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 130,
            child:PageView.builder(
              controller: controller,
              itemCount: filteredEvents.length,
              clipBehavior: Clip.none,
              padEnds: false,
              onPageChanged: (index) {
                setState(() {
                  currentPageIndex = (index / 2).floor();
                });
              },
              itemBuilder: (context, index) {
                final event = filteredEvents[index];
                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 10.0 : 1.0,
                    right: index == filteredEvents.length - 1 ? 10.0 : 1.0,
                  ),
                  child: _buildEventCard(context, event),
                );
              },
            ),

          ),
          const SizedBox(height: 8),
          if (isMultiple) _buildPageIndicator(indicatorCount),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentPageIndex;
        return Container(
          width: isActive ? 10 : 6,
          height: isActive ? 10 : 6,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? const Color(0xFF2EFFAA) : Colors.white24,
          ),
        );
      }),
    );
  }

  Widget _buildEventCard(BuildContext context, EventMainModel event) {
    print('🖼 카드 렌더링: ${event.eventCode}, 상태: ${event.status}');
    final isBeforePreOpen = event.status == 'PRE_OPEN';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TitleHomeScreen(eventCode: event.eventCode),
                ),
              );
            },
            child: Image.network(
              event.cardUrl,
              width: 180,
              height: 110,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                print('❌ 이미지 로드 실패: $error');
                return Container(
                  width: 180,
                  height: 110,
                  color: Colors.grey,
                  child: const Icon(Icons.error, color: Colors.red),
                );
              },
            ),
          ),
          if (isBeforePreOpen)
            Container(
              width: 180,
              height: 110,
              color: Colors.black.withOpacity(0.6),
            ),
          if (isBeforePreOpen)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF2EFFAA)),
              ),
              child: TranslatedText(
                '오픈 예정',
                style: TextStyle(
                  color: Color(0xFF2EFFAA),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
