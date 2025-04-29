import 'package:flutter/material.dart';
import '../../../core/constants/app_routes.dart';
import '../models/courses.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  Color _getLevelColor(String level) {
    switch (level.toUpperCase()) {
      case 'BEGINNER':
        return Colors.green.shade600;
      case 'INTERMEDIATE':
        return Colors.blueAccent.shade700;
      case 'EXPERT':
      case 'ADVANCED':
        return Colors.deepOrangeAccent.shade700;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBgColor = isDark ? theme.cardColor : Colors.white;

    final shadowColor = isDark ? Colors.black.withOpacity(0.6) : theme.shadowColor.withOpacity(0.2);

    final levelColor = _getLevelColor(course.level);

    const gradientColors = [
      Color(0xFFC18EFF),
      Color(0xFF3E1D70),
    ];

    const double borderThickness = 2.0;

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.courseDetails,
          arguments: course,
        );
      },
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(borderThickness),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16 - borderThickness),
          child: Container(
            color: cardBgColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(14 - borderThickness)),
                      child: Image.network(
                        course.thumbnailUrl,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 140,
                          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                          child: Center(
                            child: Icon(Icons.image_not_supported, size: 50, color: isDark ? Colors.grey.shade600 : Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8, // Adjusted position
                      right: 8, // Adjusted position
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                            color: levelColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: levelColor.withOpacity(0.4),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                        ),
                        child: Text(
                          course.level.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: theme.textTheme.bodyLarge?.color ?? Colors.black,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.star_rounded, size: 18, color: Colors.amber.shade600),
                                const SizedBox(width: 4),
                                Text(
                                  course.rating.toStringAsFixed(1),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.textTheme.bodyLarge?.color?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(${course.numberOfRatings})',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7) ?? Colors.black.withOpacity(0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.currency_rupee, size: 18, color: theme.colorScheme.primary),
                            const SizedBox(width: 4),
                            Text(
                              course.price.toStringAsFixed(0),
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
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