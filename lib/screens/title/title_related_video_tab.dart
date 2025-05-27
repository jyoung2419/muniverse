import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/event/detail/event_related_provider.dart';
import '../../models/event/detail/event_related_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../widgets/common/translate_text.dart';
import '../../widgets/common/year_filter_drop_down.dart';

class TitleRelatedVideoTab extends StatefulWidget {
  final String eventCode;
  final int? eventYear;

  const TitleRelatedVideoTab({
    super.key,
    required this.eventCode,
    required this.eventYear,
  });

  @override
  State<TitleRelatedVideoTab> createState() => _TitleRelatedVideoTabState();
}

class _TitleRelatedVideoTabState extends State<TitleRelatedVideoTab> {
  late int? _selectedYear;
  final List<YoutubePlayerController> _controllers = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedYear = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventRelatedProvider>(context, listen: false)
          .fetchNextPage(widget.eventCode, eventYear: null);
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final provider = Provider.of<EventRelatedProvider>(context, listen: false);
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!provider.isLoading && !provider.isLastPage) {
        provider.fetchNextPage(widget.eventCode, eventYear: _selectedYear);
      }
    }
  }

  YoutubePlayerController _controllerFromUrl(String url) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    return YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _scrollController.dispose();
    super.dispose();
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
                      .fetchNextPage(widget.eventCode, eventYear: newYear);
                  setState(() {
                    _selectedYear = newYear;
                  });
                },
              ),
            ],
          ),
        ),
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
                    '현재 등록된 관련 영상이 없습니다.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                );
              }

              return ListView.builder(
                physics: const ClampingScrollPhysics(),
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: provider.relatedVideos.length,
                itemBuilder: (context, index) {
                  final EventRelatedModel video = provider.relatedVideos[index];
                  final controller = _controllerFromUrl(video.videoUrl);
                  _controllers.add(controller);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: YoutubePlayer(
                              controller: controller,
                              showVideoProgressIndicator: true,
                              progressIndicatorColor: Colors.redAccent,
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
