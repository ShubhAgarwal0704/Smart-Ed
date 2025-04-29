import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../providers/auth_provider.dart';
import '../../../core/constants/app_routes.dart';
import '../widgets/custom_button.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  final List<String> _availableInterests = [
    'Technology',
    'Science',
    'Art',
    'Maths',
    'Finance',
    'Economics',
    'Design',
    'Music',
    'Business',
    'Law'
  ];
  final List<String> _selectedInterests = [];

  void _onInterestToggle(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
  }

  void _onFinish(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (_selectedInterests.isEmpty) {
      CustomSnackBar.show(context, "Please select at least one interest", "Error!");
      return;
    }

    final success = await authProvider.signUp(_selectedInterests);
    if (success) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.main,
            (Route<dynamic> route) => false,
      );
    } else {
      CustomSnackBar.show(
        context,
        authProvider.errorMessage ?? "An error occurred during sign-up", "Error!",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(0.2),
                  theme.colorScheme.secondary.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Select Interests',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Choose your interests to personalize your experience',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                  const SizedBox(height: 48),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _availableInterests.length,
                      itemBuilder: (context, index) {
                        final interest = _availableInterests[index];
                        final isSelected = _selectedInterests.contains(interest);

                        return ListTile(
                          title: Text(interest),
                          trailing: Icon(
                            isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                            color: isSelected ? theme.colorScheme.primary : theme.hintColor,
                          ),
                          onTap: () => _onInterestToggle(interest),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Finish',
                    onPressed: () => _onFinish(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}