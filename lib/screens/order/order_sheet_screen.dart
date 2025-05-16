import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import '../../../widgets/common/app_drawer.dart';
import '../../../widgets/common/back_fab.dart';
import '../../../widgets/common/header.dart';
import '../../widgets/order/order_amount.dart';
import '../../widgets/order/order_product_card.dart';
import '../../widgets/order/orderer_info.dart';

class OrderSheetScreen extends StatelessWidget {
  final String eventName;
  final String imageUrl;
  final String productName;
  final int quantity;
  final double unitPrice;
  final String formattedTotalPrice;
  final String totalPrice;

  const OrderSheetScreen({
    super.key,
    required this.eventName,
    required this.imageUrl,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.formattedTotalPrice,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;
    final titleText = lang == 'kr' ? '주문서' : 'Order Sheet';
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0C),
      appBar: const Header(),
      endDrawer: const AppDrawer(),
      floatingActionButton: const BackFAB(),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              // 주문 상품
              _buildSectionTitle(lang == 'kr' ? '주문 상품' : 'Order Items'),
              const Divider(color: Colors.white10, height: 1.0),
              const SizedBox(height: 10),
              OrderProductCard(
                eventName: eventName,
                imageUrl: imageUrl,
                productName: productName,
                quantity: quantity,
                unitPrice: unitPrice,
              ),
              const SizedBox(height: 10),
              const Divider(color: Colors.white10, height: 1.0),
              // 주문자 정보
              const SizedBox(height: 30),
              _buildSectionTitle(lang == 'kr' ? '주문자' : 'Orderer'),
              const Divider(color: Colors.white10, height: 1.0),
              const SizedBox(height: 10),
              OrdererInfo(
                nameController: nameController,
                emailController: emailController,
                phoneController: phoneController,
              ),
              const SizedBox(height: 10),
              const Divider(color: Colors.white10, height: 1.0),
              // 주문 금액
              const SizedBox(height: 30),
              _buildSectionTitle(lang == 'kr' ? '주문금액' : 'Order Amount'),
              const Divider(color: Colors.white10, height: 1.0),
              const SizedBox(height: 10),
              OrderAmount(
                lang: lang,
                unitPrice: unitPrice,
                quantity: quantity,
                formattedTotalPrice: formattedTotalPrice,
              ),
              const SizedBox(height: 10),
              const Divider(color: Colors.white10, height: 1.0),
              // 하단 결제 요약
              const SizedBox(height: 30),
              _buildBottomSummaryAndButton(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBottomSummaryAndButton(BuildContext context) {
    return Row(
      children: [
        const Text('총 2건', style: TextStyle(color: Colors.white)),
        const Spacer(),
        const Text('₩900,000', style: TextStyle(color: Colors.white)),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {
            // 결제 처리
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2EFFAA),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('결제하기'),
        ),
      ],
    );
  }
}
