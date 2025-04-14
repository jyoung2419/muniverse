import 'package:flutter/material.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/back_fab.dart';
import '../../widgets/info/faq_item.dart';
import '../../widgets/common/header.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  int? _expandedIndex;

  final List<Map<String, String>> faqs = [
    {
      'title': 'Q. 부정적인 예매로 아이디가 제한되었다고 합니다. 어떻게 해야하나요?',
      'content': '''
뮤니버스 티켓 이용약관 제 34조에 따라, 부정한 이용으로 판단되는 경우 해당 고객에 대해 일정 기간 동안 예매 제한 또는 예매 취소 조치가 취해질 수 있습니다.

[ 제한 기간 ]
• 부정한 이용으로 판단될 경우, 제한 시점으로부터 3개월간 일부 결제수단 혹은 예매 행위가 제한됩니다.
• 부정한 이용이 여러 차례 적발될 경우, 회원자격을 제한하거나 정지 및 상실시킬 수 있습니다.

[ 소명 제출 ]
• 부정한 이용으로 판단되는 고객에게는 제한 즉시, 1일 이상의 소명기간을 부여합니다.
• 기한 내에 부정한 방법으로 이용하지 않았음을 소명할 수 있는 소명서를 제출할 경우, 합당한 경우 해당 조치를 해지할 수 있습니다.

[ 소명서 제출 가이드 ]
• 제한된 계정(ID)과 고객 성함, 연락처를 포함하여 부정한 방법으로 이용하지 않았음을 상세히 기재해 주세요.
• 고객센터 메일(ticket_cs@mbc.com)로 발송 후 전화번호 [0000-0000]로 연락해주세요.
• 제출 후 10-15일 간의 검토 기간을 거쳐 소명접수 결과를 문자 혹은 메일로 받아보실 수 있습니다.
'''
    },
    {
      'title': 'Q. 본인의 로그인 정보가 아닐 경우 어떻게 하나요?',
      'content': '고객센터에 연락해주세요.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: const Header(),
      endDrawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'FAQ',
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
            const Center(
              child: Text(
                '자주 묻는 질문',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
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
      floatingActionButton: const BackFAB(),
    );
  }
}
