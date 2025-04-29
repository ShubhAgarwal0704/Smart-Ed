import 'package:flutter/material.dart';
import 'package:smart_ed_app/core/services/storage_service.dart';
import '../../../core/services/user_service.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  final StorageService _storageService;
  final UserService _userService;
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  UserProvider(this._userService, this._storageService);

  Future<void> fetchUserProfile(String userId) async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isLoading) notifyListeners();
    });


    try {
      _currentUser = await _userService.getUserById(userId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> enrollInCourse(String courseId) async {

    if (_isLoading) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    String? userId = await _storageService.getUserId();

    try {
      final updatedUser = await _userService.enrollInCourse(userId!, courseId);
      _currentUser = updatedUser;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }


  void clearUser() {
    _currentUser = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  void updateUser(User user) {
    _currentUser = user;
    notifyListeners();
  }
}