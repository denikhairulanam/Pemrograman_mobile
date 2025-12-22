import 'package:flutter/material.dart';
import 'package:brewmate_coffee/theme/app_theme.dart';

class CoffeeSelectionScreen extends StatefulWidget {
  const CoffeeSelectionScreen({super.key});

  @override
  _CoffeeSelectionScreenState createState() => _CoffeeSelectionScreenState();
}

class _CoffeeSelectionScreenState extends State<CoffeeSelectionScreen> {
  String _selectedCoffeeType = 'espresso';
  String _selectedCupSize = 'medium';
  String _selectedStrength = 'regular';

  final Map<String, String> coffeeTypes = {
    'espresso': 'Espresso',
    'latte': 'Latte',
    'cappuccino': 'Cappuccino',
    'americano': 'Americano',
    'mocha': 'Mocha',
    'macchiato': 'Macchiato',
  };

  final Map<String, String> cupSizes = {
    'small': 'Kecil',
    'medium': 'Sedang',
    'large': 'Besar',
  };

  final Map<String, String> cupSizeDetails = {
    'small': '180ml',
    'medium': '250ml',
    'large': '350ml',
  };

  final Map<String, String> strengths = {
    'light': 'Ringan',
    'regular': 'Sedang',
    'strong': 'Kuat',
  };

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppTheme.darkBackground : AppTheme.lightPrimary,
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
                boxShadow: isDarkMode
                    ? AppTheme.darkElevatedShadow
                    : AppTheme.lightElevatedShadow,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 12),
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
                          'BUAT RESEP BARU',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Pilih preferensi kopi Anda',
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Coffee Type Selection
                      _buildSectionTitle('Jenis Kopi', isDarkMode),
                      _buildCoffeeTypeGrid(isDarkMode),

                      const SizedBox(height: 30),

                      // Cup Size Selection
                      _buildSectionTitle('Ukuran Cangkir', isDarkMode),
                      _buildCupSizeSelection(isDarkMode),

                      const SizedBox(height: 30),

                      // Strength Selection
                      _buildSectionTitle('Tingkat Kekuatan', isDarkMode),
                      _buildStrengthSelection(isDarkMode),

                      const SizedBox(height: 40),

                      // Selection Summary
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              isDarkMode ? AppTheme.darkSurface : Colors.white,
                          borderRadius: AppTheme.borderRadiusLarge,
                          boxShadow: isDarkMode
                              ? AppTheme.darkCardShadow
                              : AppTheme.lightCardShadow,
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ringkasan',
                                  style:
                                      AppTheme.titleSmall(isDarkMode).copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
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
                                        borderRadius:
                                            AppTheme.borderRadiusMedium,
                                      ),
                                      child: Text(
                                        coffeeTypes[_selectedCoffeeType]!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: isDarkMode
                                            ? AppTheme.grey800
                                            : AppTheme.grey100,
                                        borderRadius:
                                            AppTheme.borderRadiusMedium,
                                      ),
                                      child: Text(
                                        '${cupSizes[_selectedCupSize]!} • ${strengths[_selectedStrength]!}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: isDarkMode
                                              ? AppTheme.grey300
                                              : AppTheme.grey700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              width: 56,
                              height: 56,
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
                                boxShadow: [
                                  BoxShadow(
                                    color: (isDarkMode
                                            ? AppTheme.darkPrimary
                                            : AppTheme.lightPrimary)
                                        .withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                _getCoffeeIcon(_selectedCoffeeType),
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Start Brewing Button
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: AppTheme.borderRadiusMedium,
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
                          boxShadow: AppTheme.getButtonShadow(isDarkMode),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/brewing',
                              arguments: {
                                'coffeeType': _selectedCoffeeType,
                                'cupSize': _selectedCupSize,
                                'strength': _selectedStrength,
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppTheme.borderRadiusMedium,
                            ),
                            minimumSize: const Size(double.infinity, 0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_cafe_rounded,
                                size: 22,
                                color: isDarkMode ? Colors.black : Colors.white,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Mulai Membuat Kopi',
                                style: AppTheme.buttonTextLarge(isDarkMode),
                              ),
                            ],
                          ),
                        ),
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

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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

  Widget _buildCoffeeTypeGrid(bool isDarkMode) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.9,
      children: coffeeTypes.entries.map((entry) {
        final isSelected = _selectedCoffeeType == entry.key;
        final color = _getCoffeeColor(entry.key, isDarkMode);

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCoffeeType = entry.key;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color.withOpacity(0.9),
                        color.withOpacity(0.7),
                      ],
                    )
                  : null,
              color: isSelected
                  ? null
                  : (isDarkMode ? AppTheme.grey800 : AppTheme.grey50),
              borderRadius: AppTheme.borderRadiusLarge,
              boxShadow: isSelected
                  ? AppTheme.getButtonShadow(isDarkMode)
                  : [
                      BoxShadow(
                        color: (isDarkMode ? Colors.black : Colors.grey)
                            .withOpacity(isDarkMode ? 0.3 : 0.1),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ],
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : (isDarkMode ? AppTheme.grey700 : AppTheme.grey300),
                width: isSelected ? 0 : 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedCoffeeType = entry.key;
                  });
                },
                borderRadius: AppTheme.borderRadiusLarge,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? Colors.white.withOpacity(0.2)
                            : (isDarkMode ? AppTheme.grey800 : Colors.white),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        _getCoffeeIcon(entry.key),
                        color: isSelected
                            ? Colors.white
                            : (isDarkMode ? AppTheme.grey400 : color),
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      entry.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : (isDarkMode
                                ? AppTheme.grey300
                                : AppTheme.grey800),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCupSizeSelection(bool isDarkMode) {
    return Row(
      children: cupSizes.entries.map((entry) {
        final isSelected = _selectedCupSize == entry.key;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
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
                borderRadius: AppTheme.borderRadiusMedium,
                border: isSelected
                    ? null
                    : Border.all(
                        color: isDarkMode ? AppTheme.grey700 : AppTheme.grey300,
                        width: 1,
                      ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: (isDarkMode
                                  ? AppTheme.darkPrimary
                                  : AppTheme.lightPrimary)
                              .withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: isSelected
                    ? Colors.transparent
                    : (isDarkMode ? AppTheme.grey800 : Colors.white),
                borderRadius: AppTheme.borderRadiusMedium,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCupSize = entry.key;
                    });
                  },
                  borderRadius: AppTheme.borderRadiusMedium,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                    child: Column(
                      children: [
                        Text(
                          entry.value,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? Colors.white
                                : (isDarkMode
                                    ? AppTheme.grey300
                                    : AppTheme.grey800),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cupSizeDetails[entry.key]!,
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected
                                ? Colors.white.withOpacity(0.9)
                                : (isDarkMode
                                    ? AppTheme.grey500
                                    : AppTheme.grey600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStrengthSelection(bool isDarkMode) {
    return Row(
      children: strengths.entries.map((entry) {
        final isSelected = _selectedStrength == entry.key;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
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
                borderRadius: AppTheme.borderRadiusMedium,
                border: isSelected
                    ? null
                    : Border.all(
                        color: isDarkMode ? AppTheme.grey700 : AppTheme.grey300,
                        width: 1,
                      ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: (isDarkMode
                                  ? AppTheme.darkPrimary
                                  : AppTheme.lightPrimary)
                              .withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: isSelected
                    ? Colors.transparent
                    : (isDarkMode ? AppTheme.grey800 : Colors.white),
                borderRadius: AppTheme.borderRadiusMedium,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedStrength = entry.key;
                    });
                  },
                  borderRadius: AppTheme.borderRadiusMedium,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Center(
                      child: Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : (isDarkMode
                                  ? AppTheme.grey300
                                  : AppTheme.grey800),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getCoffeeColor(String type, bool isDarkMode) {
    final colorMap = isDarkMode
        ? {
            'espresso': AppTheme.darkPrimary,
            'latte': AppTheme.darkSecondary,
            'cappuccino': const Color(0xFF7C4DFF),
            'americano': const Color(0xFF6200EA),
            'mocha': const Color(0xFF311B92),
            'macchiato': const Color(0xFF651FFF),
          }
        : {
            'espresso': AppTheme.lightPrimary,
            'latte': AppTheme.lightSecondary,
            'cappuccino': const Color(0xFF6A11CB),
            'americano': const Color(0xFF9D4EDD),
            'mocha': const Color(0xFF5A189A),
            'macchiato': const Color(0xFF7B2CBF),
          };
    return colorMap[type] ??
        (isDarkMode ? AppTheme.darkPrimary : AppTheme.lightPrimary);
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
