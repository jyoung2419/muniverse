import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../models/payment/user_payment_model.dart';
import '../../services/payment/user_payment_service.dart';

class UserPaymentProvider with ChangeNotifier {
  final UserPaymentService _paymentService;

  List<UserPaymentModel> _payments = [];
  List<UserPaymentModel> get payments => _payments;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _currentPage = 0;
  final int _pageSize = 10;
  bool _lastPage = false;
  bool get hasMore => !_lastPage;

  UserPaymentProvider(Dio dio) : _paymentService = UserPaymentService(dio);

  Future<void> resetAndFetchPayments() async {
    _currentPage = 0;
    _lastPage = false;
    _payments.clear();
    notifyListeners();
    await fetchNextPage();
  }

  Future<void> fetchNextPage() async {
    if (_lastPage || _isLoading) return;
    try {
      _isLoading = true;
      notifyListeners();

      final rawList = await _paymentService.fetchPayments(
        page: _currentPage,
        size: _pageSize,
        sort: 'createdAt,desc',
      );

      final newPayments = rawList.map((e) => UserPaymentModel.fromJson(e)).toList();
      print('📦 Page $_currentPage: ${newPayments.length}건 로드');

      for (final payment in newPayments) {
        final uniquePasses = <String, UserPassModel>{};
        for (final pass in payment.userPasses) {
          uniquePasses[pass.regisPinNumber] = pass;
        }
        payment.userPasses
          ..clear()
          ..addAll(uniquePasses.values);
      }

      _payments.addAll(newPayments);
      _lastPage = newPayments.length < _pageSize;
      _currentPage += 1;
    } catch (e) {
      debugPrint('❌ Failed to fetch user payments: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearPayments() {
    _payments = [];
    _currentPage = 0;
    _lastPage = false;
    notifyListeners();
  }
}
