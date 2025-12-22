// lib/screens/brewing_screen.dart (update dengan tombol edit)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brewmate_coffee/services/firestore_service.dart';
import 'package:brewmate_coffee/services/firebase_auth_service.dart';
import 'package:brewmate_coffee/services/coffee_recommendation_service.dart';
import 'package:brewmate_coffee/widgets/step_widget.dart';
import 'package:brewmate_coffee/widgets/ingredient_card.dart';
import 'package:brewmate_coffee/models/coffee_recipe.dart';
import 'package:brewmate_coffee/theme/app_theme.dart';
import 'package:brewmate_coffee/screens/coffee_selection_screen.dart'; // Import baru
import 'package:brewmate_coffee/screens/main_navigation.dart';

class BrewingScreen extends StatefulWidget {
  final Map<String, dynamic> preferences;

  const BrewingScreen({super.key, required this.preferences});

  @override
  _BrewingScreenState createState() => _BrewingScreenState();
}

class _BrewingScreenState extends State<BrewingScreen> {
  late Map<String, double> ingredients;
  late List<String> instructions;
  late String displayName;
  late String description;
  int currentStep = 0;
  bool isFavorite = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializeRecipe();
  }

  void _initializeRecipe() {
    // Generate recipe based on preferences
    final recipeData = CoffeeRecommendationService.generateRecipe(
      widget.preferences['coffeeType'] ?? 'espresso',
      widget.preferences['cupSize'] ?? 'medium',
      widget.preferences['strength'] ?? 'regular',
      widget.preferences['customName'],
      widget.preferences['customDescription'],
    );

    ingredients = recipeData['ingredients'] as Map<String, double>;
    instructions = recipeData['instructions'] as List<String>;
    displayName = recipeData['displayName'] as String;
    description = recipeData['description'] as String;
  }

  Future<void> _saveRecipe() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final authService =
          Provider.of<FirebaseAuthService>(context, listen: false);
      final firestoreService =
          Provider.of<FirestoreService>(context, listen: false);

      // Check if user is logged in
      if (authService.user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Silakan login terlebih dahulu untuk menyimpan resep'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final recipe = CoffeeRecipe(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: authService.user!.uid,
        coffeeType: widget.preferences['coffeeType'] ?? 'espresso',
        cupSize: widget.preferences['cupSize'] ?? 'medium',
        strength: widget.preferences['strength'] ?? 'regular',
        coffeeAmount: ingredients['coffee'] ?? 18.0,
        waterAmount: ingredients['water'] ?? 250.0,
        milkAmount:
            ingredients.containsKey('milk') ? ingredients['milk'] : null,
        chocolateAmount: ingredients.containsKey('chocolate')
            ? ingredients['chocolate']
            : null,
        instructions: instructions,
        createdAt: DateTime.now(),
        isFavorite: true,
        ingredients: ingredients,
        customName: displayName,
        customDescription: description.isNotEmpty ? description : null,
        // Add weather context if available
        weatherContext: widget.preferences['weatherContext'] ?? null,
      );

      await firestoreService.saveRecipe(recipe);
      if (!mounted) return;
      setState(() {
        isFavorite = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Resep berhasil disimpan!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );

        // Navigate to main navigation with favorites tab selected
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MainNavigation(initialIndex: 1),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _buildIngredientCards(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    List<Widget> cards = [
      IngredientCard(
        title: 'Kopi Bubuk',
        amount: '${ingredients['coffee']}',
        unit: 'g',
        icon: Icons.coffee,
        color: isDarkMode ? AppTheme.darkPrimary : AppTheme.lightPrimary,
        isDarkMode: isDarkMode,
      ),
      IngredientCard(
        title: 'Air',
        amount: '${ingredients['water']}',
        unit: 'ml',
        icon: Icons.water_drop,
        color: isDarkMode ? Colors.blue.shade300 : Colors.blue.shade600,
        isDarkMode: isDarkMode,
      ),
    ];

    if (ingredients.containsKey('milk')) {
      cards.add(
        IngredientCard(
          title: 'Susu',
          amount: '${ingredients['milk']}',
          unit: 'ml',
          icon: Icons.local_drink,
          color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade600,
          isDarkMode: isDarkMode,
        ),
      );
    }

    if (ingredients.containsKey('chocolate')) {
      cards.add(
        IngredientCard(
          title: 'Cokelat',
          amount: '${ingredients['chocolate']}',
          unit: 'g',
          icon: Icons.cake,
          color: const Color(0xFF8B4513),
          isDarkMode: isDarkMode,
        ),
      );
    }

    if (ingredients.containsKey('jahe')) {
      cards.add(
        IngredientCard(
          title: 'Jahe',
          amount: '${ingredients['jahe']}',
          unit: 'g',
          icon: Icons.emoji_food_beverage,
          color: const Color(0xFFD2691E),
          isDarkMode: isDarkMode,
        ),
      );
    }

    if (ingredients.containsKey('gula_aren')) {
      cards.add(
        IngredientCard(
          title: 'Gula Aren',
          amount: '${ingredients['gula_aren']}',
          unit: 'ml',
          icon: Icons.agriculture,
          color: const Color(0xFFA0522D),
          isDarkMode: isDarkMode,
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.85,
      children: cards,
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    final cupSizeLabel = {
          'extra_small': 'Sangat Kecil (120ml)',
          'small': 'Kecil (180ml)',
          'medium': 'Sedang (250ml)',
          'large': 'Besar (350ml)',
          'extra_large': 'Sangat Besar (450ml)',
          'mug': 'Mug (350ml)',
          'travel': 'Travel Mug (400ml)',
        }[widget.preferences['cupSize']] ??
        'Sedang';

    final strengthLabel = {
          'very_light': 'Sangat Ringan',
          'light': 'Ringan',
          'regular': 'Sedang',
          'strong': 'Kuat',
          'very_strong': 'Sangat Kuat',
        }[widget.preferences['strength']] ??
        'Sedang';

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppTheme.darkBackground : AppTheme.lightSurface,
      body: Column(
        children: [
          // Header with recipe info
          _buildHeader(cupSizeLabel, strengthLabel, isDarkMode),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  if (description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        description,
                        style: AppTheme.bodyMedium(isDarkMode).copyWith(
                          fontStyle: FontStyle.italic,
                          color:
                              isDarkMode ? AppTheme.grey400 : AppTheme.grey600,
                        ),
                      ),
                    ),

                  // Ingredients Section
                  _buildSectionTitle('Takaran Bahan', isDarkMode),
                  _buildIngredientCards(context),

                  const SizedBox(height: 24),

                  // Cup Size Info
                  _buildCupSizeInfo(cupSizeLabel, isDarkMode),

                  const SizedBox(height: 24),

                  // Instructions Section
                  _buildSectionTitle('Langkah-langkah', isDarkMode),
                  ...instructions.asMap().entries.map((entry) {
                    int index = entry.key;
                    String instruction = entry.value;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: StepWidget(
                        stepNumber: index + 1,
                        instruction: instruction,
                        isActive: index == currentStep,
                        onTap: () {
                          setState(() {
                            currentStep = index;
                          });
                        },
                        isDarkMode: isDarkMode,
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 24),

                  // Edit Recipe Button
                  _buildEditRecipeButton(isDarkMode),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomButtons(isDarkMode),
    );
  }

  Widget _buildHeader(
      String cupSizeLabel, String strengthLabel, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    AppTheme.darkPrimary.withOpacity(0.9),
                    AppTheme.darkSecondary.withOpacity(0.7),
                  ]
                : [
                    AppTheme.lightPrimary.withOpacity(0.9),
                    AppTheme.lightSecondary.withOpacity(0.7),
                  ],
          ),
          borderRadius: AppTheme.borderRadiusLarge,
          boxShadow: isDarkMode
              ? AppTheme.darkElevatedShadow
              : AppTheme.lightElevatedShadow,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Back button and Recipe Name
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Expanded(
                    child: ShaderMask(
                      shaderCallback: (bounds) {
                        return const LinearGradient(
                          colors: [Colors.white, Colors.white70],
                        ).createShader(bounds);
                      },
                      child: Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Montserrat',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),

              // Description
              if (description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Recipe Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildPreferenceItem(
                    'Ukuran Cangkir',
                    cupSizeLabel,
                    Icons.zoom_out_map,
                    isDarkMode,
                  ),
                  _buildPreferenceItem(
                    'Kekuatan Kopi',
                    strengthLabel,
                    Icons.bolt,
                    isDarkMode,
                  ),
                  _buildPreferenceItem(
                    'Total Volume',
                    '${ingredients.values.fold(0.0, (a, b) => a + b).round()}ml',
                    Icons.insights,
                    isDarkMode,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCupSizeInfo(String cupSizeLabel, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.darkSurface : Colors.white,
        borderRadius: AppTheme.borderRadiusLarge,
        boxShadow:
            isDarkMode ? AppTheme.darkCardShadow : AppTheme.lightCardShadow,
        border: Border.all(
          color: isDarkMode ? AppTheme.grey700 : AppTheme.grey200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
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
              ),
              child: Icon(
                Icons.info_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Info Ukuran: $cupSizeLabel',
                    style: AppTheme.titleSmall(isDarkMode).copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Resep ini dioptimalkan untuk ukuran cangkir ini. '
                    'Sesuaikan takaran jika menggunakan cangkir berbeda.',
                    style: AppTheme.bodySmall(isDarkMode).copyWith(
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4),
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
            fontSize: 20,
            fontWeight: FontWeight.w800,
            fontFamily: 'Montserrat',
          ),
        ),
      ),
    );
  }

  Widget _buildEditRecipeButton(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.darkSurface : Colors.white,
        borderRadius: AppTheme.borderRadiusLarge,
        boxShadow:
            isDarkMode ? AppTheme.darkCardShadow : AppTheme.lightCardShadow,
        border: Border.all(
          color: isDarkMode ? AppTheme.grey700 : AppTheme.grey200,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _navigateToCoffeeSelection();
          },
          borderRadius: AppTheme.borderRadiusLarge,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
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
                  ),
                  child: Icon(
                    Icons.edit_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit Resep',
                        style: AppTheme.titleMedium(isDarkMode).copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ubah jenis kopi, ukuran, atau kekuatan resep ini',
                        style: AppTheme.bodySmall(isDarkMode),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDarkMode ? AppTheme.grey400 : AppTheme.grey600,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtons(bool isDarkMode) {
    final buttonGradient = LinearGradient(
      colors: isDarkMode
          ? [AppTheme.darkPrimary, AppTheme.darkSecondary]
          : [AppTheme.lightPrimary, AppTheme.lightSecondary],
    );

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.darkSurface : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDarkMode ? AppTheme.grey800 : AppTheme.grey200,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.1),
            blurRadius: 15,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Previous/Next Buttons
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: AppTheme.borderRadiusMedium,
                    gradient: currentStep > 0
                        ? buttonGradient
                        : LinearGradient(
                            colors: [
                              AppTheme.grey300.withOpacity(0.5),
                              AppTheme.grey400.withOpacity(0.5),
                            ],
                          ),
                    boxShadow: currentStep > 0
                        ? AppTheme.getButtonShadow(isDarkMode)
                        : [],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: currentStep > 0
                        ? () {
                            setState(() {
                              currentStep--;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.arrow_back, size: 20),
                    label: const Text('Sebelumnya'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppTheme.borderRadiusMedium,
                      ),
                      textStyle: AppTheme.buttonTextMedium(isDarkMode),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: AppTheme.borderRadiusMedium,
                    gradient: currentStep < instructions.length - 1
                        ? buttonGradient
                        : LinearGradient(
                            colors: [
                              AppTheme.grey300.withOpacity(0.5),
                              AppTheme.grey400.withOpacity(0.5),
                            ],
                          ),
                    boxShadow: currentStep < instructions.length - 1
                        ? AppTheme.getButtonShadow(isDarkMode)
                        : [],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: currentStep < instructions.length - 1
                        ? () {
                            setState(() {
                              currentStep++;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.arrow_forward, size: 20),
                    label: const Text('Selanjutnya'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppTheme.borderRadiusMedium,
                      ),
                      textStyle: AppTheme.buttonTextMedium(isDarkMode),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Save Recipe Button
          Container(
            decoration: BoxDecoration(
              borderRadius: AppTheme.borderRadiusMedium,
              gradient: isFavorite
                  ? LinearGradient(
                      colors: [Colors.orange.shade600, Colors.orange.shade800],
                    )
                  : LinearGradient(
                      colors: [Colors.green.shade600, Colors.green.shade700],
                    ),
              boxShadow: AppTheme.getButtonShadow(isDarkMode),
            ),
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveRecipe,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: AppTheme.borderRadiusMedium,
                ),
              ),
              child: _isSaving
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(isFavorite ? Icons.check : Icons.save, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          isFavorite ? 'Tersimpan' : 'Simpan Resep',
                          style: AppTheme.buttonTextMedium(isDarkMode),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceItem(
      String title, String value, IconData icon, bool isDarkMode) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.2),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // Method untuk navigasi ke CoffeeSelectionScreen dengan data saat ini
  void _navigateToCoffeeSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoffeeSelectionScreen(),
      ),
    ).then((value) {
      // Jika user membuat perubahan di CoffeeSelectionScreen
      // dan kembali dengan data baru, kita bisa update state di sini
      if (value != null && value is Map<String, dynamic>) {
        setState(() {
          // Update preferences dengan data baru
          widget.preferences['coffeeType'] = value['coffeeType'];
          widget.preferences['cupSize'] = value['cupSize'];
          widget.preferences['strength'] = value['strength'];

          // Regenerate recipe dengan preferensi baru
          _initializeRecipe();
          currentStep = 0; // Reset ke step pertama
          isFavorite = false; // Reset favorite status karena ini resep baru
        });
      }
    });
  }
}
