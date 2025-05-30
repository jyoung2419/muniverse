import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../widgets/common/app_drawer.dart';
import '../../../widgets/common/back_fab.dart';
import '../../../widgets/common/header.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/translate_text.dart';
import '../product/product_main_screen.dart';
import 'order_sheet_screen.dart';

class OrderFailScreen extends StatelessWidget {
  final String eventName;
  final String imageUrl;
  final String productName;
  final int quantity;
  final double price;
  final double fee;
  final String currencyType;
  final String orderStatus;
  final String productCode;
  final String viewType;

  const OrderFailScreen({
    super.key,
    required this.eventName,
    required this.imageUrl,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.fee,
    required this.currencyType,
    required this.orderStatus,
    required this.productCode,
    required this.viewType,
  });

  String _statusMessage(String status, String lang) {
    switch (status) {
      case 'PENDING_PAYMENT':
        return lang == 'kr' ? '결제 대기중' : 'Pending payment';
      case 'CANCELLED':
        return lang == 'kr' ? '주문 취소' : 'Cancelled';
      case 'FAILED_PAYMENT':
        return lang == 'kr' ? '결제 실패' : 'Payment failed';
      case 'DRAFT':
        return lang == 'kr' ? '운영자에 의해 변동사항이 발생하여 주문이 취소되었습니다.' : 'Cancelled due to admin change';
      default:
        return lang == 'kr' ? '알 수 없는 상태' : 'Unknown status';
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;
    final titleText = lang == 'kr' ? '주문 실패' : 'Order Failed';
    final reasonText = _statusMessage(orderStatus, lang);
    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0C),
      appBar: const Header(),
      endDrawer: const AppDrawer(),
      floatingActionButton: const BackFAB(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      titleText,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const TranslatedText(
                            '고객님의 주문이 정상적으로 완료되지 않았습니다.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const TranslatedText(
                            '다시 시도해주세요.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            reasonText,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderSheetScreen(
                            productCode: productCode,
                            viewType: viewType,
                            eventName: eventName,
                            imageUrl: imageUrl,
                            productName: productName,
                            quantity: quantity,
                            formattedTotalPrice: NumberFormat('#,###').format((price + fee) * quantity) +
                                (currencyType == 'won' ? '원' : '\$'),
                            totalPrice: (price + fee) * quantity,
                            price: price,
                            fee: fee,
                            currencyType: currencyType,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      lang == 'kr' ? '다시 주문하기' : 'Try Again',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2EFFAA),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const ProductMainScreen()),
                      );
                    },
                    child: Text(
                      lang == 'kr' ? '쇼핑 홈 가기' : 'Go to Shop',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
