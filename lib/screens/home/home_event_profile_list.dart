import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/event/event_model.dart';
import '../../providers/event/event_provider.dart';
import '../title/title_home_screen.dart';

class HomeEventProfileList extends StatelessWidget {
  const HomeEventProfileList({super.key});

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;

    if (events.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.36,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: events.take(3).map((event) {
          final bool isBeforePreOpen = event.preOpenDateTime.isAfter(DateTime.now());

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
                    event.profileUrl,
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
        }).toList(),
      ),
    );
  }
}
