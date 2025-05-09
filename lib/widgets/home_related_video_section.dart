import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../providers/event/main/event_main_related_provider.dart';

class HomeRelatedVideoSection extends StatelessWidget {
  const HomeRelatedVideoSection({super.key});

  String _extractVideoId(String url) {
    final uri = Uri.parse(url);
    if (uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v']!;
    } else if (uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.last;
    }
    return '';
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
        Builder(
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

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: videos.map((video) {
                  final videoId = _extractVideoId(video.videoUrl);
                  final controller = WebViewController()
                    ..setJavaScriptMode(JavaScriptMode.unrestricted)
                    ..loadRequest(Uri.parse('https://www.youtube.com/embed/$videoId'));

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          child: SizedBox(
                            width: 350,
                            height: 350 * 290 / 510,
                            child: WebViewWidget(controller: controller),
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: 160,
                          child: Text(
                            video.name,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}
