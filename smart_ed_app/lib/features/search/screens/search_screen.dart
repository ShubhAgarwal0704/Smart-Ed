import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../courses/providers/course_provider.dart';
import '../../courses/widgets/course_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late CourseProvider _courseProvider;

  @override
  void initState() {
    super.initState();
    _courseProvider = Provider.of<CourseProvider>(context, listen: false);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();

    if (query.length > 3) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (query == _searchController.text.trim()) {
          _courseProvider.searchCourses(query);
        }
      });
    } else {
      _courseProvider.clearSearchResults();
    }
  }


  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Courses')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for courses...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                if (value.trim().length > 3) {
                  _courseProvider.searchCourses(value.trim());
                }
              },
            ),
          ),

          Expanded(
            child: Consumer<CourseProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading(CourseListType.search)) {
                  // Show loading indicator while searching
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final error = provider.getError(CourseListType.search);
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


                final searchResults = provider.searchResults;
                final hasQuery = _searchController.text.trim().isNotEmpty;


                if (!hasQuery) {
                  return const Center(
                    child: Text('Enter at least 4 characters to search.'),
                  );
                }


                if (searchResults.isEmpty) {
                  return const Center(
                    child: Text('No courses found for your search term.'),
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
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final course = searchResults[index];
                    return CourseCard(course: course);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}