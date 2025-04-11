import 'package:flutter/material.dart';
import '../../services/page_control.dart';
import '../../widgets/muniverse_text.dart';
import '../../widgets/info/notice_item.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  int? _expandedIndex;

  final List<Map<String, String>> notices = [
    {
      'title': '[안내] 2025 MUNIVERSE 서비스 정기점검 안내',
      'date': '2025-04-09',
      'content': '4월 10일 02:00 ~ 06:00까지 서비스 점검이 진행됩니다.'
    },
    {
      'title': '[이벤트] 2025 MOKPO MUSICPLAY 투표 이벤트 오픈!',
      'date': '2025-04-08',
      'content': '이벤트에 참여하고 선물을 받아보세요! 투표는 4/15까지 가능합니다.'
    },
    {
      'title': '[업데이트] 아티스트 상세 페이지 리뉴얼 안내',
      'date': '2025-04-08',
      'content': '아티스트 상세 페이지가 더욱 보기 좋게 리뉴얼 되었습니다.'
    },
    {
      'title': '[공지] 회원가입 시 이메일 인증 방식 변경 안내',
      'date': '2025-04-08',
      'content': '보안을 위해 이메일 인증 방식이 개선되었습니다.'
    },
    {
      'title': '[공지] 개인정보처리방침 변경 안내 (5월 1일부터)',
      'date': '2025-04-08',
      'content': '2025년 5월 1일부터 새로운 개인정보처리방침이 적용됩니다.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          iconSize: 18,
          padding: const EdgeInsets.only(left: 12),
          onPressed: () => PageControl.back(context),
        ),
        title: const MuniverseText(fontSize: 28),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.menu, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Center(
              child: Text(
                '공지사항',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(
              color: Color(0xFF6377C7),
              thickness: 1.5,
              height: 1,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: notices.length,
                itemBuilder: (context, index) => NoticeItem(
                  title: notices[index]['title']!,
                  date: notices[index]['date']!,
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
