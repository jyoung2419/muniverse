import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../models/vote/vote_model.dart';
import '../../providers/artist/artist_provider.dart';
import '../../providers/vote/vote_artist_provider.dart';
import '../../providers/vote/vote_provider.dart';
import '../../providers/vote/vote_reward_media_provider.dart';
import '../vote/vote_detail_screen.dart';

class HomeAward extends StatefulWidget {
  final VoteModel vote;

  const HomeAward({super.key, required this.vote});

  @override
  State<HomeAward> createState() => _HomeAwardState();
}

class _HomeAwardState extends State<HomeAward> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 왼쪽 텍스트 영역
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Weekly ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Transform.translate(
                        offset: const Offset(1, -2),
                        child: SvgPicture.asset(
                          'assets/svg/m_logo.svg',
                          height: 26,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: '-Pick',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '4월 1주차 주간인기상 투표에 참여하세요',
                style: TextStyle(
                  color: Color(0xC2C4C8E0),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        // 오른쪽 링크
        TextButton(
          onPressed: () {
            final votes = context.read<VoteProvider>().votes;
            final artists = context.read<ArtistProvider>().artists;

            context.read<VoteRewardMediaProvider>().fetchRewardMedia(votes);
            context.read<VoteArtistProvider>().fetchVoteArtists(
              votes: votes,
              artists: artists,
            );

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => VoteDetailScreen(voteCode: widget.voteCode),
            //   ),
            // );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                '투표하러 가기',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 4),
              Padding(
                padding: EdgeInsets.only(top: 1.5),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
