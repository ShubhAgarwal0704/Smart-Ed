import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../providers/auth_provider.dart';
import '../../../core/constants/app_routes.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  void _onSignUp(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.validateSignupInputs()) {
      Navigator.pushNamed(context, AppRoutes.signupDetails);
    } else {
      CustomSnackBar.show(
        context,
        authProvider.errorMessage ?? "Recheck email and password", "Error!",
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
                          'Create Account',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Sign up to access your learning dashboard',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                        const SizedBox(height: 48),
                        CustomTextField(
                          controller: authProvider.emailController,
                          hintText: 'Email',
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: authProvider.passwordController,
                          hintText: 'Password',
                          isPassword: true,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: authProvider.confirmPasswordController,
                          hintText: 'Confirm Password',
                          isPassword: true,
                        ),
                        const SizedBox(height: 40),
                        CustomButton(
                          text: 'Sign Up',
                          onPressed: () => _onSignUp(context),
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