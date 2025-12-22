import 'package:flutter/material.dart';
import 'package:brewmate_coffee/theme/app_theme.dart';

class StepWidget extends StatelessWidget {
  final int stepNumber;
  final String instruction;
  final bool isActive;
  final VoidCallback onTap;
  final bool showNumber;
  final bool isDarkMode;

  const StepWidget({
    super.key,
    required this.stepNumber,
    required this.instruction,
    this.isActive = false,
    required this.onTap,
    this.showNumber = true,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final isDark = isDarkMode || brightness == Brightness.dark;

    final activeColor = isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary;
    final inactiveColor = isDark ? AppTheme.grey700 : AppTheme.grey300;
    final bgColor = isDark ? AppTheme.darkSurface : Colors.white;
    final activeBgColor = isDark
        ? AppTheme.darkPrimary.withOpacity(0.15)
        : AppTheme.lightPrimary.withOpacity(0.1);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isActive ? activeBgColor : bgColor,
          borderRadius: AppTheme.borderRadiusLarge,
          border: Border.all(
            color: isActive ? activeColor : inactiveColor,
            width: isActive ? 2 : 1,
          ),
          boxShadow: isActive
              ? isDark
                  ? [
                      BoxShadow(
                        color: AppTheme.darkPrimary.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 3),
                      )
                    ]
                  : [
                      BoxShadow(
                        color: AppTheme.lightPrimary.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 3),
                      )
                    ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppTheme.borderRadiusLarge,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step number circle
                  if (showNumber)
                    Container(
                      width: 36,
                      height: 36,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: isActive ? activeColor : inactiveColor,
                        shape: BoxShape.circle,
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: activeColor.withOpacity(0.4),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                )
                              ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          stepNumber.toString(),
                          style: TextStyle(
                            color: isActive
                                ? isDark
                                    ? Colors.black
                                    : Colors.white
                                : isDark
                                    ? Colors.white
                                    : Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Step title
                        Row(
                          children: [
                            Text(
                              'Langkah $stepNumber',
                              style: AppTheme.titleSmall(isDark).copyWith(
                                fontWeight: FontWeight.w700,
                                color: isActive
                                    ? activeColor
                                    : isDark
                                        ? AppTheme.grey400
                                        : AppTheme.grey600,
                              ),
                            ),
                            const Spacer(),
                            if (isActive)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: activeColor.withOpacity(0.1),
                                  borderRadius: AppTheme.borderRadiusSmall,
                                  border: Border.all(
                                    color: activeColor,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: activeColor,
                                      size: 12,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Aktif',
                                      style: TextStyle(
                                        color: activeColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Instruction
                        Text(
                          instruction,
                          style: AppTheme.bodyMedium(isDark).copyWith(
                            height: 1.5,
                            color: isDark
                                ? isActive
                                    ? Colors.white.withOpacity(0.9)
                                    : AppTheme.grey300
                                : isActive
                                    ? AppTheme.grey800
                                    : AppTheme.grey700,
                          ),
                        ),
                      ],
                    ),
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
