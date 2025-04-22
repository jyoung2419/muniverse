import 'package:flutter/material.dart';

class VotingProgressList extends StatelessWidget {
  const VotingProgressList({super.key});

  @override
  Widget build(BuildContext context) {
    final names = ['태민', '방탄소년단 뷔', '블랙핑크', 'The KingDom', '르세라핌'];
    final namesEng = ['SHINee', 'BTS V', 'BLACK PINK', 'The KingDom', 'LESSERAFIM'];
    final percents = [56, 23, 18, 12, 6];
    final images = [
      'artist/shinee.png',
      'artist/btsv.png',
      'artist/blackpink.png',
      'artist/thekingdom.png',
      'artist/lesserafim.png',
    ];

    return Column(
      children: List.generate(5, (index) {
        final rank = index + 1;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Text('$rank ', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 6),
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFC2C4C8E0), width: 1),
                  image: DecorationImage(
                    image: AssetImage('assets/images/${images[index]}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      names[index],
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            namesEng[index],
                            style: const TextStyle(color: Color(0xFFC2C4C8E0), fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          '${percents[index]}%',
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                        height: 10,
                        child: LinearProgressIndicator(
                          value: percents[index] / 100,
                          color: const Color(0xFF2EFFAA),
                          backgroundColor: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
