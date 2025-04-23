import 'package:flutter/material.dart';

class VotingResultList extends StatefulWidget {
  const VotingResultList({super.key});

  @override
  State<VotingResultList> createState() => _VotingResultListState();
}

class _VotingResultListState extends State<VotingResultList> {
  final ScrollController _scrollController = ScrollController();

  final names = ['태민', '방탄소년단 뷔', '블랙핑크', 'The KingDom', '르세라핌'];
  final namesEng = ['TAEMIN', 'BTS V', 'BLACK PINK', 'The KingDom', 'LESSERAFIM'];
  final percents = [56, 23, 18, 12, 6];
  final images = [
    'artist/taemin.png',
    'artist/btsv.png',
    'artist/blackpink.png',
    'artist/thekingdom.png',
    'artist/lesserafim.png',
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildRankCard({
    required int index,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      width: 150,
      padding: const EdgeInsets.fromLTRB(0,0,18,0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(width: 4),
              Text('${index + 1}위', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/${images[index]}',
                width: 130,
                height: 130,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(names[index],
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          Text(namesEng[index],
              style: const TextStyle(color: Color(0xFFC2C4C8E0), fontSize: 13)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: percents[index] / 100,
                    color: const Color(0xFF2EFFAA),
                    backgroundColor: Colors.grey.shade800,
                    minHeight: 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${percents[index]}%',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🥇 1위
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 350),
          height: 350,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF71C8C3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _TagBox(text: '종료'),
                  Text('WINNER', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  Icon(Icons.emoji_events, color: Colors.white, size: 28),
                ],
              ),
              const Text('이 주의 아이돌은?', style: TextStyle(color: Colors.black87, fontSize: 20)),
              const SizedBox(height: 10),
              SizedBox(
                width: 185,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 185,
                      height: 185,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF2EFFAA), width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/artist/taemin.png',
                          width: 185,
                          height: 185,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${names[0]} ${namesEng[0]}',
                      style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: percents[0] / 100,
                              color: const Color(0xFF2EFFAA),
                              backgroundColor: Colors.grey.shade500,
                              minHeight: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${percents[0]}%',
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // 🥈 2위 ~ 5위 가로 스크롤
        ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            radius: const Radius.circular(8),
            thickness: 6,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 60),
              child: Row(
                children: [
                  buildRankCard(index: 1, icon: Icons.emoji_events, iconColor: Colors.grey),
                  buildRankCard(index: 2, icon: Icons.emoji_events, iconColor: Color(0xFFCE9505)),
                  buildRankCard(index: 3, icon: Icons.emoji_events, iconColor: Colors.white24),
                  buildRankCard(index: 4, icon: Icons.emoji_events, iconColor: Colors.white24),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TagBox extends StatelessWidget {
  final String text;
  const _TagBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF2EFFAA),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
