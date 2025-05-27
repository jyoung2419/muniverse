import 'package:flutter/material.dart';
import '../../../widgets/common/translate_text.dart';
import '../../../widgets/info/faq_item.dart';

class ProductDetailFAQTab extends StatefulWidget {
  const ProductDetailFAQTab({super.key});

  @override
  State<ProductDetailFAQTab> createState() => _ProductDetailFAQTabState();
}

class _ProductDetailFAQTabState extends State<ProductDetailFAQTab> {
  int? _expandedIndex;

  final List<Map<String, String>> faqs = [
    {
      'title': '본인의 로그인 정보가 아닐 경우 어떻게 하나요?',
      'content': '뮤니버스 티켓 이용약관 제 34조에 따라, 부정한 이름으로 판단되는 경우 해당 고객에 대해 일정 기간 동안 예매차단 또는 예매 취소 조치가 취해질 수 있습니다.\n\n'
          '[ 제한 기간 ]\n'
          '- 부정한 이름으로 판단한 경우, 제한 시점으로부터 3개월간 일부 결제수단 또는 예매 행위가 제한됩니다.\n'
          '- 부정한 이용 이력 자체 전달될 경우, 회원자격은 제한되거나 강제 및 실실취소될 수 있습니다.\n\n'
          '[ 소명 제한 ]\n'
          '- 부정 이용으로 판단되는 고객에게만 제공되며, 1인 이상의 소명기준을 부여합니다.\n'
          '- 부정행위를 부정 방법으로 이용하지 않았음을 증명할 수 있는 소명서를 제출할 경우, 합당한 경우 해당 조치를 해지할 수 있습니다.\n\n'
          '[ 소명서 제출 가이드 ]\n'
          '- 제출서류(캡처/고지서/명세서, 연락처를 포함하여 적합한 방법으로 이용하지 않았음을 상세히 기재해 주세요.\n'
          '- customer@titlecheck.cs.com 으로 접수하고 제목은 [000:0000] 형식으로 적습니다.\n'
          '- 제출 후 10~15일 간의 검토 기간이 필요하며 접수한 문서 착오 확인은 반환되지 않을 수 있습니다.'
    },
    {
      'title': '상품 정보를 정확히 확인하려면 어떻게 하나요?',
      'content': '상품 상세 페이지에서 이미지, 브랜드, 가격, 구성 등을 확인하실 수 있습니다. 궁금한 점이 있다면 고객센터로 문의해주세요.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TranslatedText(
            '총 ${faqs.length}건',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
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
    );
  }
}
