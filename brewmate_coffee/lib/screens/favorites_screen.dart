import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brewmate_coffee/models/coffee_recipe.dart';
import 'package:brewmate_coffee/services/firestore_service.dart';
import 'package:brewmate_coffee/theme/app_theme.dart';
import 'package:brewmate_coffee/services/firebase_auth_service.dart';
import 'recipe_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool _isLoading = false;

  Future<void> _toggleFavorite(String recipeId, bool currentStatus) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final firestoreService =
          Provider.of<FirestoreService>(context, listen: false);
      await firestoreService.toggleFavorite(recipeId, !currentStatus);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            !currentStatus
                ? 'Ditambahkan ke favorit!'
                : 'Dihapus dari favorit!',
          ),
          backgroundColor:
              !currentStatus ? Colors.green : AppTheme.lightPrimary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppTheme.borderRadiusMedium,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui favorit: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppTheme.borderRadiusMedium,
          ),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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

  Color _getCoffeeColor(int index, bool isDarkMode) {
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
            isDarkMode ? AppTheme.darkBackground : AppTheme.lightPrimary,
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
                    color: isDarkMode
                        ? AppTheme.darkPrimary
                        : AppTheme.lightPrimary,
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
          isDarkMode ? AppTheme.darkBackground : AppTheme.lightPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color:
                    isDarkMode ? AppTheme.darkSurface : AppTheme.lightPrimary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: isDarkMode
                    ? AppTheme.darkElevatedShadow
                    : AppTheme.lightElevatedShadow,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resep Favorit',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Koleksi resep kesukaan Anda',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.refresh_rounded, color: Colors.white),
                      onPressed: () => setState(() {}),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),

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
                  stream: firestoreService
                      .getFavoriteRecipes(authService.user!.uid),
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
                                color: isDarkMode
                                    ? AppTheme.darkPrimary
                                    : AppTheme.lightPrimary,
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
                              'Memuat resep favorit...',
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
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: AppTheme.borderRadiusMedium,
                                color: isDarkMode
                                    ? AppTheme.darkPrimary
                                    : AppTheme.lightPrimary,
                                boxShadow: AppTheme.getButtonShadow(isDarkMode),
                              ),
                              child: ElevatedButton(
                                onPressed: () => setState(() {}),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor:
                                      isDarkMode ? Colors.black : Colors.white,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppTheme.borderRadiusMedium,
                                  ),
                                ),
                                child: const Text('Coba Lagi'),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final recipes = snapshot.data ?? [];

                    // Empty state
                    if (recipes.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDarkMode
                                    ? AppTheme.grey800
                                    : AppTheme.grey100,
                              ),
                              child: Icon(
                                Icons.favorite_border_rounded,
                                size: 60,
                                color: isDarkMode
                                    ? AppTheme.grey500
                                    : AppTheme.grey400,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Belum ada resep favorit',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Montserrat',
                                color: isDarkMode
                                    ? AppTheme.darkPrimary
                                    : AppTheme.lightPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                'Simpan resep favorit Anda untuk melihatnya di sini',
                                textAlign: TextAlign.center,
                                style: AppTheme.bodyMedium(isDarkMode),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: AppTheme.borderRadiusMedium,
                                color: isDarkMode
                                    ? AppTheme.darkPrimary
                                    : AppTheme.lightPrimary,
                                boxShadow: AppTheme.getButtonShadow(isDarkMode),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/selection');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor:
                                      isDarkMode ? Colors.black : Colors.white,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppTheme.borderRadiusMedium,
                                  ),
                                ),
                                child: const Text('Buat Resep Baru'),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Grid view for recipes
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats and header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Resep Favorit',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Montserrat',
                                color: isDarkMode
                                    ? AppTheme.darkPrimary
                                    : AppTheme.lightPrimary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? AppTheme.darkPrimary
                                    : AppTheme.lightPrimary,
                                borderRadius: AppTheme.borderRadiusCircle,
                              ),
                              child: Text(
                                '${recipes.length} items',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Recipes grid
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: recipes.length,
                            itemBuilder: (context, index) {
                              final recipe = recipes[index];
                              final color = _getCoffeeColor(index, isDarkMode);

                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: AppTheme.borderRadiusLarge,
                                  color: color,
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
                                    borderRadius: AppTheme.borderRadiusLarge,
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Coffee icon
                                              Container(
                                                width: 56,
                                                height: 56,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white
                                                      .withOpacity(0.2),
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
                                                  _getCoffeeIcon(
                                                      recipe.coffeeType),
                                                  color: Colors.white,
                                                  size: 24,
                                                ),
                                              ),
                                              // Coffee details
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    recipe.coffeeType,
                                                    style: AppTheme.titleMedium(
                                                            isDarkMode)
                                                        .copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    '${recipe.cupSize} • ${recipe.strength}',
                                                    style: AppTheme.bodySmall(
                                                            isDarkMode)
                                                        .copyWith(
                                                      color: Colors.white
                                                          .withOpacity(0.9),
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  if (recipe.customName !=
                                                          null &&
                                                      recipe.customName!
                                                          .isNotEmpty)
                                                    Text(
                                                      '${recipe.customName}',
                                                      style: AppTheme.caption(
                                                              isDarkMode)
                                                          .copyWith(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: Colors.white
                                                            .withOpacity(0.8),
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Favorite button
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  Colors.white.withOpacity(0.2),
                                              border: Border.all(
                                                color: Colors.white
                                                    .withOpacity(0.3),
                                                width: 1,
                                              ),
                                            ),
                                            child: IconButton(
                                              icon: _isLoading
                                                  ? const SizedBox(
                                                      width: 16,
                                                      height: 16,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        valueColor:
                                                            AlwaysStoppedAnimation(
                                                                Colors.white),
                                                      ),
                                                    )
                                                  : const Icon(
                                                      Icons.favorite_rounded,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                              onPressed: () => _toggleFavorite(
                                                  recipe.id, recipe.isFavorite),
                                              padding: EdgeInsets.zero,
                                            ),
                                          ),
                                        ),
                                      ],
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
}
