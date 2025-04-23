import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeRelatedVideoSection extends StatelessWidget {
  const HomeRelatedVideoSection({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('❌ Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> videos = [
      {
        'thumbnail': 'assets/images/video2.png',
        'title': '부산원아시아 페스티벌(BOF2025) K-POP...',
        'url': 'https://www.youtube.com/watch?v=q_sDeIGSbf0',
      },
      {
        'thumbnail': 'assets/images/video2.png',
        'title': '[2024 MBC 가요대제전] Lee Eunj...',
        'url': 'https://www.youtube.com/watch?v=q_sDeIGSbf0',
      },
      {
        'thumbnail': 'assets/images/video2.png',
        'title': '[2024 MBC 가요대제전] Lee Eunj...',
        'url': 'https://www.youtube.com/watch?v=q_sDeIGSbf0',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '최신 관련영상',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: videos.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final video = videos[index];
              return InkWell(
                onTap: () => _launchUrl(video['url']!),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      child: Image.asset(
                        video['thumbnail']!,
                        width: 170,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 160,
                      child: Text(
                        video['title']!,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
