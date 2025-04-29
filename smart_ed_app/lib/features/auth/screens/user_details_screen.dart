import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../providers/auth_provider.dart';
import '../../../core/constants/app_routes.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({super.key});

  void _onContinue(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.validateUserDetailsInputs()) {
      Navigator.pushNamed(context, AppRoutes.signupInterests);
    } else {
      CustomSnackBar.show(
        context,
        authProvider.errorMessage ?? "Recheck user details", "Error!",
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
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'User Details',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Please provide your details to proceed',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                        const SizedBox(height: 48),
                        CustomTextField(
                          controller: authProvider.usernameController,
                          hintText: 'Username',
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: authProvider.firstNameController,
                          hintText: 'First Name',
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: authProvider.lastNameController,
                          hintText: 'Last Name',
                        ),
                        const SizedBox(height: 40),
                        CustomButton(
                          text: 'Continue',
                          onPressed: () => _onContinue(context),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}