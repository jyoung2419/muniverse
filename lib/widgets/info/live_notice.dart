import 'package:flutter/material.dart';

class LiveNotice extends StatefulWidget {
  const LiveNotice({super.key});

  @override
  State<LiveNotice> createState() => _LiveNoticeState();
}

class _LiveNoticeState extends State<LiveNotice> {
  int? _expandedIndex;

  final List<Map<String, String>> notices = [
    {
      'title': '라이브 구매 방법 안내',
      'content': '원하는 라이브를 선택 후, 결제하기 버튼을 통해 구매를 진행할 수 있습니다.',
    },
    {
      'title': '라이브 시청 가능 기간',
      'content': '구매일로부터 지정된 시청 기간 내 자유롭게 이용하실 수 있습니다.',
    },
    {
      'title': '라이브 시청 방법',
      'content': '마이페이지 > 이용권 내역에서 원하는 콘텐츠를 선택해 시청할 수 있습니다.',
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
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      '라이브 이용안내',
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
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: notices.length,
                itemBuilder: (context, index) => NoticeItem(
                  title: notices[index]['title']!,
                  content: notices[index]['content']!,
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

class NoticeItem extends StatelessWidget {
  final String title;
  final String content;
  final bool isExpanded;
  final VoidCallback onTap;

  const NoticeItem({
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
