import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_ed_app/features/courses/models/courses.dart';

import '../../../core/constants/app_routes.dart';
import '../../profile/providers/user_provider.dart';
import '../providers/course_provider.dart';

class CourseDetailsScreen extends StatelessWidget {
  final Course course;

  const CourseDetailsScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final theme = Theme.of(context);
    final isEnrolled = userProvider.currentUser?.enrolledCourseIds.contains(course.id) ?? false;
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar:  isEnrolled ? null : Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ).copyWith(
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
            ),
            onPressed: () async {
              final success = await userProvider.enrollInCourse(course.id);
              if (success) {
                Navigator.of(context).pushNamed(AppRoutes.courseBuy);
                await Future.wait([
                  courseProvider.fetchEnrolledCourses(),
                  courseProvider.fetchRecommendedCourses(),
                ]);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(userProvider.errorMessage ?? "Enrollment failed")),
                );
              }
            },
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF4B39EF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                alignment: Alignment.center,
                height: 60,
                child: const Text(
                  'Buy Now',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Image.network(
                      course.thumbnailUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 200,
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6C63FF), Color(0xFF4B39EF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Text(
                          course.level,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(course.category),
                    backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        "${course.rating.toStringAsFixed(1)} (${course.numberOfRatings})",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                course.title,
                style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Description
              Text(
                'Description',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                course.description,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
              const SizedBox(height: 20),

              if (course.learningObjectives.isNotEmpty) ...[
                Text(
                  'What You\'ll Learn',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...course.learningObjectives.map((obj) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, size: 20, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(child: Text(obj, style: theme.textTheme.bodyMedium)),
                    ],
                  ),
                )),
                const SizedBox(height: 20),
              ],

              if (course.prerequisites.isNotEmpty) ...[
                Text(
                  'Prerequisites',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...course.prerequisites.map((pre) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, size: 20, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(child: Text(pre, style: theme.textTheme.bodyMedium)),
                    ],
                  ),
                )),
                const SizedBox(height: 20),
              ],

              if (course.tags.isNotEmpty) ...[
                Text(
                  'Tags',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: course.tags
                      .map((tag) => Chip(
                    label: Text(tag),
                    backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  ))
                      .toList(),
                ),
                const SizedBox(height: 40),
              ],
            ],
          ),
        ),
      ),
    );
  }
}