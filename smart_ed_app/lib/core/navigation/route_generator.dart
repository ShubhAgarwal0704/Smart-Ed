import 'package:flutter/material.dart';
import 'package:smart_ed_app/features/courses/models/courses.dart';
import '../../features/courses/screens/course_bought_screen.dart';
import '../constants/app_routes.dart';

import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/auth/screens/user_details_screen.dart';
import '../../features/auth/screens/interests_screen.dart';
import '../../features/navigation/screens/main_navigation_screen.dart';
import '../../features/courses/screens/course_details_screen.dart';
import '../../features/courses/screens/course_list_screen.dart';
import '../../features/search/screens/search_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case AppRoutes.signupDetails:
          return MaterialPageRoute(builder: (_) => UserDetailsScreen());

      case AppRoutes.signupInterests:
          return MaterialPageRoute(builder: (_) => InterestsScreen());

      case AppRoutes.main:
        int initialIndex = 0;
        return MaterialPageRoute(builder: (_) => MainNavigationScreen(initialIndex: initialIndex));

      case AppRoutes.search:
        return MaterialPageRoute(builder: (_) => const SearchScreen()); // Replace with actual screen


      case AppRoutes.courseDetails:
        if (args is Course) {
          return MaterialPageRoute(builder: (_) => CourseDetailsScreen(course: args));
        }
        return _errorRoute('Missing courseId for ${AppRoutes.courseDetails}');

      case AppRoutes.courseBuy:
        return MaterialPageRoute(builder: (_) => CourseBoughtScreen());
      case AppRoutes.categoryResults:
        if (args is String) {
          return MaterialPageRoute(builder: (_) => CourseListScreen());
        }
        return _errorRoute('Missing category name for ${AppRoutes.categoryResults}');
      default:
        return _errorRoute('Unknown route: ${settings.name}');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Navigation Error: $message')),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget { const LoginScreen({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Login')), body: const Center(child: Text('Login Screen'))); }
