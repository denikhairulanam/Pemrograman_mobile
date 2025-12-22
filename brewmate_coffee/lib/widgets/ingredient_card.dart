import 'package:flutter/material.dart';
import 'package:brewmate_coffee/theme/app_theme.dart';

class IngredientCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color color;
  final String? unit;
  final VoidCallback? onTap;
  final bool isDarkMode;

  const IngredientCard({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    this.unit,
    this.onTap,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final isDark = isDarkMode || brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : Colors.white,
          borderRadius: AppTheme.borderRadiusLarge,
          boxShadow:
              isDark ? AppTheme.darkCardShadow : AppTheme.lightCardShadow,
          border: Border.all(
            color:
                isDark ? AppTheme.grey700.withOpacity(0.5) : AppTheme.grey200,
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppTheme.borderRadiusLarge,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon with gradient background
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withOpacity(isDark ? 0.2 : 0.15),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(isDark ? 0.2 : 0.1),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      size: 28,
                      color: color,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Title
                  Text(
                    title,
                    style: AppTheme.titleSmall(isDark).copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppTheme.grey300 : AppTheme.grey800,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Amount with unit
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      // Amount
                      Text(
                        amount,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          height: 1,
                          color: isDark
                              ? AppTheme.darkPrimary
                              : AppTheme.lightPrimary,
                        ),
                      ),

                      // Unit (if provided)
                      if (unit != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            unit!,
                            style: AppTheme.caption(isDark).copyWith(
                              color:
                                  isDark ? AppTheme.grey400 : AppTheme.grey600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
