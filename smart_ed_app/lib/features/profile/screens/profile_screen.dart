import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/storage_service.dart';
import '../../courses/models/courses.dart';
import '../../courses/providers/course_provider.dart';
import '../../courses/widgets/course_card.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserProfileAndCourses();
    });
  }

  Future<void> _fetchUserProfileAndCourses() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final courseProvider = Provider.of<CourseProvider>(context, listen: false);
      final storageService = Provider.of<StorageService>(context, listen: false);
      final userId = await storageService.getUserId();

      if (userId != null) {
        await userProvider.fetchUserProfile(userId);
        await courseProvider.fetchEnrolledCourses();
      } else {
        if (kDebugMode) {
          print("User ID is null, cannot fetch profile.");
        }
      }
    } catch(error) {
      if (kDebugMode) {
        print("Error fetching user profile or courses: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final courseProvider = Provider.of<CourseProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: userProvider.isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : userProvider.errorMessage != null
            ? Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Error loading profile: ${userProvider.errorMessage}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        )
            : userProvider.currentUser == null
            ? const Center(
          child: Text(
            'Please log in to view your profile.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        )
            : _buildProfileContent(userProvider.currentUser!, courseProvider),
      ),
    );
  }

  Widget _buildProfileContent(User user, CourseProvider courseProvider) {
    final avatarUrl =
        'https://ui-avatars.com/api/?name=${user.firstName}+${user.lastName}&background=random&color=fff&rounded=true&size=128';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage(avatarUrl),
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  '${user.firstName} ${user.lastName}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Chip(
                label: Text(
                  user.role,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 24),

          if (user.interests.isNotEmpty) ...[
            _buildSectionTitle('Interests'),
            Wrap(
              spacing: 12.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.start,
              children: user.interests
                  .map((interest) => Chip(
                label: Text(
                  interest,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade800
                    : Colors.grey.shade300,
              ))
                  .toList(),
            ),
            const SizedBox(height: 24),
          ],

          if (user.achievements.isNotEmpty) ...[
            _buildSectionTitle('Achievements'),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: user.achievements.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.star, color: Colors.amber),
                  title: Text(
                    user.achievements[index],
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],

          _buildCoursesSection('Enrolled Courses', courseProvider.enrolledCourses),

          const SizedBox(height: 20),

          GestureDetector(
            onTap: () {
            },
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.red, Colors.redAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesSection(String title, List<Course> courses) {
    if (courses.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        SizedBox(
          height: 275,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CourseCard(course: course),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }
}