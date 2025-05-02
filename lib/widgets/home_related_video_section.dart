import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/event/main/event_main_related_provider.dart';

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
    final provider = context.watch<EventMainRelatedProvider>();

    // 최초 로드
    if (provider.relatedVideos.isEmpty && !provider.isLoading && provider.error == null) {
      Future.microtask(() => context.read<EventMainRelatedProvider>().fetchRelatedVideos());
    }

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
          child: Builder(
            builder: (context) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.error != null) {
                return Center(child: Text(provider.error!, style: const TextStyle(color: Colors.red)));
              }

              final videos = provider.relatedVideos;

              if (videos.isEmpty) {
                return const Center(child: Text("영상이 없습니다.", style: TextStyle(color: Colors.white70)));
              }

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: videos.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return InkWell(
                    onTap: () => _launchUrl(video.videoUrl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          child: Image.network(
                            video.profileImageUrl,
                            width: 170,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: 160,
                          child: Text(
                            video.name,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
