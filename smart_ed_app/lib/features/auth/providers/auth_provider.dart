import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import '../../profile/models/user.dart';

enum AuthState { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  User? _currentUser;
  AuthState _authState = AuthState.unknown;
  bool _isLoading = false;
  String? _errorMessage;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  AuthProvider(this._authService) {
    _checkCurrentUser();
  }

  User? get currentUser => _currentUser;
  AuthState get authState => _authState;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _setLoading(bool value) async {
    await Future.delayed(Duration.zero);
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  Future<void> _checkCurrentUser() async {
    _setLoading(true);
    try {
      final userId = await _authService.getStoredUserId();
      if (userId != null) {
        _authState = AuthState.authenticated;
      } else {
        _authState = AuthState.unauthenticated;
      }
    } catch (e) {
      _authState = AuthState.unauthenticated;
    } finally {
      _setLoading(false);
    }
  }

  bool validateSignupInputs() {
    if (emailController.text.isEmpty ||
        !emailController.text.contains('@')) {
      _errorMessage = "Invalid email address";
      return false;
    }
    if (passwordController.text.isEmpty || passwordController.text.length < 6) {
      _errorMessage = "Password must be at least 6 characters";
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      _errorMessage = "Passwords do not match";
      return false;
    }
    _clearError();
    return true;
  }

  bool validateUserDetailsInputs() {
    if (usernameController.text.isEmpty ||
        firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty) {
      _errorMessage = "All fields are required";
      return false;
    }
    _clearError();
    return true;
  }

  Future<bool> signUp(List<String> interests) async {
    _setLoading(true);
    _clearError();
    try {
      _currentUser = await _authService.signUp(
        email: emailController.text,
        password: passwordController.text,
        username: usernameController.text,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        interests: interests,
      );
      _authState = AuthState.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _authState = AuthState.unauthenticated;
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }
}