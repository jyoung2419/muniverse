import 'package:flutter/material.dart';
import '../../models/event/event_model.dart';

class TitleDescriptionTab extends StatelessWidget {
  final EventModel event;

  const TitleDescriptionTab({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
