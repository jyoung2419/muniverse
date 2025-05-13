import 'package:flutter/material.dart';
import 'package:muniverse_app/widgets/common/translate_text.dart';

class FAQItem extends StatefulWidget {
  final String title;
  final String content;
  final bool isExpanded;
  final VoidCallback onTap;

  const FAQItem({
    super.key,
    required this.title,
    required this.content,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          splashColor: Colors.transparent,
          tileColor: Colors.transparent,
          title: TranslatedText(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
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
              child: TranslatedText(
                widget.content,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),
          ),
        ),
        const Divider(color: Colors.white10),
      ],
    );
  }
}
