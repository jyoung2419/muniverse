import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import '../../../widgets/common/app_drawer.dart';
import '../../../widgets/common/back_fab.dart';
import '../../../widgets/common/header.dart';
import '../../models/order/order_item_model.dart';
import '../../models/order/order_request_model.dart';
import '../../providers/order/order_provider.dart';
import '../../providers/payment/user_payment_provider.dart';
import '../../widgets/common/translate_text.dart';
import '../../widgets/order/order_amount.dart';
import '../../widgets/order/order_product_card.dart';
import '../../widgets/order/orderer_info.dart';
import 'order_complete_screen.dart';
import 'order_fail_screen.dart';
import 'payment_web_view_screen.dart';

class OrderSheetScreen extends ConsumerStatefulWidget {
  final String productCode;
  final String viewType;
  final String eventName;
  final String imageUrl;
  final String productName;
  final int quantity;
  final String formattedTotalPrice;
  final double totalPrice;
  final double price;
  final double fee;
  final String currencyType; // 'won' 또는 'dollar'

  const OrderSheetScreen({
    super.key,
    required this.productCode,
    required this.viewType,
    required this.eventName,
    required this.imageUrl,
    required this.productName,
    required this.quantity,
    required this.formattedTotalPrice,
    required this.totalPrice,
    required this.price,
    required this.fee,
    required this.currencyType,
  });

  @override
  ConsumerState<OrderSheetScreen> createState() => _OrderSheetScreenState();
}

class _OrderSheetScreenState extends ConsumerState<OrderSheetScreen> {
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
    final symbol = widget.currencyType == 'won' ? '원' : '\$';

    final double finalTotal = (widget.price + widget.fee) * widget.quantity;
    final total = widget.currencyType == 'won'
        ? '${NumberFormat('#,###').format(finalTotal)}$symbol'
        : '$symbol${finalTotal.toStringAsFixed(2)}';
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
                currencyType: widget.currencyType
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
                currencyType: widget.currencyType
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  TranslatedText('총 ${widget.quantity}건',
                      style: const TextStyle(color: Colors.white)),
                  const Spacer(),
                  Text(total,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      if (nameController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          phoneController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              lang == 'kr'
                                  ? '이름, 이메일, 전화번호를 모두 입력해주세요.'
                                  : 'Please fill in all fields: name, email, and phone number.',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      final orderRequest = OrderRequest(
                        items: [
                          OrderItem(
                            viewType: widget.viewType,
                            productCode: widget.productCode,
                            amount: widget.quantity,
                          ),
                        ],
                        paymentType: widget.currencyType == 'won' ? 'WON' : 'DOLLAR',
                        phoneNumber: phoneController.text,
                        payLanguage: lang == 'kr'
                            ? 'ko'
                            : (lang == 'cn' || lang == 'tw')
                            ? 'cn'
                            : 'en',
                        email: emailController.text,
                        orderedName: nameController.text,
                      );

                      try {
                        final nextUrl = await ref.read(orderProvider).createPayment(orderRequest);
                        if (nextUrl != null) {
                          final fullUrl = '${dotenv.env['BASE_URL']}$nextUrl';

                          final orderId = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaymentWebViewScreen(url: fullUrl),
                            ),
                          );

                          if (orderId != null && mounted) {
                            final provider = context.read<UserPaymentProvider>();
                            await provider.resetAndFetchPayments();

                            final order = provider.payments.firstWhere((p) => p.orderId == orderId);
                            final item = order.orderItems.first;

                            if (order.orderStatus == 'COMPLETED') {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OrderCompleteScreen(
                                    eventName: order.eventName ?? '',
                                    imageUrl: item.productImageUrl,
                                    productName: item.productName,
                                    quantity: item.amount,
                                    userName: nameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text,
                                    price: item.totalPriceForAmount / item.amount,
                                    fee: order.totalOrderPrice - item.totalPriceForAmount,
                                    currencyType: widget.currencyType,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OrderFailScreen(
                                    eventName: order.eventName ?? '',
                                    imageUrl: item.productImageUrl,
                                    productName: item.productName,
                                    quantity: item.amount,
                                    price: item.totalPriceForAmount / item.amount,
                                    fee: order.totalOrderPrice - item.totalPriceForAmount,
                                    currencyType: widget.currencyType,
                                    orderStatus: order.orderStatus,
                                    productCode: widget.productCode,
                                    viewType: widget.viewType,
                                  ),
                                ),
                              );
                            }
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(lang == 'kr' ? '결제 URL을 불러오지 못했습니다.' : 'Failed to get payment URL')),
                          );
                        }
                      } catch (e) {
                        print('❌ 결제 요청 실패: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(lang == 'kr' ? '결제 요청 중 오류가 발생했습니다.' : 'Error during payment request')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2EFFAA),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
