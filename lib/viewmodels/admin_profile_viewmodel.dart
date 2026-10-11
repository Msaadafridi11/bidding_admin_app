import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AdminProfileViewModel extends ChangeNotifier {
  final AuthService _authService;

  AdminProfileViewModel({AuthService? authService})
      : _authService = authService ?? AuthService();

  bool _isLoggingOut = false;
  bool get isLoggingOut => _isLoggingOut;

  Future<void> logout() async {
    _isLoggingOut = true;
    notifyListeners();
    try {
      await _authService.signOut();
    } finally {
      _isLoggingOut = false;
      notifyListeners();
    }
  }
}
