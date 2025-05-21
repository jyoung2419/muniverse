import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/flutter_html.dart' as html;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/event/detail/event_model.dart';
import '../../providers/event/detail/event_info_provider.dart';
import '../../widgets/common/translate_text.dart';

class TitleDescriptionTab extends StatefulWidget {
  final EventModel event;
  const TitleDescriptionTab({super.key, required this.event});

  @override
  State<TitleDescriptionTab> createState() => _TitleDescriptionTabState();
}

class _TitleDescriptionTabState extends State<TitleDescriptionTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<EventInfoProvider>().fetchEventInfo(widget.event.eventCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventInfoProvider>();

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(child: TranslatedText(provider.error!, style: const TextStyle(color: Colors.red)));
    }

    final content = provider.eventInfo?.content ?? '';

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Html(
        data: content,
        style: {
          "*": Style(color: Colors.white),
          "body": Style(
            color: Colors.white70,
            lineHeight: LineHeight(1.2),
          ),
          "li": Style(color: Colors.white),
          "p": Style(color: Colors.white),
          "h1": Style(color: Colors.white, fontSize: FontSize(14), fontWeight: FontWeight.w600, margin: Margins.zero),
          "h2": Style(color: Colors.white, fontSize: FontSize(12), fontWeight: FontWeight.w600, margin: Margins.zero),
          "h3": Style(color: Colors.white, fontSize: FontSize(10), fontWeight: FontWeight.w600, margin: Margins.zero),
        },
        extensions: [
          TagExtension(
            tagsToExtend: {"oembed"},
            builder: (context) {
              final url = context.element?.attributes['url'];
              if (url != null && url.contains("youtube.com")) {
                final videoId = Uri.parse(url).queryParameters['v'];
                if (videoId != null) {
                  final thumbnail = 'https://img.youtube.com/vi/$videoId/0.jpg';
                  return GestureDetector(
                    onTap: () async {
                      final uri = Uri.parse(url);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(thumbnail),
                        const SizedBox(height: 8),
                        const TranslatedText("▶ YouTube 영상 보기", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  );
                }
              }
              return const SizedBox.shrink();
            },
          ),
          html.TagExtension(
            tagsToExtend: {"img"},
            builder: (context) {
              final src = context.attributes['src'] ?? '';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Image.network(
                  src,
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context.buildContext!).size.width - 32,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
