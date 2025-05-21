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
      print('📦 구매내역 개수: ${_payments.length}');

      for (final payment in _payments) {
        final uniquePasses = <String, UserPassModel>{};

        for (final pass in payment.userPasses) {
          uniquePasses[pass.regisPinNumber] = pass;
        }

        payment.userPasses
          ..clear()
          ..addAll(uniquePasses.values.toList());
      }
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
}
