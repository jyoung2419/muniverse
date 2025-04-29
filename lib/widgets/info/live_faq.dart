import 'package:flutter/material.dart';

class LiveFAQ extends StatefulWidget {
  const LiveFAQ({super.key});

  @override
  State<LiveFAQ> createState() => _LiveFAQState();
}

class _LiveFAQState extends State<LiveFAQ> {
  int? _expandedIndex;

  final List<Map<String, String>> faqs = [
    {
      'title': '라이브 구매 후 어디서 볼 수 있나요?',
      'content': '구매 완료 후, 마이페이지 > 이용권 구매 내역에서 확인할 수 있습니다.',
    },
    {
      'title': '구매한 라이브는 몇 번까지 볼 수 있나요?',
      'content': '구매 후 기간 내 무제한 시청이 가능합니다.',
    },
    {
      'title': '결제 취소는 가능한가요?',
      'content': '라이브는 디지털 콘텐츠 특성상 결제 후 취소가 불가합니다.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: const Color(0xFF0B0C0C),
      insetPadding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.1,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      '라이브 FAQ',
                      style: TextStyle(
                        color: Color(0xFF2EFFAA),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: faqs.length,
                itemBuilder: (context, index) => FAQItem(
                  title: faqs[index]['title']!,
                  content: faqs[index]['content']!,
                  isExpanded: _expandedIndex == index,
                  onTap: () {
                    setState(() {
                      _expandedIndex = _expandedIndex == index ? null : index;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          splashColor: Colors.transparent,
          tileColor: Colors.transparent,
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(
            isExpanded ? Icons.expand_less : Icons.expand_more,
            color: Colors.white,
          ),
          onTap: onTap,
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Visibility(
            visible: isExpanded,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF252525),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                content,
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
