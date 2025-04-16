import 'package:flutter/material.dart';
import '../../models/event/event_model.dart';

class EventDescriptionTab extends StatelessWidget {
  final EventModel event;

  const EventDescriptionTab({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Image.asset(
          event.profileUrl,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }
}
