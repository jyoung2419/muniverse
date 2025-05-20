import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../providers/event/main/event_main_related_provider.dart';
import '../common/translate_text.dart';

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
        provider.relatedGroups.isEmpty &&
        provider.error == null &&
        !provider.isLoading) {
      _hasFetched = true;
      Future.microtask(() {
        provider.fetchRelatedGroups();
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

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    if (provider.error != null || provider.relatedGroups.isEmpty) {
      return const Center(child: Text("관련 영상이 없습니다.", style: TextStyle(color: Colors.white70)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: provider.relatedGroups.map((group) {
        if (group.relatedDetails.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TranslatedText(
              group.eventShortName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: group.relatedDetails.map((video) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: InkWell(
                      onTap: () => _launchUrl(video.videoUrl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            child: SizedBox(
                              width: 160,
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
            const SizedBox(height: 20),
          ],
        );
      }).toList(),
    );
  }
}
