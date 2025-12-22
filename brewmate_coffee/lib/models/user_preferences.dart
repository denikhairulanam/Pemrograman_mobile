// lib/models/user_preferences.dart (update)
import 'package:cloud_firestore/cloud_firestore.dart';

class UserPreferences {
  String userId;
  String? defaultCoffeeType;
  String? defaultCupSize;
  String? defaultStrength;
  bool? notificationsEnabled;
  String? measurementUnit; // 'metric' or 'imperial'
  List<String>? favoriteCoffeeTypes;
  DateTime? lastBrewed;
  DateTime? updatedAt;
  String? temperatureUnit; // 'celsius' or 'fahrenheit'
  bool? darkModeEnabled;
  String? language;

  UserPreferences({
    required this.userId,
    this.defaultCoffeeType = 'espresso',
    this.defaultCupSize = 'medium',
    this.defaultStrength = 'regular',
    this.notificationsEnabled = true,
    this.measurementUnit = 'metric',
    this.favoriteCoffeeTypes,
    this.lastBrewed,
    this.updatedAt,
    this.temperatureUnit = 'celsius',
    this.darkModeEnabled = false,
    this.language = 'id',
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'defaultCoffeeType': defaultCoffeeType,
      'defaultCupSize': defaultCupSize,
      'defaultStrength': defaultStrength,
      'notificationsEnabled': notificationsEnabled,
      'measurementUnit': measurementUnit,
      'favoriteCoffeeTypes': favoriteCoffeeTypes ?? ['espresso', 'latte'],
      'lastBrewed': lastBrewed?.toIso8601String(),
      'updatedAt': FieldValue.serverTimestamp(),
      'temperatureUnit': temperatureUnit,
      'darkModeEnabled': darkModeEnabled,
      'language': language,
    };
  }

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    DateTime? parseDateTime(dynamic date) {
      if (date == null) return null;
      if (date is Timestamp) {
        return date.toDate();
      } else if (date is String) {
        return DateTime.tryParse(date);
      }
      return null;
    }

    return UserPreferences(
      userId: map['userId'] ?? '',
      defaultCoffeeType: map['defaultCoffeeType'] ?? 'espresso',
      defaultCupSize: map['defaultCupSize'] ?? 'medium',
      defaultStrength: map['defaultStrength'] ?? 'regular',
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      measurementUnit: map['measurementUnit'] ?? 'metric',
      favoriteCoffeeTypes: List<String>.from(
          map['favoriteCoffeeTypes'] ?? ['espresso', 'latte']),
      lastBrewed: parseDateTime(map['lastBrewed']),
      updatedAt: parseDateTime(map['updatedAt']),
      temperatureUnit: map['temperatureUnit'] ?? 'celsius',
      darkModeEnabled: map['darkModeEnabled'] ?? false,
      language: map['language'] ?? 'id',
    );
  }
}
