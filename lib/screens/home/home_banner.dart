import 'package:flutter/material.dart';
import '../../models/event/event_model.dart';
import '../event/title_home_screen.dart';

class HomeBanner extends StatelessWidget {
  final EventModel event;

  const HomeBanner({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TitleHomeScreen(event: event),
          ),
        );
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.48,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(0), // 필요 시 모서리 둥글게
          child: Image.asset(
            event.bannerUrl,
            fit: BoxFit.cover, // 화면 꽉 채우기
          ),
        ),
      ),
    );
  }
}
