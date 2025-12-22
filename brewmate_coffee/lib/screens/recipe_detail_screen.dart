import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:brewmate_coffee/models/coffee_recipe.dart';
import 'package:brewmate_coffee/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:brewmate_coffee/theme/app_theme.dart';

class RecipeDetailScreen extends StatelessWidget {
  final CoffeeRecipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppTheme.darkBackground : AppTheme.lightSurface,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar with gradient
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDarkMode
                      ? [
                          AppTheme.darkSurface,
                          AppTheme.darkBackground,
                        ]
                      : [
                          AppTheme.lightPrimary,
                          AppTheme.lightSecondary,
                        ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode ? Colors.black : Colors.black12,
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded,
                            color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) {
                              return const LinearGradient(
                                colors: [Colors.white, Colors.white70],
                              ).createShader(bounds);
                            },
                            child: const Text(
                              'RESEP DETAIL',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            recipe.coffeeType,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.share_rounded,
                              color: Colors.white, size: 20),
                          onPressed: () => _shareRecipe(context),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.edit_rounded,
                              color: Colors.white, size: 20),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/selection',
                              arguments: {
                                'isEditMode': true,
                                'initialRecipe': recipe,
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recipe Header Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDarkMode
                                ? [
                                    AppTheme.darkSurface,
                                    AppTheme.darkBackground,
                                  ]
                                : [
                                    AppTheme.lightPrimary,
                                    AppTheme.lightSecondary,
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: (isDarkMode
                                      ? Colors.black
                                      : AppTheme.lightPrimary)
                                  .withOpacity(isDarkMode ? 0.5 : 0.3),
                              blurRadius: 15,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                              ),
                              child: Icon(
                                _getCoffeeIcon(recipe.coffeeType),
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recipe.coffeeType.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          recipe.cupSize,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          recipe.strength,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (recipe.customName != null &&
                                      recipe.customName!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        '${recipe.customName}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white.withOpacity(0.9),
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  recipe.isFavorite
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  color: recipe.isFavorite
                                      ? Colors.red
                                      : Colors.white,
                                  size: 22,
                                ),
                                onPressed: () async {
                                  try {
                                    await firestoreService.toggleFavorite(
                                      recipe.id,
                                      !recipe.isFavorite,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          !recipe.isFavorite
                                              ? 'Ditambahkan ke favorit!'
                                              : 'Dihapus dari favorit!',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        backgroundColor: !recipe.isFavorite
                                            ? Colors.green
                                            : AppTheme.lightPrimary,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error: $e',
                                            style: const TextStyle(
                                                color: Colors.white)),
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Ingredients Section
                      _buildSectionTitle('Bahan-bahan', isDarkMode),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? const Color(0xFF2D2D2D)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: (isDarkMode ? Colors.black : Colors.grey)
                                  .withOpacity(isDarkMode ? 0.3 : 0.1),
                              blurRadius: 15,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildIngredientRow(
                              'Kopi Bubuk',
                              '${recipe.coffeeAmount}g',
                              Icons.coffee_rounded,
                              isDarkMode,
                            ),
                            _buildDivider(isDarkMode),
                            _buildIngredientRow(
                              'Air Panas',
                              '${recipe.waterAmount}ml',
                              Icons.water_drop_rounded,
                              isDarkMode,
                            ),
                            if (recipe.milkAmount != null &&
                                recipe.milkAmount! > 0) ...[
                              _buildDivider(isDarkMode),
                              _buildIngredientRow(
                                'Susu',
                                '${recipe.milkAmount}ml',
                                Icons.local_drink_rounded,
                                isDarkMode,
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Instructions Section
                      _buildSectionTitle('Langkah Pembuatan', isDarkMode),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? const Color(0xFF2D2D2D)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: (isDarkMode ? Colors.black : Colors.grey)
                                  .withOpacity(isDarkMode ? 0.3 : 0.1),
                              blurRadius: 15,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: recipe.instructions.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: recipe.instructions
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  final index = entry.key + 1;
                                  final instruction = entry.value;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 28,
                                          height: 28,
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
                                          child: Center(
                                            child: Text(
                                              index.toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            instruction,
                                            style: TextStyle(
                                              fontSize: 15,
                                              height: 1.5,
                                              color: isDarkMode
                                                  ? Colors.grey.shade300
                                                  : Colors.grey.shade700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              )
                            : Text(
                                'Tidak ada instruksi khusus.',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: isDarkMode
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                      ),

                      const SizedBox(height: 30),

                      // Additional Info
                      _buildSectionTitle('Informasi', isDarkMode),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? const Color(0xFF2D2D2D)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: (isDarkMode ? Colors.black : Colors.grey)
                                  .withOpacity(isDarkMode ? 0.3 : 0.1),
                              blurRadius: 15,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              'Dibuat pada',
                              _formatDate(recipe.createdAt),
                              Icons.calendar_today_rounded,
                              isDarkMode,
                            ),
                            if (recipe.updatedAt != null) ...[
                              _buildDivider(isDarkMode),
                              _buildInfoRow(
                                'Terakhir diperbarui',
                                _formatDate(recipe.updatedAt!),
                                Icons.update_rounded,
                                isDarkMode,
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Buttons Row
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.red.shade600,
                                    Colors.red.shade800,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () =>
                                    _showDeleteConfirmation(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.transparent,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.delete_rounded, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Hapus',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
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
                                boxShadow: [
                                  BoxShadow(
                                    color: (isDarkMode
                                            ? AppTheme.darkPrimary
                                            : AppTheme.lightPrimary)
                                        .withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/brewing',
                                    arguments: {
                                      'coffeeType': recipe.coffeeType,
                                      'cupSize': recipe.cupSize,
                                      'strength': recipe.strength,
                                      'recipeId': recipe.id,
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.transparent,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.replay_rounded, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Buat Lagi',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method untuk share recipe
  Future<void> _shareRecipe(BuildContext context) async {
    final String recipeText = '''
☕ *Resep ${recipe.coffeeType.toUpperCase()}*
      
🍵 **Jenis Kopi**: ${recipe.coffeeType}
🥤 **Ukuran Cangkir**: ${recipe.cupSize}
⚡ **Kekuatan**: ${recipe.strength}
      
📋 **Bahan-bahan**:
- Kopi Bubuk: ${recipe.coffeeAmount}g
- Air Panas: ${recipe.waterAmount}ml
${recipe.milkAmount != null && recipe.milkAmount! > 0 ? '- Susu: ${recipe.milkAmount}ml' : ''}
      
👨‍🍳 **Cara Membuat**:
${recipe.instructions.isNotEmpty ? recipe.instructions.map((step) => '• $step').join('\n') : 'Tidak ada instruksi khusus.'}
      
📅 Dibuat pada: ${_formatDate(recipe.createdAt)}
      
#BrewmateCoffee #ResepKopi #${recipe.coffeeType}
    ''';

    try {
      await Share.share(
        recipeText,
        subject: 'Resep ${recipe.coffeeType} dari Brewmate Coffee',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membagikan resep: $e',
              style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  // Method untuk konfirmasi hapus
  void _showDeleteConfirmation(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.delete_rounded,
                  color: Colors.red,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Hapus Resep',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Apakah Anda yakin ingin menghapus resep ini?\nTindakan ini tidak dapat dibatalkan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                            isDarkMode ? Colors.white : Colors.black,
                        side: BorderSide(
                          color: isDarkMode
                              ? Colors.grey.shade600
                              : Colors.grey.shade300,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await _deleteRecipe(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Hapus'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method untuk menghapus recipe
  Future<void> _deleteRecipe(BuildContext context) async {
    final firestoreService =
        Provider.of<FirestoreService>(context, listen: false);

    try {
      await firestoreService.deleteRecipe(recipe.id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Resep berhasil dihapus!',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus resep: $e',
              style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4),
      child: ShaderMask(
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
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            fontFamily: 'Montserrat',
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientRow(
      String name, String amount, IconData icon, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDarkMode
                  ? AppTheme.darkPrimary.withOpacity(0.2)
                  : AppTheme.lightPrimary.withOpacity(0.1),
            ),
            child: Icon(
              icon,
              color: isDarkMode ? AppTheme.darkPrimary : AppTheme.lightPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? AppTheme.darkPrimary : AppTheme.lightPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      String label, String value, IconData icon, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
            ),
            child: Icon(
              icon,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Divider(
      height: 1,
      color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
      indent: 52,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  IconData _getCoffeeIcon(String type) {
    switch (type.toLowerCase()) {
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
}
