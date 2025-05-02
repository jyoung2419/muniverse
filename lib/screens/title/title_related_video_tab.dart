import 'package:flutter/material.dart';
import '../../models/event/detail/event_model.dart';

class TitleRelatedVideoTab extends StatelessWidget {
  final EventModel event;

  const TitleRelatedVideoTab({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Image.asset(
          event.profileUrl,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }
}
