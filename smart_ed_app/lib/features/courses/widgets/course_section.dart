import 'package:flutter/material.dart';
import '../models/courses.dart';
import '../providers/course_provider.dart';
import 'course_card.dart';

class CourseSection extends StatelessWidget {
  final String title;
  final CourseListType type;
  final List<Course> courses;
  final bool isLoading;
  final String? error;

  const CourseSection({
    super.key,
    required this.title,
    required this.type,
    required this.courses,
    required this.isLoading,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isLoading
                ? const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: CircularProgressIndicator(),
              ),
            )
                : error != null
                ? Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            )
                : courses.isEmpty
                ? Row(
              children: [
                const Icon(Icons.info_outline,
                    color: Colors.grey),
                const SizedBox(width: 8),
                const Text(
                  'No courses found.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            )
                : SizedBox(
              height: 275,
              child: ListView.separated(
                padding:
                const EdgeInsets.symmetric(horizontal: 8),
                scrollDirection: Axis.horizontal,
                itemCount: courses.length,
                separatorBuilder: (_, __) =>
                const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return AnimatedContainer(
                    duration:
                    const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: CourseCard(course: courses[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
