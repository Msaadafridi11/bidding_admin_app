import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;

  AuthViewModel({AuthService? authService})
      : _authService = authService ?? AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _dialogMessage;
  String? get dialogMessage => _dialogMessage;

  void clearErrors() {
    _errorMessage = null;
    _dialogMessage = null;
    notifyListeners();
  }

  void consumeDialogMessage() {
    _dialogMessage = null;
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _dialogMessage = null;
    notifyListeners();

    try {
      final result = await _authService.loginAdmin(
        email: email,
        password: password,
      );

      switch (result.status) {
        case AuthResultStatus.success:
          _isLoading = false;
          notifyListeners();
          return true;

        case AuthResultStatus.pendingApproval:
        case AuthResultStatus.notFound:
        case AuthResultStatus.error:
          _isLoading = false;
          _dialogMessage = result.message;
          _errorMessage = result.message;
          notifyListeners();
          return false;
      }
    } catch (e) {
      _isLoading = false;
      _dialogMessage = 'Unexpected error: $e';
      _errorMessage = 'Unexpected error: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    notifyListeners();
  }
}
