import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/event/detail/event_related_provider.dart';
import '../../models/event/event_related_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/common/translate_text.dart';
import '../../widgets/common/year_filter_drop_down.dart';

class TitleRelatedVideoTab extends StatefulWidget {
  final String eventCode;
  final int eventYear;

  const TitleRelatedVideoTab({
    super.key,
    required this.eventCode,
    required this.eventYear,
  });

  @override
  State<TitleRelatedVideoTab> createState() => _TitleRelatedVideoTabState();
}

void _launchUrl(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}

class _TitleRelatedVideoTabState extends State<TitleRelatedVideoTab> {
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.eventYear;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventRelatedProvider>(context, listen: false)
          .fetchRelatedVideosByEventCode(widget.eventCode, eventYear: _selectedYear);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 14, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.filter_alt, color: Colors.white, size: 13),
              const SizedBox(width: 4),
              YearFilterDropdown(
                selectedYear: _selectedYear,
                years: [2025, 2024, 2023],
                onChanged: (newYear) {
                  Provider.of<EventRelatedProvider>(context, listen: false)
                      .fetchRelatedVideosByEventCode(widget.eventCode, eventYear: newYear);
                  setState(() {
                    _selectedYear = newYear;
                  });
                },
              ),
            ],
          ),
        ),

        // 관련영상 리스트
        Expanded(
          child: Consumer<EventRelatedProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.error != null) {
                return Center(
                  child: TranslatedText(
                    provider.error!,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }

              if (provider.relatedVideos.isEmpty) {
                return const Center(
                  child: TranslatedText(
                    '관련 영상이 없습니다.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return ListView.builder(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: provider.relatedVideos.length,
                itemBuilder: (context, index) {
                  final EventRelatedModel video = provider.relatedVideos[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => _launchUrl(video.videoUrl),
                            child: AspectRatio(
                              aspectRatio: 510 / 290,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.network(
                                    video.profileImageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
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
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: TranslatedText(
                              video.name,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
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
