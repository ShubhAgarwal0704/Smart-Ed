import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAllCourses();
    });
  }

  Future<void> _fetchAllCourses() async {
    try {
      final courseProvider = Provider.of<CourseProvider>(context, listen: false);
      await courseProvider.fetchEnrolledCourses();
    } catch (error) {
      print("Error fetching courses: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Courses'),
      ),
      body: Consumer<CourseProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading(CourseListType.enrolled)) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final error = provider.getError(CourseListType.enrolled);
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

          final enrolledCourses = provider.enrolledCourses;

          if (enrolledCourses.isEmpty) {
            return const Center(
              child: Text(
                'You have not enrolled in any courses yet.',
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
            itemCount: enrolledCourses.length,
            itemBuilder: (context, index) {
              final course = enrolledCourses[index];
              return CourseCard(course: course);
            },
          );
        },
      ),
    );
  }
}