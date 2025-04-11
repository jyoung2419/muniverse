import 'package:flutter/material.dart';

class NoticeItem extends StatefulWidget {
  final String title;
  final String date;
  final String content;
  final bool isExpanded;
  final VoidCallback onTap;

  const NoticeItem({
    super.key,
    required this.title,
    required this.date,
    required this.content,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<NoticeItem> createState() => _NoticeItemState();
}

class _NoticeItemState extends State<NoticeItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          splashColor: Colors.transparent,
          tileColor: Colors.transparent,
          title: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '등록일: ${widget.date}',
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
          ),
          trailing: Icon(
            widget.isExpanded ? Icons.expand_less : Icons.expand_more,
            color: Colors.white,
          ),
          onTap: widget.onTap,
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 100),
          crossFadeState: widget.isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF252525),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              widget.content,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),

        ),
        const Divider(color: Colors.white10),
      ],
    );
  }
}
