import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/event/main/event_main_related_provider.dart';
import '../common/translate_text.dart';

class HomeRelatedVideoSection extends ConsumerStatefulWidget {
  const HomeRelatedVideoSection({super.key});

  @override
  ConsumerState<HomeRelatedVideoSection> createState() => _HomeRelatedVideoSectionState();
}

class _HomeRelatedVideoSectionState extends ConsumerState<HomeRelatedVideoSection> {
  bool _hasFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final relatedState = ref.read(eventMainRelatedProvider);

    if (!_hasFetched && relatedState is AsyncData && (relatedState.value ?? []).isEmpty) {
      _hasFetched = true;
      Future.microtask(() => ref.read(eventMainRelatedProvider.notifier).fetch());
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
    final relatedState = ref.watch(eventMainRelatedProvider);

    return relatedState.when(
      loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
      error: (err, stack) => const Center(child: Text("관련 영상이 없습니다.", style: TextStyle(color: Colors.white70))),
      data: (groups) {
        if (groups.isEmpty) {
          return const Center(child: Text("관련 영상이 없습니다.", style: TextStyle(color: Colors.white70)));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: groups.map((group) {
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
      },
    );
  }
}