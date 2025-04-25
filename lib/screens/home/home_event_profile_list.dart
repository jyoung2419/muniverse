import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/event/event_main_model.dart';
import '../../providers/event/event_main_provider.dart';
import '../../providers/event/event_provider.dart';
import '../title/title_home_screen.dart';

class HomeEventProfileList extends StatefulWidget {
  const HomeEventProfileList({super.key});

  @override
  State<HomeEventProfileList> createState() => _HomeEventProfileListState();
}

class _HomeEventProfileListState extends State<HomeEventProfileList> {
  late final PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(viewportFraction: 0.5);
  }

  @override
  Widget build(BuildContext context) {
    final allEvents = context.watch<EventMainProvider>().events;

    if (allEvents.isEmpty) {
      return const SizedBox.shrink();
    }

    print('🛠 build() 호출됨');
    print('📋 allEvents length: ${allEvents.length}');

    final opened = allEvents.where((e) => e.status != 'PRE_OPEN').toList();
    final upcoming = allEvents.where((e) => e.status == 'PRE_OPEN').toList();
    final filteredEvents = [...opened, ...upcoming];

    print('✅ filteredEvents 최종 length: ${filteredEvents.length}');

    final isMultiple = filteredEvents.length > 2;
    final baseIndex = filteredEvents.indexWhere((e) => e.status != 'PRE_OPEN');
    final initialOffset = ((5 ~/ 2) * filteredEvents.length) + (baseIndex < 0 ? 0 : baseIndex);

    // ✅ build 이후 프레임에서 safe하게 호출
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.hasClients) {
        controller.jumpToPage(initialOffset);
      }
    });

    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.36),
      child: SizedBox(
        height: 130,
        child: isMultiple
            ? PageView.builder(
          controller: controller,
          itemBuilder: (context, index) {
            final event = filteredEvents[index % filteredEvents.length];
            return _buildEventCard(context, event);
          },
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: filteredEvents
              .map((e) => _buildEventCard(context, e))
              .toList(),
        ),
      ),
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
            onTap: isBeforePreOpen
                ? null
                : () {
              print('👉 카드 클릭됨: ${event.eventCode}');
              final fullEvent = Provider.of<EventProvider>(context, listen: false)
                  .getEventByCode(event.eventCode);
              if (fullEvent != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TitleHomeScreen(event: fullEvent),
                  ),
                );
              }
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
              child: const Text(
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
