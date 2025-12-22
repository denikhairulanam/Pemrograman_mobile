import 'package:flutter/material.dart';
import 'package:brewmate_coffee/theme/app_theme.dart';
import 'package:brewmate_coffee/services/weather_service.dart';
import 'package:brewmate_coffee/services/coffee_recommendation_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WeatherData? _weatherData;
  bool _isLoading = false;
  List<RecommendedCoffee> _recommendations = [];
  String _weatherMessage = 'Memuat data cuaca...';

  @override
  void initState() {
    super.initState();
    // Load weather setelah build pertama
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWeatherAndRecommendations();
    });
  }

  Future<void> _loadWeatherAndRecommendations() async {
    setState(() {
      _isLoading = true;
      _weatherMessage = 'Mendapatkan lokasi...';
    });

    try {
      print('🌤️ Loading weather data...');
      final weatherService = WeatherService();
      _weatherData = await weatherService.getCurrentWeatherByLocation();

      print(
          '✅ Weather loaded: ${_weatherData?.location}, ${_weatherData?.temperature}°C');

      final category = _weatherData!.category;
      _recommendations =
          CoffeeRecommendationService.getRecommendations(category);

      // Set weather message
      switch (category) {
        case WeatherCategory.hot:
          _weatherMessage = '☀️ Cuaca Panas - Cocok untuk minuman dingin!';
          break;
        case WeatherCategory.cold:
          _weatherMessage = '❄️ Cuaca Dingin - Nikmati kopi hangat!';
          break;
        case WeatherCategory.rainy:
          _weatherMessage =
              '🌧️ Sedang Hujan - Minuman hangat yang menenangkan';
          break;
        case WeatherCategory.cloudy:
          _weatherMessage = '☁️ Mendung - Kopi seimbang untuk hari ini';
          break;
        case WeatherCategory.windy:
          _weatherMessage = '🌬️ Berangin - Kopi beraroma kuat yang cocok';
          break;
        case WeatherCategory.pleasant:
          _weatherMessage = '😊 Cuaca Nyaman - Pilihan kopi bebas!';
          break;
      }

      print('✅ Recommendations: ${_recommendations.length} items');
    } catch (e) {
      print('❌ Error loading weather: $e');
      _weatherMessage = 'Menggunakan rekomendasi default';
      _recommendations = CoffeeRecommendationService.getRecommendations(
          WeatherCategory.pleasant);

      // Set mock weather data
      _weatherData = WeatherData(
        location: 'Jakarta',
        temperature: 28.0,
        condition: 'Cerah',
        conditionCode: 1000,
        isDay: true,
        humidity: 75.0,
        windSpeed: 10.0,
        lastUpdated: DateTime.now().toIso8601String(),
        pressure: 1013,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToBrewing(RecommendedCoffee coffee) {
    Navigator.pushNamed(
      context,
      '/brewing',
      arguments: {
        'coffeeType': coffee.coffeeType,
        'cupSize': 'medium',
        'strength': 'regular',
        'customName': coffee.name,
        'customDescription': coffee.description,
        'weatherContext': _weatherMessage,
      },
    );
  }

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
            // App Bar with solid color
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
                      const Text(
                        'Halo, BrewMate!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _weatherMessage,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w300,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                      onPressed: _loadWeatherAndRecommendations,
                      padding: EdgeInsets.zero,
                      tooltip: 'Refresh cuaca',
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Weather card
                      if (_weatherData != null) _buildWeatherCard(isDarkMode),

                      const SizedBox(height: 24),

                      // Recommendations title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rekomendasi Hari Ini',
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
                              '${_recommendations.length} items',
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

                      // Loading or recommendations
                      if (_isLoading)
                        _buildLoadingState(isDarkMode)
                      else if (_recommendations.isEmpty)
                        _buildEmptyState(isDarkMode)
                      else
                        // Coffee recommendations grid
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: _recommendations.length,
                          itemBuilder: (context, index) {
                            final coffee = _recommendations[index];
                            final color = _getCoffeeColor(index, isDarkMode);

                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: AppTheme.borderRadiusLarge,
                                color: color.withOpacity(0.8),
                                boxShadow: AppTheme.getButtonShadow(isDarkMode),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _navigateToBrewing(coffee),
                                  borderRadius: AppTheme.borderRadiusLarge,
                                  child: Padding(
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
                                            _getCoffeeIcon(coffee.coffeeType),
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
                                              coffee.name,
                                              style: AppTheme.titleMedium(
                                                      isDarkMode)
                                                  .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              coffee.description,
                                              style:
                                                  AppTheme.bodySmall(isDarkMode)
                                                      .copyWith(
                                                color: Colors.white
                                                    .withOpacity(0.9),
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
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

  Widget _buildLoadingState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isDarkMode ? AppTheme.darkPrimary : AppTheme.lightPrimary,
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Mencocokkan kopi dengan cuaca...',
            style: AppTheme.bodyMedium(isDarkMode),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
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
              Icons.cloud_off_rounded,
              size: 50,
              color: isDarkMode ? AppTheme.grey500 : AppTheme.grey400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada rekomendasi',
            style: AppTheme.titleMedium(isDarkMode),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _loadWeatherAndRecommendations,
            child: const Text('Coba lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.grey800 : AppTheme.lightPrimary,
        borderRadius: AppTheme.borderRadiusLarge,
        boxShadow: AppTheme.getButtonShadow(isDarkMode),
      ),
      child: Column(
        children: [
          // Location and temperature
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: Icon(
                      _getWeatherIcon(_weatherData!.condition),
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _weatherData!.location,
                        style: AppTheme.titleSmall(isDarkMode).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Diperbarui: ${_formatLastUpdated(_weatherData!.lastUpdated)}',
                        style: AppTheme.caption(isDarkMode).copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_weatherData!.temperature}°C',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _weatherData!.condition,
                    style: AppTheme.bodySmall(isDarkMode).copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Divider
          Divider(
            color: Colors.white.withOpacity(0.3),
            height: 1,
          ),

          const SizedBox(height: 12),

          // Weather details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildWeatherDetail(
                'Kelembaban',
                '${_weatherData!.humidity}%',
                Icons.water_drop_rounded,
                isDarkMode,
              ),
              _buildWeatherDetail(
                'Angin',
                '${_weatherData!.windSpeed} km/h',
                Icons.air_rounded,
                isDarkMode,
              ),
              _buildWeatherDetail(
                'Tekanan',
                '${_weatherData!.pressure} hPa',
                Icons.compress_rounded,
                isDarkMode,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(
      String label, String value, IconData icon, bool isDarkMode) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.2),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  IconData _getWeatherIcon(String condition) {
    final lowerCondition = condition.toLowerCase();
    if (lowerCondition.contains('cerah') || lowerCondition.contains('clear')) {
      return Icons.wb_sunny_rounded;
    } else if (lowerCondition.contains('hujan') ||
        lowerCondition.contains('rain')) {
      return Icons.cloudy_snowing;
    } else if (lowerCondition.contains('mendung') ||
        lowerCondition.contains('cloud')) {
      return Icons.cloud_rounded;
    } else if (lowerCondition.contains('berangin') ||
        lowerCondition.contains('wind')) {
      return Icons.air_rounded;
    } else {
      return Icons.cloud_rounded;
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
        AppTheme.darkAccent,
        AppTheme.darkSurface,
        AppTheme.grey800,
        AppTheme.grey700,
      ];
      return darkColors[index % darkColors.length];
    } else {
      final lightColors = [
        AppTheme.lightPrimary,
        AppTheme.lightSecondary,
        AppTheme.lightAccent,
        AppTheme.lightSurface,
        AppTheme.grey200,
        AppTheme.grey300,
      ];
      return lightColors[index % lightColors.length];
    }
  }

  String _formatLastUpdated(String lastUpdated) {
    try {
      final parts = lastUpdated.split(' ');
      if (parts.length >= 2) {
        return parts[1];
      }
      return lastUpdated;
    } catch (e) {
      return lastUpdated;
    }
  }
}
