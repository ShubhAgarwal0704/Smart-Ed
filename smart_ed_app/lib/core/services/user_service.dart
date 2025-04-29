import 'package:flutter/foundation.dart';

import '../api/dio_client.dart';
import '../../features/profile/models/user.dart';
import 'package:dio/dio.dart';

class UserService {
  final DioClient _dioClient;

  UserService(this._dioClient);

  Future<User> getUserById(String userId) async {
    try {
      final response = await _dioClient.get('/users/$userId');
      if (response.statusCode == 200 && response.data != null) {
        return User.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to fetch user: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print("DioException fetching user: $e");
      }
      throw Exception('Network error fetching user details.');
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user by ID: $e");
      }
      throw Exception('An unexpected error occurred fetching user details.');
    }
  }

  Future<User> enrollInCourse(String userId, String courseId) async {
    try {
      final response = await _dioClient.post('/users/$userId/enroll/$courseId');
      if (response.statusCode == 200 && response.data != null) {
        return User.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to enroll: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print("DioException enrolling course: $e");
      throw Exception('Network error during enrollment.');
    } catch (e) {
      if (kDebugMode) {
        print("Error enrolling course: $e");
      }
      throw Exception('An unexpected error occurred during enrollment.');
    }
  }
}