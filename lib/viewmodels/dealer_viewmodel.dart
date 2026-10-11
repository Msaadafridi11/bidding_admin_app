import 'dart:async';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/dealer_service.dart';

enum DealerFilterStatus { all, verified, unverified }

class DealerViewModel extends ChangeNotifier {
  final DealerService _dealerService;
  StreamSubscription<List<UserModel>>? _subscription;

  DealerViewModel({DealerService? dealerService})
      : _dealerService = dealerService ?? DealerService() {
    _initDealersStream();
  }

  List<UserModel> _allDealers = [];
  bool _isLoading = true;
  bool _isApproving = false;
  bool _isRejecting = false;
  String? _errorMessage;
  String? _successMessage;
  String _searchQuery = '';
  DealerFilterStatus _filterStatus = DealerFilterStatus.all;

  bool get isLoading => _isLoading;
  bool get isApproving => _isApproving;
  bool get isRejecting => _isRejecting;
  bool get isBusy => _isApproving || _isRejecting;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String get searchQuery => _searchQuery;
  DealerFilterStatus get filterStatus => _filterStatus;

  List<UserModel> get dealers {
    return _allDealers.where((dealer) {
      if (_filterStatus == DealerFilterStatus.verified && dealer.isVerified != true) {
        return false;
      }
      if (_filterStatus == DealerFilterStatus.unverified && dealer.isVerified == true) {
        return false;
      }

      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final name = (dealer.name ?? '').toLowerCase();
      final email = (dealer.email ?? '').toLowerCase();
      final company = (dealer.compnyName ?? '').toLowerCase();
      return name.contains(q) || email.contains(q) || company.contains(q);
    }).toList();
  }

  int get totalCount => _allDealers.length;
  int get verifiedCount => _allDealers.where((d) => d.isVerified == true).length;
  int get pendingCount => _allDealers.where((d) => d.isVerified != true).length;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterStatus(DealerFilterStatus status) {
    _filterStatus = status;
    notifyListeners();
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void _initDealersStream() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _subscription?.cancel();
    _subscription = _dealerService.getDealersStream().listen(
      (dealers) {
        _allDealers = dealers;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (e) {
        _isLoading = false;
        _errorMessage = e.toString();
        notifyListeners();
      },
    );
  }

  Future<bool> approveDealer(String uid) async {
    _isApproving = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      await _dealerService.approveDealer(uid);
      _isApproving = false;
      _successMessage = 'Dealer approved successfully';
      notifyListeners();
      return true;
    } catch (e) {
      _isApproving = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> rejectDealer(String uid) async {
    _isRejecting = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      await _dealerService.rejectDealer(uid);
      _isRejecting = false;
      _successMessage = 'Dealer request rejected';
      notifyListeners();
      return true;
    } catch (e) {
      _isRejecting = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void refresh() {
    _initDealersStream();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
