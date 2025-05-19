import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import '../../../widgets/common/app_drawer.dart';
import '../../../widgets/common/back_fab.dart';
import '../../../widgets/common/header.dart';
import '../../widgets/common/translate_text.dart';
import '../../widgets/order/order_amount.dart';
import '../../widgets/order/order_product_card.dart';
import '../../widgets/order/orderer_info.dart';
import 'order_complete_screen.dart';

class OrderSheetScreen extends StatefulWidget {
  final String eventName;
  final String imageUrl;
  final String productName;
  final int quantity;
  final String formattedTotalPrice;
  final double totalPrice;
  final double price;
  final double fee;

  const OrderSheetScreen({
    super.key,
    required this.eventName,
    required this.imageUrl,
    required this.productName,
    required this.quantity,
    required this.formattedTotalPrice,
    required this.totalPrice,
    required this.price,
    required this.fee,
  });

  @override
  State<OrderSheetScreen> createState() => _OrderSheetScreenState();
}

class _OrderSheetScreenState extends State<OrderSheetScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;
    final titleText = lang == 'kr' ? '주문자 정보 입력' : 'Orderer Information';

    final symbol = lang == 'kr' ? '₩' : '\$';
    final total = lang == 'kr'
        ? NumberFormat('#,###').format(widget.totalPrice)
        : widget.totalPrice.toStringAsFixed(2);
    final payText = lang == 'kr' ? '결제하기' : 'PAY NOW';

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
              _buildSectionTitle(lang == 'kr' ? '주문 상품' : 'Order Items'),
              const Divider(color: Colors.white12, height: 1.0),
              const SizedBox(height: 10),
              OrderProductCard(
                eventName: widget.eventName,
                imageUrl: widget.imageUrl,
                productName: widget.productName,
                quantity: widget.quantity,
                totalPrice: widget.totalPrice,
              ),
              const SizedBox(height: 10),
              const Divider(color: Colors.white12, height: 1.0),
              const SizedBox(height: 30),
              _buildSectionTitle(lang == 'kr' ? '주문자' : 'Orderer'),
              const Divider(color: Colors.white12, height: 1.0),
              const SizedBox(height: 10),
              OrdererInfo(
                nameController: nameController,
                emailController: emailController,
                phoneController: phoneController,
              ),
              const SizedBox(height: 10),
              const Divider(color: Colors.white12, height: 1.0),
              const SizedBox(height: 30),
              _buildSectionTitle(lang == 'kr' ? '주문 금액' : 'Order Amount'),
              const Divider(color: Colors.white12, height: 1.0),
              const SizedBox(height: 10),
              OrderAmount(
                lang: lang,
                price: widget.price,
                fee: widget.fee,
                totalPrice: widget.totalPrice,
                quantity: widget.quantity,
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  TranslatedText('총 ${widget.quantity}건',
                      style: const TextStyle(color: Colors.white)),
                  const Spacer(),
                  Text('$symbol$total',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderCompleteScreen(
                            eventName: widget.eventName,
                            imageUrl: widget.imageUrl,
                            productName: widget.productName,
                            quantity: widget.quantity,
                            userName: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                            price: widget.price,
                            fee: widget.fee,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2EFFAA),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(payText),
                  ),
                ],
              ),
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
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
