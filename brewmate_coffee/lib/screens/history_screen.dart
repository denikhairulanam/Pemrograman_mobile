import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:brewmate_coffee/services/firestore_service.dart';
import 'package:brewmate_coffee/theme/app_theme.dart';
import 'package:brewmate_coffee/services/firebase_auth_service.dart';
import 'package:brewmate_coffee/models/coffee_recipe.dart';
import 'recipe_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'all';

  IconData _getCoffeeIcon(String coffeeType) {
    switch (coffeeType.toLowerCase()) {
      case 'espresso':
        return Icons.coffee_rounded;
      case 'latte':
        return Icons.coffee_maker_rounded;
      case 'cappuccino':
        return Icons.coffee_outlined;
      case 'americano':
        return Icons.water_drop_rounded;
      case 'mocha':
        return Icons.local_cafe_rounded;
      case 'macchiato':
        return Icons.emoji_food_beverage_rounded;
      default:
        return Icons.coffee_rounded;
    }
  }

  Color _getRecipeColor(int index, bool isDarkMode) {
    if (isDarkMode) {
      final darkColors = [
        AppTheme.darkPrimary,
        AppTheme.darkSecondary,
        const Color(0xFF7C4DFF),
        const Color(0xFF6200EA),
        const Color(0xFF311B92),
        const Color(0xFF651FFF),
      ];
      return darkColors[index % darkColors.length];
    } else {
      final lightColors = [
        AppTheme.lightPrimary,
        AppTheme.lightSecondary,
        const Color(0xFF6A11CB),
        const Color(0xFF9D4EDD),
        const Color(0xFF5A189A),
        const Color(0xFF7B2CBF),
      ];
      return lightColors[index % lightColors.length];
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;
    final firestoreService = Provider.of<FirestoreService>(context);
    final authService = context.read<FirebaseAuthService>();

    // Check if user is logged in
    if (authService.user == null) {
      return Scaffold(
        backgroundColor:
            isDarkMode ? AppTheme.darkBackground : AppTheme.lightSurface,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDarkMode ? AppTheme.grey800 : AppTheme.grey100,
                  ),
                  child: Icon(
                    Icons.login_rounded,
                    size: 50,
                    color: isDarkMode ? AppTheme.grey500 : AppTheme.grey400,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Silakan login terlebih dahulu',
                  style: AppTheme.titleMedium(isDarkMode),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: AppTheme.borderRadiusMedium,
                    gradient: LinearGradient(
                      colors: isDarkMode
                          ? [AppTheme.darkPrimary, AppTheme.darkSecondary]
                          : [AppTheme.lightPrimary, AppTheme.lightSecondary],
                    ),
                    boxShadow: AppTheme.getButtonShadow(isDarkMode),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: isDarkMode ? Colors.black : Colors.white,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppTheme.borderRadiusMedium,
                      ),
                    ),
                    child: const Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppTheme.darkBackground : AppTheme.lightSurface,
      body: SafeArea(
        child: Column(
          children: [
            // Main content
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppTheme.darkSurface : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: StreamBuilder<List<CoffeeRecipe>>(
                  stream:
                      firestoreService.getUserRecipes(authService.user!.uid),
                  builder: (context, snapshot) {
                    // Loading state
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isDarkMode
                                      ? [
                                          AppTheme.darkPrimary,
                                          AppTheme.darkSecondary,
                                        ]
                                      : [
                                          AppTheme.lightPrimary,
                                          AppTheme.lightSecondary,
                                        ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Memuat riwayat...',
                              style: AppTheme.bodyMedium(isDarkMode),
                            ),
                          ],
                        ),
                      );
                    }

                    // Error state
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDarkMode
                                    ? AppTheme.grey800
                                    : AppTheme.grey100,
                              ),
                              child: Icon(
                                Icons.error_outline_rounded,
                                size: 50,
                                color: isDarkMode
                                    ? AppTheme.grey500
                                    : AppTheme.grey400,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Terjadi kesalahan',
                              style: AppTheme.titleMedium(isDarkMode),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: AppTheme.bodySmall(isDarkMode),
                            ),
                          ],
                        ),
                      );
                    }

                    final recipes = snapshot.data ?? [];
                    final filteredRecipes = _filterRecipes(recipes);

                    // Empty state
                    if (filteredRecipes.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: isDarkMode
                                    ? [
                                        AppTheme.grey800,
                                        AppTheme.grey900,
                                      ]
                                    : [
                                        AppTheme.grey100,
                                        AppTheme.grey200,
                                      ],
                              ),
                            ),
                            child: Icon(
                              Icons.history_rounded,
                              size: 60,
                              color: isDarkMode
                                  ? AppTheme.grey500
                                  : AppTheme.grey400,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ShaderMask(
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                colors: isDarkMode
                                    ? [
                                        AppTheme.darkPrimary,
                                        AppTheme.darkSecondary,
                                      ]
                                    : [
                                        AppTheme.lightPrimary,
                                        AppTheme.lightSecondary,
                                      ],
                              ).createShader(bounds);
                            },
                            child: const Text(
                              'Belum ada riwayat',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              'Mulai buat kopi untuk melihat riwayat di sini',
                              textAlign: TextAlign.center,
                              style: AppTheme.bodyMedium(isDarkMode),
                            ),
                          ),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        // Filter section
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                isDarkMode ? AppTheme.grey800 : AppTheme.grey50,
                            borderRadius: AppTheme.borderRadiusMedium,
                            border: Border.all(
                              color: isDarkMode
                                  ? AppTheme.grey700
                                  : AppTheme.grey200,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) {
                                  return LinearGradient(
                                    colors: isDarkMode
                                        ? [
                                            AppTheme.darkPrimary,
                                            AppTheme.darkSecondary,
                                          ]
                                        : [
                                            AppTheme.lightPrimary,
                                            AppTheme.lightSecondary,
                                          ],
                                  ).createShader(bounds);
                                },
                                child: Text(
                                  'Filter:',
                                  style:
                                      AppTheme.titleSmall(isDarkMode).copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isDarkMode
                                        ? [
                                            AppTheme.darkPrimary,
                                            AppTheme.darkSecondary,
                                          ]
                                        : [
                                            AppTheme.lightPrimary,
                                            AppTheme.lightSecondary,
                                          ],
                                  ),
                                  borderRadius: AppTheme.borderRadiusCircle,
                                ),
                                child: Text(
                                  '${filteredRecipes.length} items',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Filter chips with scroll
                        SizedBox(
                          height: 40,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildFilterChip('Semua', 'all', isDarkMode),
                              const SizedBox(width: 8),
                              _buildFilterChip('Hari Ini', 'today', isDarkMode),
                              const SizedBox(width: 8),
                              _buildFilterChip(
                                  'Minggu Ini', 'week', isDarkMode),
                              const SizedBox(width: 8),
                              _buildFilterChip(
                                  'Bulan Ini', 'month', isDarkMode),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // History list
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredRecipes.length,
                            itemBuilder: (context, index) {
                              final recipe = filteredRecipes[index];
                              final color = _getRecipeColor(index, isDarkMode);

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  borderRadius: AppTheme.borderRadiusMedium,
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      color.withOpacity(0.9),
                                      color.withOpacity(0.7),
                                    ],
                                  ),
                                  boxShadow:
                                      AppTheme.getButtonShadow(isDarkMode),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RecipeDetailScreen(
                                                  recipe: recipe),
                                        ),
                                      );
                                    },
                                    borderRadius: AppTheme.borderRadiusMedium,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          // Coffee icon with gradient
                                          Container(
                                            width: 56,
                                            height: 56,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  Colors.white.withOpacity(0.2),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white
                                                      .withOpacity(0.1),
                                                  blurRadius: 8,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              _getCoffeeIcon(recipe.coffeeType),
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          // Recipe details
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Title and coffee amount
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      recipe.coffeeType
                                                          .toUpperCase(),
                                                      style:
                                                          AppTheme.titleMedium(
                                                                  isDarkMode)
                                                              .copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    ShaderMask(
                                                      shaderCallback: (bounds) {
                                                        return const LinearGradient(
                                                          colors: [
                                                            Colors.white,
                                                            Colors.white70
                                                          ],
                                                        ).createShader(bounds);
                                                      },
                                                      child: Text(
                                                        '${recipe.coffeeAmount}g',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                const SizedBox(height: 8),

                                                // Tags row
                                                Row(
                                                  children: [
                                                    // Cup size tag
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8,
                                                          vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white
                                                            .withOpacity(0.2),
                                                        borderRadius: AppTheme
                                                            .borderRadiusSmall,
                                                        border: Border.all(
                                                          color: Colors.white
                                                              .withOpacity(0.3),
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        recipe.cupSize,
                                                        style: AppTheme.caption(
                                                                isDarkMode)
                                                            .copyWith(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),

                                                    const SizedBox(width: 6),

                                                    // Strength tag
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8,
                                                          vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white
                                                            .withOpacity(0.2),
                                                        borderRadius: AppTheme
                                                            .borderRadiusSmall,
                                                        border: Border.all(
                                                          color: Colors.white
                                                              .withOpacity(0.3),
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        recipe.strength,
                                                        style: AppTheme.caption(
                                                                isDarkMode)
                                                            .copyWith(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),

                                                    // Favorite indicator
                                                    if (recipe.isFavorite)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 6),
                                                        child: Icon(
                                                          Icons
                                                              .favorite_rounded,
                                                          color: Colors.white
                                                              .withOpacity(0.9),
                                                          size: 14,
                                                        ),
                                                      ),
                                                  ],
                                                ),

                                                const SizedBox(height: 8),

                                                // Date and custom name
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Date
                                                    Text(
                                                      DateFormat(
                                                              'dd MMM yyyy, HH:mm')
                                                          .format(
                                                              recipe.createdAt),
                                                      style: AppTheme.caption(
                                                              isDarkMode)
                                                          .copyWith(
                                                        color: Colors.white
                                                            .withOpacity(0.8),
                                                      ),
                                                    ),

                                                    // Custom name (if exists)
                                                    if (recipe.customName !=
                                                            null &&
                                                        recipe.customName!
                                                            .isNotEmpty)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 4),
                                                        child: Text(
                                                          '${recipe.customName}',
                                                          style:
                                                              AppTheme.caption(
                                                                      isDarkMode)
                                                                  .copyWith(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.8),
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, bool isDarkMode) {
    final isSelected = _selectedFilter == value;

    return Container(
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
                colors: isDarkMode
                    ? [
                        AppTheme.darkPrimary,
                        AppTheme.darkSecondary,
                      ]
                    : [
                        AppTheme.lightPrimary,
                        AppTheme.lightSecondary,
                      ],
              )
            : null,
        borderRadius: AppTheme.borderRadiusCircle,
        border: isSelected
            ? null
            : Border.all(
                color: isDarkMode ? AppTheme.grey600 : AppTheme.grey300,
                width: 1,
              ),
        boxShadow: isSelected ? AppTheme.getButtonShadow(isDarkMode) : [],
      ),
      child: Material(
        color: isSelected
            ? Colors.transparent
            : (isDarkMode ? AppTheme.grey800 : Colors.white),
        borderRadius: AppTheme.borderRadiusCircle,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedFilter = value;
            });
          },
          borderRadius: AppTheme.borderRadiusCircle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDarkMode ? Colors.white : Colors.black),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<CoffeeRecipe> _filterRecipes(List<CoffeeRecipe> recipes) {
    final now = DateTime.now();

    switch (_selectedFilter) {
      case 'today':
        final today = DateTime(now.year, now.month, now.day);
        return recipes.where((recipe) {
          final recipeDate = DateTime(
            recipe.createdAt.year,
            recipe.createdAt.month,
            recipe.createdAt.day,
          );
          return recipeDate == today;
        }).toList();

      case 'week':
        final weekAgo = now.subtract(const Duration(days: 7));
        return recipes.where((recipe) {
          return recipe.createdAt.isAfter(weekAgo);
        }).toList();

      case 'month':
        final monthAgo = now.subtract(const Duration(days: 30));
        return recipes.where((recipe) {
          return recipe.createdAt.isAfter(monthAgo);
        }).toList();

      default:
        return recipes;
    }
  }
}
