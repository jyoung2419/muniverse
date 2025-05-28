import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/payment/user_payment_provider.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/back_fab.dart';
import '../../widgets/common/header.dart';
import '../../widgets/common/translate_text.dart';
import '../../widgets/mypage/pin_field_row.dart';
import '../../widgets/mypage/product_card.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<UserPaymentProvider>().resetAndFetchPayments();
    });

    _scrollController.addListener(() {
      final provider = context.read<UserPaymentProvider>();
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300 &&
          !_isFetchingMore && provider.hasMore) {
        if (provider.hasMore && !_isFetchingMore) {
          _isFetchingMore = true;
          provider.fetchNextPage().whenComplete(() {
            _isFetchingMore = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String getOrderStatusText(String status, String lang) {
    switch (status) {
      case 'PENDING_PAYMENT':
        return lang == 'kr' ? '결제 대기중' : 'Payment Pending';
      case 'PAID':
      case 'COMPLETED':
        return lang == 'kr' ? '결제 완료' : 'Payment Completed';
      case 'CANCELLED':
        return lang == 'kr' ? '주문 취소' : 'Cancelled';
      case 'FAILED_PAYMENT':
        return lang == 'kr' ? '결제 실패' : 'Payment Failed';
      case 'DRAFT':
        return lang == 'kr' ? '주문 오류' : 'Order Error';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;
    final provider = context.watch<UserPaymentProvider>();
    final payments = provider.payments;
    final filteredPayments = payments.where((p) => p.orderStatus != 'CREATED').toList();

    final titleText = lang == 'kr' ? '구매 내역' : 'Purchase History';
    final payInfoText = lang == 'kr' ? '결제 정보 보기' : 'View Payment Info';
    final orderNoText = lang == 'kr' ? '주문번호' : 'Order No.';
    final orderProductText = lang == 'kr' ? '주문 상품' : 'Ordered Products';
    final ticketCodeText = lang == 'kr' ? '이용권 코드' : 'Ticket Code';

    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0C),
      appBar: const Header(),
      endDrawer: const AppDrawer(),
      floatingActionButton: const BackFAB(),
      body: Column(
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
          const SizedBox(height: 16),
          Expanded(
            child: filteredPayments.isEmpty
                ? const Center(
              child: TranslatedText(
                '구매 내역이 없습니다.',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            )
                : ListView.builder(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: filteredPayments.length + (provider.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == filteredPayments.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final payment = filteredPayments[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(color: Colors.white12),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:
                                '${payment.createdAt.year}.${payment.createdAt.month.toString().padLeft(2, '0')}.${payment.createdAt.day.toString().padLeft(2, '0')} ',
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                              ),
                              TextSpan(
                                text: ' ${getOrderStatusText(payment.orderStatus, lang)}',
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
                            children: [
                              Text(
                                payInfoText,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white54),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$orderNoText ${payment.orderId}',
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
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
                    for (final item in payment.orderItems)
                      ProductCard(
                        eventName: payment.eventName,
                        productName: item.productName,
                        productImageUrl: item.productImageUrl,
                        quantity: item.amount,
                        totalPriceForAmount: item.totalPriceForAmount,
                        currency: payment.paymentType == 'WON' ? '₩' : '\$',
                      ),
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
                    for (final pass in payment.userPasses)
                      PinFieldRow(pinCode: pass.regisPinNumber),
                    const SizedBox(height: 30),
                  ],
                );
              },
            ),
          ),const SizedBox(height: 40),
        ],
      ),
    );
  }
}
