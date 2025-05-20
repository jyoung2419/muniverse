import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../models/payment/user_payment_model.dart';
import '../../services/payment/user_payment_service.dart';

class UserPaymentProvider with ChangeNotifier {
  final UserPaymentService _paymentService;

  List<UserPaymentModel> _payments = [];
  List<UserPaymentModel> get payments => _payments;

  UserPaymentProvider(Dio dio) : _paymentService = UserPaymentService(dio);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchUserPayments() async {
    try {
      _isLoading = true;
      notifyListeners();

      final rawList = await _paymentService.fetchPayments();
      _payments = rawList.map((e) => UserPaymentModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint('❌ Failed to fetch user payments: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearPayments() {
    _payments = [];
    notifyListeners();
  }


  /// 예시 데이터
  void insertMockData() {
    _payments = [
      UserPaymentModel(
        orderId: 'ORDER123456',
        totalOrderPrice: 19800.0,
        orderStatus: 'COMPLETED',
        paymentType: 'CARD',
        createdAt: DateTime.now(),
        orderItems: [
          OrderItemModel(
            productName: 'VOD 이용권',
            productImageUrl: 'assets/images/ticket.png',
            amount: 1,
            totalPriceForAmount: 19800.0,
          ),
        ],
        userPasses: [
          UserPassModel(
            passName: 'VOD 풀패스',
            regisPinNumber: '1234-5678-ABCD',
            useFlag: false,
            createdAt: DateTime.now(),
            events: [
              EventUseInfoModel(
                code: 'EVT123',
                type: 'VOD',
                pinNumber: '1234-5678-ABCD',
                used: false,
                usedAt: null,
              ),
            ],
          ),
        ],
      ),
    ];
    notifyListeners();
  }


}
