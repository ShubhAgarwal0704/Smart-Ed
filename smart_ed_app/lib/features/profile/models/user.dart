import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final List<String> enrolledCourseIds;
  final List<String> completedCourseIds;
  final List<String> achievements;
  final List<String> interests;
  final List<String> skillLevels;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.enrolledCourseIds,
    required this.completedCourseIds,
    required this.achievements,
    required this.interests,
    required this.skillLevels,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      role: json['role'] as String,
      enrolledCourseIds: List<String>.from(json['enrolledCourseIds'] as List<dynamic>? ?? []),
      completedCourseIds: List<String>.from(json['completedCourseIds'] as List<dynamic>? ?? []),
      achievements: List<String>.from(json['achievements'] as List<dynamic>? ?? []),
      interests: List<String>.from(json['interests'] as List<dynamic>? ?? []),
      skillLevels: List<String>.from(json['skillLevels'] as List<dynamic>? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'enrolledCourseIds': enrolledCourseIds,
      'completedCourseIds': completedCourseIds,
      'achievements': achievements,
      'interests': interests,
      'skillLevels': skillLevels,
    };
  }
}