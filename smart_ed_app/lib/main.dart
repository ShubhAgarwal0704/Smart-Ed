import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_ed_app/shared/providers/theme_provider.dart';

import 'core/api/dio_client.dart';
import 'core/constants/app_routes.dart';
import 'core/navigation/route_generator.dart';
import 'core/services/auth_service.dart';
import 'core/services/course_service.dart';
import 'core/services/storage_service.dart';
import 'core/services/user_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/courses/providers/course_provider.dart';
import 'features/navigation/providers/navigation_provider.dart';
import 'features/profile/providers/user_provider.dart';

void main() {
  final storageService = StorageService();
  final dioClient = DioClient();
  final authService = AuthService(dioClient, storageService);
  final userService = UserService(dioClient);
  final courseService = CourseService(dioClient, storageService, userService);


  runApp(
    MultiProvider(
      providers: [
        Provider<StorageService>(create: (_) => storageService),
        Provider<DioClient>(create: (_) => dioClient),
        Provider<AuthService>(create: (_) => authService),
        Provider<UserService>(create: (_) => userService),
        Provider<CourseService>(create: (_) => courseService),

        ChangeNotifierProvider(create: (_) => ThemeProvider(storageService)),
        ChangeNotifierProvider(create: (_) => AuthProvider(authService)),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),

        ChangeNotifierProvider(create: (context) => UserProvider(context.read<UserService>(), context.read<StorageService>())),
        ChangeNotifierProvider(create: (context) => CourseProvider(context.read<CourseService>(), context.read<StorageService>())),

      ],
      child: const SmartEdApp(),
    ),
  );
}

class SmartEdApp extends StatelessWidget {
  const SmartEdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'Smart Education Platform',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,

          initialRoute: AppRoutes.splash,
          onGenerateRoute: RouteGenerator.generateRoute,
        );
      },
    );
  }
}