import 'package:flutter/foundation.dart';

import '../api/dio_client.dart';
import '../../features/profile/models/user.dart';
import 'storage_service.dart';
import 'package:dio/dio.dart';

class AuthService {
  final DioClient _dioClient;
  final StorageService _storageService;

  AuthService(this._dioClient, this._storageService);

  Future<User> signUp({
    required String email,
    required String password,
    required String username,
    required String firstName,
    required String lastName,
    required List<String> interests,
  }) async {
    try {
      final response = await _dioClient.post(
        '/users',
        data: {
          'email': email,
          'password': password,
          'username': username,
          'firstName': firstName,
          'lastName': lastName,
          'interests': interests,
          'skillLevels': ['BEGINNER'],
          'role': 'STUDENT'
        },
      );

      if (response.statusCode == 201 && response.data != null) {
        final user = User.fromJson(response.data as Map<String, dynamic>);
        await _storageService.saveUserId(user.id);
        return user;
      } else {
        throw Exception('Sign up failed: ${response.statusCode} ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print("DioException during sign up: ${e.message}");
      }
      String errorMessage = e.response?.data?['message'] ?? 'Network error during sign up';
      throw Exception(errorMessage);
    } catch (e) {
      if (kDebugMode) {
        print("Error during sign up: $e");
      }
      throw Exception('An unexpected error occurred during sign up.');
    }
  }

  Future<User> login(String email, String password) async {
    throw UnimplementedError('Login not implemented');
  }

  Future<void> logout() async {
    await _storageService.clearUserId();
  }

  Future<String?> getStoredUserId() async {
    return await _storageService.getUserId();
  }
}