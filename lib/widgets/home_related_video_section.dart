import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/event/main/event_main_related_provider.dart';
import 'common/translate_text.dart';

class HomeRelatedVideoSection extends StatefulWidget {
  const HomeRelatedVideoSection({super.key});

  @override
  State<HomeRelatedVideoSection> createState() => _HomeRelatedVideoSectionState();
}

class _HomeRelatedVideoSectionState extends State<HomeRelatedVideoSection> {
  bool _hasFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = context.read<EventMainRelatedProvider>();

    if (!_hasFetched &&
        provider.relatedVideos.isEmpty &&
        provider.error == null &&
        !provider.isLoading) {
      _hasFetched = true;
      Future.microtask(() {
        provider.fetchRelatedVideos();
      });
    }
  }

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TranslatedText(
          '최신 관련영상',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (provider.isLoading)
          const Center(child: CircularProgressIndicator(color: Colors.white))
        else if (provider.error != null)
          const Center(child: Text("관련 영상이 없습니다.", style: TextStyle(color: Colors.white70)))
        else if (provider.relatedVideos.isEmpty)
            const Center(child: Text("관련 영상이 없습니다.", style: TextStyle(color: Colors.white70)))
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: provider.relatedVideos.map((video) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: InkWell(
                      onTap: () => _launchUrl(video.videoUrl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 350,
                              child: AspectRatio(
                                aspectRatio: 510 / 290,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.network(
                                      video.profileImageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                    const Icon(
                                      Icons.play_circle_fill,
                                      color: Colors.white70,
                                      size: 60,
                                    ),
                                  ],
                                ),
                              ),
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
                    ),
                  );
                }).toList(),
              ),
            ),
      ],
    );
  }
}
