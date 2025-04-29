import 'package:flutter/material.dart';
import 'package:smart_ed_app/core/services/storage_service.dart';
import '../../../core/services/course_service.dart';
import '../models/courses.dart';

enum CourseListType { enrolled, recommended, newCourses, search, category, details }

class CourseProvider extends ChangeNotifier {
  final StorageService _storageService;
  final CourseService _courseService;

  List<Course> _enrolledCourses = [];
  List<Course> _recommendedCourses = [];
  List<Course> _newCourses = [];
  List<Course> _searchResults = [];
  List<Course> _categoryResults = [];
  Course? _selectedCourseDetails;

  final Map<CourseListType, bool> _isLoading = { for (var type in CourseListType.values) type: false };
  final Map<CourseListType, String?> _errors = { for (var type in CourseListType.values) type: null };

  List<Course> get enrolledCourses => _enrolledCourses;
  List<Course> get recommendedCourses => _recommendedCourses;
  List<Course> get newCourses => _newCourses;
  List<Course> get searchResults => _searchResults;
  List<Course> get categoryResults => _categoryResults;
  Course? get selectedCourseDetails => _selectedCourseDetails;

  bool isLoading(CourseListType type) => _isLoading[type] ?? false;
  String? getError(CourseListType type) => _errors[type];


  CourseProvider(this._courseService, this._storageService);

  void _setState(CourseListType type, {bool? loading, String? error, bool notify = true}) {
    if (loading != null) _isLoading[type] = loading;
    if (error != null || loading == false) _errors[type] = error;

    if (notify) notifyListeners();
  }

  Future<void> fetchEnrolledCourses() async {
    if (isLoading(CourseListType.enrolled)) return;
    _setState(CourseListType.enrolled, loading: true);
    try {
      _enrolledCourses = await _courseService.getEnrolledCourses();
      _setState(CourseListType.enrolled, loading: false);
    } catch (e) {
      _setState(CourseListType.enrolled, loading: false, error: e.toString());
    }
  }

  Future<void> fetchRecommendedCourses() async {
    if (isLoading(CourseListType.recommended)) return;
    _setState(CourseListType.recommended, loading: true);

    final userId = await _storageService.getUserId();
    if (userId == null) {
      throw Exception('User ID not found in storage.');
    }
    try {
      _recommendedCourses = await _courseService.getRecommendedCourses(userId);
      _setState(CourseListType.recommended, loading: false);
    } catch (e) {
      _setState(CourseListType.recommended, loading: false, error: e.toString());
    }
  }

  Future<void> fetchNewCourses() async {
    if (isLoading(CourseListType.newCourses)) return;
    _setState(CourseListType.newCourses, loading: true);
    try {
      _newCourses = await _courseService.getNewCourses();
      _setState(CourseListType.newCourses, loading: false);
    } catch (e) {
      _setState(CourseListType.newCourses, loading: false, error: e.toString());
    }
  }

  Future<void> searchCourses(String query) async {
    if (query.length < 3) {
      _searchResults = [];
      _setState(CourseListType.search, loading: false, error: null);
      return;
    }
    if (isLoading(CourseListType.search)) return;
    _setState(CourseListType.search, loading: true);
    try {
      _searchResults = await _courseService.searchCourses(query);
      _setState(CourseListType.search, loading: false);
    } catch (e) {
      _setState(CourseListType.search, loading: false, error: e.toString());
    }
  }

  Future<void> fetchCoursesByCategory(String category) async {
    if (isLoading(CourseListType.category)) return;
    _setState(CourseListType.category, loading: true);
    try {
      _categoryResults = await _courseService.getCoursesByCategory(category);
      _setState(CourseListType.category, loading: false);
    } catch (e) {
      _setState(CourseListType.category, loading: false, error: e.toString());
    }
  }

  Future<void> fetchCourseDetails(String courseId) async {
    if (isLoading(CourseListType.details)) return;
    _setState(CourseListType.details, loading: true);
    try {
      _selectedCourseDetails = await _courseService.getCourseById(courseId);
      _setState(CourseListType.details, loading: false);
    } catch (e) {
      _setState(CourseListType.details, loading: false, error: e.toString());
    }
  }

  void clearSearchResults() {
    _searchResults = [];
    _errors[CourseListType.search] = null;
    notifyListeners();
  }
  // Clear category results
  void clearCategoryResults() {
    _categoryResults = [];
    _errors[CourseListType.category] = null;
    notifyListeners();
  }
  // Clear details
  void clearCourseDetails() {
    _selectedCourseDetails = null;
    _errors[CourseListType.details] = null;
    notifyListeners();
  }
}