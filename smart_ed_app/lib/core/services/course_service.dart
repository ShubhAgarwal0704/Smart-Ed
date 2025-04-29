import 'package:flutter/foundation.dart';
import 'package:smart_ed_app/core/services/storage_service.dart';
import 'package:smart_ed_app/core/services/user_service.dart';
import '../../features/courses/models/courses.dart';
import '../api/dio_client.dart';
import 'package:dio/dio.dart';

class CourseService {
  final DioClient _dioClient;
  final StorageService _storageService;
  final UserService _userService;

  CourseService(this._dioClient, this._storageService, this._userService);

  // Generic method to fetch lists of courses
  Future<List<Course>> _fetchCourseList(String endpoint, {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dioClient.get(endpoint, queryParameters: queryParams);
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> courseListJson = response.data as List<dynamic>;
        return courseListJson
            .map((json) => Course.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to fetch courses from $endpoint: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print("DioException fetching courses from $endpoint: $e");
      }
      throw Exception('Network error fetching courses.');
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching courses from $endpoint: $e");
      }
      throw Exception('An unexpected error occurred fetching courses.');
    }
  }

  Future<List<Course>> getNewCourses() async {
    return await _fetchCourseList('/courses');
  }

  Future<List<Course>> getRecommendedCourses(String userId) async {
    return await _fetchCourseList('/courses/recommended/$userId');
  }

  Future<List<Course>> searchCourses(String query) async {
    return await _fetchCourseList('/courses/search', queryParams: {'term': query});
  }

  Future<List<Course>> getCoursesByCategory(String category) async {
    return await _fetchCourseList('/courses/category/$category');
  }

  Future<List<Course>> getCoursesByInstructor(String instructorId) async {
    return await _fetchCourseList('/courses/instructor/$instructorId');
  }

  Future<List<Course>> getEnrolledCourses() async {
    try {
      final userId = await _storageService.getUserId();
      if (userId == null) {
        throw Exception('User ID not found in storage.');
      }

      final user = await _userService.getUserById(userId);
      final enrolledCourseIds = user.enrolledCourseIds;

      if (enrolledCourseIds.isEmpty) return [];

      // Fetch each course one-by-one
      List<Course> courses = [];
      for (final courseId in enrolledCourseIds) {
        final course = await getCourseById(courseId);
        courses.add(course);
      }

      return courses;
    } catch (e) {
      if (kDebugMode) {
        print("Error getting enrolled courses: $e");
      }
      throw Exception('Failed to retrieve enrolled courses.');
    }
  }

  Future<Course> getCourseById(String courseId) async {
    try {
      final response = await _dioClient.get('/courses/$courseId');
      if (response.statusCode == 200 && response.data != null) {
        return Course.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to fetch course details: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print("DioException fetching course details: $e");
      }
      throw Exception('Network error fetching course details.');
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching course details: $e");
      }
      throw Exception('An unexpected error occurred fetching course details.');
    }
  }
}
