import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../widgets/common/app_drawer.dart';
import '../../../widgets/common/back_fab.dart';
import '../../../widgets/common/header.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/translate_text.dart';
import '../../widgets/order/order_product_card.dart';
import '../mypage/purchase_history_screen.dart';
import '../product/product_main_screen.dart';

class OrderCompleteScreen extends StatelessWidget {
  final String eventName;
  final String imageUrl;
  final String productName;
  final int quantity;
  final String userName;
  final String email;
  final String phone;
  final double price;
  final double fee;

  const OrderCompleteScreen({
    super.key,
    required this.eventName,
    required this.imageUrl,
    required this.productName,
    required this.quantity,
    required this.userName,
    required this.email,
    required this.phone,
    required this.price,
    required this.fee,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;
    final titleText = lang == 'kr' ? '주문 완료' : 'Order Complete';
    final total = price + fee;
    final priceLabel = lang == 'kr' ? '상품금액' : 'Product Price';
    final feeLabel = lang == 'kr' ? '수수료' : 'Fee';
    final totalLabel = lang == 'kr' ? '총 상품금액' : 'Total';

    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0C),
      appBar: const Header(),
      endDrawer: const AppDrawer(),
      floatingActionButton: const BackFAB(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: [
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
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    TranslatedText(
                      '고객님의 주문이 정상적으로 완료되었습니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    TranslatedText(
                      '[마이페이지 > 구매내역] 메뉴에서\n이용권 확인 가능합니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              _buildSectionTitle(lang == 'kr' ? '주문 상품' : 'Order Items'),
              const SizedBox(height: 10),
              const Divider(color: Colors.white12, height: 1.0),
              const SizedBox(height: 10),
              OrderProductCard(
                eventName: eventName,
                imageUrl: imageUrl,
                productName: productName,
                quantity: quantity,
                totalPrice: (fee + price) * quantity,
              ),
              const SizedBox(height: 10),
              const Divider(color: Colors.white12, height: 1.0),
              const SizedBox(height: 30),
              _buildSectionTitle(lang == 'kr' ? '주문자' : 'Orderer'),
              const SizedBox(height: 10),
              const Divider(color: Colors.white12, height: 1.0),
              const SizedBox(height: 10),
              Text(userName, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 4),
            Text(email, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 4),
            Text(phone, style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 10),
              const Divider(color: Colors.white12, height: 1.0),
              const SizedBox(height: 30),
              _buildSectionTitle(lang == 'kr' ? '결제 정보' : 'Order Amount'),
              const SizedBox(height: 10),
              const Divider(color: Colors.white12, height: 1.0),
              const SizedBox(height: 10),
            _buildPriceRow(priceLabel, price),
            _buildPriceRow(feeLabel, fee),
              const SizedBox(height: 10),
              const Divider(color: Colors.white12, height: 1.0),
              const SizedBox(height: 10),
              _buildPriceRow(totalLabel, total),
              const SizedBox(height: 10),
              const Divider(color: Colors.white12, height: 1.0),
              const SizedBox(height: 32),
            Row(
              children: [
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
                        MaterialPageRoute(builder: (_) => const PurchaseHistoryScreen()),
                      );
                    },
                    child: Text(
                      lang == 'kr' ? '주문확인하기' : 'Check Order',
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
                      lang == 'kr' ? '쇼핑계속하기' : 'Continue Shopping',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildPriceRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          Text('₩${NumberFormat('#,###').format(amount)}', style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
