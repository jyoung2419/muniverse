import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/event/event_model.dart';
import '../../providers/event/event_provider.dart';
import '../title/title_home_screen.dart';

class HomeEventProfileList extends StatefulWidget {
  const HomeEventProfileList({super.key});

  @override
  State<HomeEventProfileList> createState() => _HomeEventProfileListState();
}

class _HomeEventProfileListState extends State<HomeEventProfileList> {
  late final PageController controller;
  late final List<EventModel> filteredEvents;
  late final int baseIndex;
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();

    final allEvents = Provider.of<EventProvider>(context, listen: false)
        .events
        .where((e) => e.eventCode != 'code')
        .toList();

    final opened = allEvents.where((e) => !e.preOpenDateTime.isAfter(now)).toList();
    final upcoming = allEvents.where((e) => e.preOpenDateTime.isAfter(now)).toList();
    opened.sort((a, b) => a.preOpenDateTime.compareTo(b.preOpenDateTime));
    upcoming.sort((a, b) => a.preOpenDateTime.compareTo(b.preOpenDateTime));

    filteredEvents = [...opened, ...upcoming];
    final eventCount = filteredEvents.length;
    final repeatCount = 5;
    final initialOffset = (repeatCount ~/ 2) * eventCount;

    baseIndex = filteredEvents.indexWhere((e) => !e.preOpenDateTime.isAfter(now));

    controller = PageController(
      viewportFraction: 0.5,
      initialPage: initialOffset + baseIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (filteredEvents.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.36),
      child: SizedBox(
        height: 130,
        child: PageView.builder(
          controller: controller,
          itemBuilder: (context, index) {
            final event = filteredEvents[index % filteredEvents.length];
            final isBeforePreOpen = event.preOpenDateTime.isAfter(now);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onTap: isBeforePreOpen
                        ? null
                        : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TitleHomeScreen(event: event),
                        ),
                      );
                    },
                    child: Image.asset(
                      event.profileUrl.isNotEmpty
                          ? event.profileUrl
                          : 'assets/images/default_profile.png',
                      width: 180,
                      height: 110,
                      fit: BoxFit.cover,
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
                        border: Border.all(color: Color(0xFF2EFFAA)),
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
          },
        ),
      ),
    );
  }
}
