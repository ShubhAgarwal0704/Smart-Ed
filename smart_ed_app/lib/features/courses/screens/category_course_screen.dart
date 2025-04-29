import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/course_card.dart';

class CategoryCoursesScreen extends StatefulWidget {
  final String category;

  const CategoryCoursesScreen({super.key, required this.category});

  @override
  State<CategoryCoursesScreen> createState() => _CategoryCoursesScreenState();
}

class _CategoryCoursesScreenState extends State<CategoryCoursesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCategoryCourses();
    });
  }

  Future<void> _fetchCategoryCourses() async {
    try {
      final courseProvider = Provider.of<CourseProvider>(context, listen: false);
      await courseProvider.fetchCoursesByCategory(widget.category);
    } catch (error) {
      if (kDebugMode) {
        print("Error fetching category courses: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        centerTitle: true,
      ),
      body: Consumer<CourseProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading(CourseListType.category)) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final error = provider.getError(CourseListType.category);
          if (error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error loading courses: ${error.toString()}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            );
          }

          final categoryCourses = provider.categoryResults;

          if (categoryCourses.isEmpty) {
            return const Center(
              child: Text(
                'No courses found in this category.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.65,
            ),
            itemCount: categoryCourses.length,
            itemBuilder: (context, index) {
              final course = categoryCourses[index];
              return CourseCard(course: course);
            },
          );
        },
      ),
    );
  }
}