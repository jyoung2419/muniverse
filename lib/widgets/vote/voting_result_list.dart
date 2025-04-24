import 'package:flutter/material.dart';
import 'package:muniverse_app/widgets/vote/rank_card.dart';
import 'package:muniverse_app/widgets/vote/winner_card.dart';

import '../common/tag_box.dart';

class VotingResultList extends StatelessWidget {
  const VotingResultList({super.key});

  final names = const ['태민', '방탄소년단 뷔', '블랙핑크', 'The KingDom', '르세라핌'];
  final namesEng = const ['TAEMIN', 'BTS V', 'BLACK PINK', 'The KingDom', 'LESSERAFIM'];
  final percents = const [56, 23, 18, 12, 6];
  final images = const [
    'artist/taemin.png',
    'artist/btsv.png',
    'artist/blackpink.png',
    'artist/thekingdom.png',
    'artist/lesserafim.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WinnerCard(
          name: names[0],
          nameEng: namesEng[0],
          imageUrl: 'assets/images/${images[0]}',
          percent: percents[0],
        ),
        const SizedBox(height: 20),
        ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: Scrollbar(
            radius: const Radius.circular(8),
            thickness: 6,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: List.generate(4, (i) => RankCard(
                  index: i + 1,
                  name: names[i + 1],
                  nameEng: namesEng[i + 1],
                  imageUrl: 'assets/images/${images[i + 1]}',
                  percent: percents[i + 1],
                  icon: Icons.emoji_events,
                  iconColor: i == 0 ? Colors.grey : i == 1 ? Color(0xFFCE9505) : Colors.white24,
                )),
              ),
            ),
          ),
        )
      ],
    );
  }
}