import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../providers/navigation_provider.dart';
import '../../home/screens/home_screen.dart';
import '../../courses/screens/course_list_screen.dart';
import '../../search/screens/search_screen.dart';
import '../../courses/screens/category_screen.dart';
import '../../profile/screens/profile_screen.dart';

class MainNavigationScreen extends StatelessWidget {
  final int initialIndex;

  MainNavigationScreen({this.initialIndex = 0, super.key});

  final List<Widget> _screens = [
    const HomeScreen(),
    const CourseListScreen(),
    const SearchScreen(),
    CategoryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navProvider = Provider.of<NavigationProvider>(context, listen: false);
      if (navProvider.selectedIndex != initialIndex) {
      }
    });

    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        final theme = Theme.of(context);
        final iconColor = theme.colorScheme.onPrimary;
        return Scaffold(
          extendBody: true,
          body: IndexedStack(
            index: navigationProvider.selectedIndex,
            children: _screens,
          ),
          bottomNavigationBar: CurvedNavigationBar(
            index: navigationProvider.selectedIndex,
            onTap: (index) => navigationProvider.setIndex(index),
            backgroundColor: Colors.transparent,
            color: theme.colorScheme.primary,
            buttonBackgroundColor: theme.colorScheme.secondary,
            animationDuration: const Duration(milliseconds: 300),
            height: 60,
            items: [
              Icon(Icons.home_rounded, size: 30, color: iconColor),
              Icon(Icons.bookmark, size: 30, color: iconColor),
              Icon(Icons.search_rounded, size: 34, color: iconColor),
              Icon(Icons.category_rounded, size: 30, color: iconColor),
              Icon(Icons.person_rounded, size: 30, color: iconColor),
            ],
          ),
        );
      },
    );
  }
}
