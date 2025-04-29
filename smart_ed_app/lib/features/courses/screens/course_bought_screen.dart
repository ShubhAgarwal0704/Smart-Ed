import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/providers/theme_provider.dart';

class CourseBoughtScreen extends StatefulWidget {
  const CourseBoughtScreen({super.key});

  @override
  State<CourseBoughtScreen> createState() => _CourseBoughtScreenState();
}

class _CourseBoughtScreenState extends State<CourseBoughtScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _showCheckmark = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      _controller.forward();
      setState(() => _showCheckmark = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '🎉 Congrats!',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 40
                  ),
                ),
                const SizedBox(height: 100),
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: AnimatedOpacity(
                    opacity: _showCheckmark ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.green.shade600,
                      child: const Icon(
                        Icons.check,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                AnimatedOpacity(
                  opacity: _showCheckmark ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 800),
                  child: Text(
                    'Purchase Successful!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
