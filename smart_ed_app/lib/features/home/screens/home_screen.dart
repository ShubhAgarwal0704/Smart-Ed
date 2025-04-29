import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/providers/theme_provider.dart';
import '../../courses/providers/course_provider.dart';
import '../../courses/widgets/course_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoadingAll = true;

  @override
  void initState() {
    super.initState();
    _fetchAllCourses();
  }

  Future<void> _fetchAllCourses() async {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    setState(() => _isLoadingAll = true);

    await Future.wait([
      courseProvider.fetchEnrolledCourses(),
      courseProvider.fetchRecommendedCourses(),
      courseProvider.fetchNewCourses(),
    ]);

    setState(() => _isLoadingAll = false);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final courseProvider = Provider.of<CourseProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _fetchAllCourses,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                pinned: true,
                expandedHeight: 140,
                backgroundColor: themeProvider.isDarkMode
                    ? Color(0xFF282828)
                    : Theme.of(context).colorScheme.primary,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  title: Text(
                    'Welcome to \nSmart Ed!👋',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: themeProvider.isDarkMode
                            ? [Color(0xFF4D4D4D), Color(0xFF121212)]
                            : [Color(0xFF361D70), Color(0xFFCDB9FB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color: Colors.white,
                    ),
                    onPressed: themeProvider.toggleTheme,
                    tooltip: 'Toggle Theme',
                  ),
                ],
              ),
              if (_isLoadingAll)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(12),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        if (courseProvider.enrolledCourses.isNotEmpty)
                          CourseSection(
                              title: 'Enrolled Courses',
                              type: CourseListType.enrolled,
                              courses: courseProvider.enrolledCourses,
                              isLoading: false,
                              error: courseProvider.getError(CourseListType.enrolled),
                            ),
                        if (courseProvider.newCourses.isNotEmpty)
                            CourseSection(
                              title: 'New Courses',
                              type: CourseListType.newCourses,
                              courses: courseProvider.newCourses,
                              isLoading: false,
                              error: courseProvider.getError(CourseListType.newCourses),
                            ),
                        if (courseProvider.recommendedCourses.isNotEmpty)
                            CourseSection(
                              title: 'Recommended for You',
                              type: CourseListType.recommended,
                              courses: courseProvider.recommendedCourses,
                              isLoading: false,
                              error: courseProvider.getError(CourseListType.recommended),
                            ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
