import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../models/event/event_model.dart';

class TitleDescriptionTab extends StatelessWidget {
  final EventModel event;

  const TitleDescriptionTab({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Html(
        data: event.content,
        style: {
          "body": Style(color: Colors.white),
          "p": Style(fontSize: FontSize(14)),
        },
      ),
    );
  }
}
