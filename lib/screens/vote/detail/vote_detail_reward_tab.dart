import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../../providers/vote/vote_reward_media_provider.dart';
import '../../../models/vote/vote_reward_media_model.dart';

class VoteDetailRewardTab extends StatelessWidget {
  final String voteCode;
  const VoteDetailRewardTab({super.key, required this.voteCode});

  @override
  Widget build(BuildContext context) {
    final mediaList = context.watch<VoteRewardMediaProvider>().mediaList;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '보상 이벤트 결과',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (mediaList.isEmpty)
            const Text('등록된 보상 미디어가 없습니다.',
                style: TextStyle(color: Colors.white54))
          else
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: mediaList.length,
              itemBuilder: (context, index) {
                final media = mediaList[index];

                if (media.type == VoteRewardMediaType.IMAGE) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        media.voteRewardMediaURL,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        media.rewordContent,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                } else if (media.type == VoteRewardMediaType.VIDEO) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _VideoPlayerWidget(videoUrl: media.voteRewardMediaURL),
                      const SizedBox(height: 4),
                      Text(
                        media.rewordContent,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}

class _VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const _VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<_VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<_VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying ? _controller.pause() : _controller.play();
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlay,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: _controller.value.isInitialized
            ? Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            if (!_isPlaying)
              const Icon(Icons.play_circle_outline,
                  size: 64, color: Colors.white),
          ],
        )
            : const SizedBox(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
