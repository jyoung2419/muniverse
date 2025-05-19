import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/back_fab.dart';
import '../../widgets/common/header.dart';
import '../../widgets/common/translate_text.dart';
import '../../widgets/mypage/pin_field_row.dart';
import '../../widgets/mypage/product_card.dart';

class PurchaseHistoryScreen extends StatelessWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;

    final titleText = lang == 'kr' ? '주문 내역' : 'Purchase History';
    final successText = '고객님의 주문이 정상적으로 완료되었습니다.';
    final payDoneText = lang == 'kr' ? '결제 완료' : 'Payment Completed';
    final payInfoText = lang == 'kr' ? '결제 정보 보기' : 'View Payment Info';
    final orderNoText = lang == 'kr' ? '주문번호' : 'Order No.';
    final orderProductText = lang == 'kr' ? '주문 상품' : 'Ordered Products';
    final ticketCodeText = lang == 'kr' ? '이용권 코드' : 'Ticket Code';

    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0C),
      appBar: const Header(),
      endDrawer: const AppDrawer(),
      floatingActionButton: const BackFAB(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Text(
                  titleText,
                  style: const TextStyle(
                    color: Color(0xFF2EFFAA),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TranslatedText(
                successText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              const Divider(color: Colors.white12, thickness: 1),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: '2024.04.02 ',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                        TextSpan(
                          text: payDoneText,
                          style: const TextStyle(
                            color: Color(0xFF2EFFAA),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          payInfoText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 1.5),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '$orderNoText XXXXXXXXXX',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  const Icon(Icons.arrow_circle_right, color: Colors.white, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    orderProductText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(color: Colors.white12, thickness: 1),
              const ProductCard(),
              const Divider(color: Colors.white12, thickness: 1, height: 32),

              Row(
                children: [
                  const Icon(Icons.arrow_circle_right, color: Colors.white, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    ticketCodeText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const PinFieldRow(),
              const PinFieldRow(),
              const PinFieldRow(),
            ],
          ),
        ),
      ),
    );
  }
}
