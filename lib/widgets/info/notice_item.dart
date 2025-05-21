import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';

class NoticeItem extends StatefulWidget {
  final String title;
  final DateTime? createDate;
  final String content;
  final bool isExpanded;
  final VoidCallback onTap;

  const NoticeItem({
    super.key,
    required this.title,
    required this.createDate,
    required this.content,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<NoticeItem> createState() => _NoticeItemState();
}

class _NoticeItemState extends State<NoticeItem> {
  String get formattedDate =>
      widget.createDate != null
          ? DateFormat('yyyy / MM / dd').format(widget.createDate!)
          : '-';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          splashColor: Colors.transparent,
          tileColor: Colors.transparent,
          title: Row(
            children: [
              const Icon(
                Icons.arrow_circle_right,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              formattedDate,
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
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Visibility(
            visible: widget.isExpanded,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF252525),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Html(
                data: widget.content,
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
              ),
            ),
          ),
        ),
        const Divider(color: Colors.white10),
      ],
    );
  }
}
