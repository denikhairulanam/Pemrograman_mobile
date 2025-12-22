import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherService {
  static const String _apiKey =
      '146eeb9448194f7782963406251612'; // Weatherapi key
  static const String _baseUrl = 'https://api.weatherapi.com/v1';

  // Fallback city jika location tidak tersedia
  static const String _fallbackCity = 'Jakarta';

  // Get current weather with better error handling
  Future<WeatherData> getCurrentWeatherByLocation() async {
    try {
      print('🌤️ Attempting to get weather by location...');

      // Try to get current location
      Position? position;
      try {
        // Cek permission dulu
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          print('⚠️ Location services disabled, using fallback');
          return await getCurrentWeatherByCity(_fallbackCity);
        }

        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            print('⚠️ Location permission denied, using fallback');
            return await getCurrentWeatherByCity(_fallbackCity);
          }
        }

        if (permission == LocationPermission.deniedForever) {
          print('⚠️ Location permission permanently denied, using fallback');
          return await getCurrentWeatherByCity(_fallbackCity);
        }

        // Get position dengan timeout
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ).timeout(Duration(seconds: 10));

        print(
            '📍 Location obtained: ${position.latitude}, ${position.longitude}');
      } catch (e) {
        print('⚠️ Location error: $e, using fallback');
        return await getCurrentWeatherByCity(_fallbackCity);
      }

      if (position == null) {
        print('⚠️ No location, using fallback');
        return await getCurrentWeatherByCity(_fallbackCity);
      }

      // Fetch weather data dengan timeout
      final response = await http
          .get(
            Uri.parse(
              '$_baseUrl/current.json?key=$_apiKey&q=${position.latitude},${position.longitude}&aqi=no&lang=id',
            ),
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Weather data obtained');
        return WeatherData.fromJson(data);
      } else {
        print('⚠️ Weather API failed, trying fallback city');
        return await getCurrentWeatherByCity(_fallbackCity);
      }
    } catch (e) {
      print('❌ Weather service error: $e, using mock data');
      // Return mock data as fallback
      return WeatherData(
        location: _fallbackCity,
        temperature: 28.0,
        condition: 'Cerah',
        conditionCode: 1000,
        isDay: true,
        humidity: 75.0,
        windSpeed: 10.0,
        lastUpdated: DateTime.now().toIso8601String(),
        pressure: 1013,
      );
    }
  }

  // Get current weather by city name
  Future<WeatherData> getCurrentWeatherByCity(String city) async {
    try {
      print('🌤️ Getting weather for city: $city');

      final response = await http
          .get(
            Uri.parse(
              '$_baseUrl/current.json?key=$_apiKey&q=$city&aqi=no&lang=id',
            ),
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherData.fromJson(data);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print('❌ City weather error: $e');
      // Return mock data
      return WeatherData(
        location: city,
        temperature: 27.0,
        condition: 'Berawan',
        conditionCode: 1006,
        isDay: true,
        humidity: 80.0,
        windSpeed: 8.0,
        lastUpdated: DateTime.now().toIso8601String(),
        pressure: 1012,
      );
    }
  }
}

class WeatherData {
  final String location;
  final double temperature;
  final String condition;
  final int conditionCode;
  final bool isDay;
  final double humidity;
  final double windSpeed;
  final String lastUpdated;
  final double pressure;

  WeatherData({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.conditionCode,
    required this.isDay,
    required this.humidity,
    required this.windSpeed,
    required this.lastUpdated,
    required this.pressure,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    try {
      return WeatherData(
        location: json['location']['name'] ?? 'Unknown',
        temperature: (json['current']['temp_c'] ?? 25.0).toDouble(),
        condition: json['current']['condition']['text'] ?? 'Unknown',
        conditionCode: (json['current']['condition']['code'] ?? 1000).toInt(),
        isDay: (json['current']['is_day'] ?? 1) == 1,
        humidity: (json['current']['humidity'] ?? 70.0).toDouble(),
        windSpeed: (json['current']['wind_kph'] ?? 10.0).toDouble(),
        lastUpdated:
            json['current']['last_updated'] ?? DateTime.now().toIso8601String(),
        pressure: (json['current']['pressure_mb'] ?? 1013.0).toDouble(),
      );
    } catch (e) {
      print('❌ Error parsing weather data: $e');
      return WeatherData(
        location: 'Jakarta',
        temperature: 28.0,
        condition: 'Cerah',
        conditionCode: 1000,
        isDay: true,
        humidity: 75.0,
        windSpeed: 10.0,
        lastUpdated: DateTime.now().toIso8601String(),
        pressure: 1013.0,
      );
    }
  }

  WeatherCategory get category {
    if (conditionCode >= 1000 && conditionCode <= 1030) {
      if (temperature > 30) return WeatherCategory.hot;
      if (temperature < 20) return WeatherCategory.cold;
      return WeatherCategory.pleasant;
    } else if (conditionCode >= 1063 && conditionCode <= 1201 ||
        conditionCode >= 1240 && conditionCode <= 1282) {
      return WeatherCategory.rainy;
    } else if (conditionCode >= 1006 && conditionCode <= 1009) {
      return WeatherCategory.cloudy;
    } else if (conditionCode >= 1087 && conditionCode <= 1117) {
      return WeatherCategory.windy;
    } else if (temperature > 28) {
      return WeatherCategory.hot;
    } else if (temperature < 22) {
      return WeatherCategory.cold;
    } else {
      return WeatherCategory.pleasant;
    }
  }
}

enum WeatherCategory {
  hot,
  cold,
  rainy,
  cloudy,
  windy,
  pleasant,
}
