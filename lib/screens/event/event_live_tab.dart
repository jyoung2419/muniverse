import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/event/event_streaming_provider.dart';

class EventLiveTab extends StatelessWidget {
  const EventLiveTab({super.key});

  @override
  Widget build(BuildContext context) {
    final streamings = context.watch<EventStreamingProvider>().streamings;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: streamings.length,
      itemBuilder: (context, index) {
        final streaming = streamings[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 배경 이미지
              Image.asset(
                streaming.imagePath ?? 'assets/images/live.png', // 기본 이미지 경로
                fit: BoxFit.cover,
              ),

              // 어두운 오버레이
              Container(
                color: Colors.black.withOpacity(0.8),
              ),

              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      streaming.name,
                      style: const TextStyle(
                        color: Color(0xFFFFFF00),
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Opening Soon',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      DateFormat('yyyy.MM.dd.(EEE)', 'en_US').format(streaming.createDate),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
