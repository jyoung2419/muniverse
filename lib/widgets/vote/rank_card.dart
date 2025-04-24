import 'package:flutter/material.dart';

class RankCard extends StatelessWidget {
  final int index;
  final String name;
  final String nameEng;
  final String imageUrl;
  final int percent;
  final IconData icon;
  final Color iconColor;

  const RankCard({
    super.key,
    required this.index,
    required this.name,
    required this.nameEng,
    required this.imageUrl,
    required this.percent,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.fromLTRB(0, 0, 18, 0),
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
                imageUrl,
                width: 130,
                height: 130,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          Text(nameEng, style: const TextStyle(color: Color(0xFFC2C4C8E0), fontSize: 13)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: percent / 100,
                    color: const Color(0xFF2EFFAA),
                    backgroundColor: Colors.grey.shade800,
                    minHeight: 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('$percent%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}