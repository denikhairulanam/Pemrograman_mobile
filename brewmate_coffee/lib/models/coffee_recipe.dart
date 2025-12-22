// lib/models/coffee_recipe.dart (FIXED)
import 'package:cloud_firestore/cloud_firestore.dart';

class CoffeeRecipe {
  String id;
  String userId;
  String coffeeType;
  String cupSize;
  String strength;
  double coffeeAmount;
  double waterAmount;
  double? milkAmount;
  double? chocolateAmount; // New field
  List<String> instructions;
  DateTime createdAt;
  DateTime? updatedAt;
  bool isFavorite;
  Map<String, double> ingredients;
  String? customName; // New field for display name
  String? customDescription; // New field for description
  String? weatherContext; // New field for weather when saved

  CoffeeRecipe({
    required this.id,
    required this.userId,
    required this.coffeeType,
    required this.cupSize,
    required this.strength,
    required this.coffeeAmount,
    required this.waterAmount,
    this.milkAmount,
    this.chocolateAmount,
    required this.instructions,
    required this.createdAt,
    this.updatedAt,
    this.isFavorite = false,
    required this.ingredients,
    this.customName,
    this.customDescription,
    this.weatherContext,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'coffeeType': coffeeType,
      'cupSize': cupSize,
      'strength': strength,
      'coffeeAmount': coffeeAmount,
      'waterAmount': waterAmount,
      'milkAmount': milkAmount,
      'chocolateAmount': chocolateAmount,
      'instructions': instructions,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt':
          updatedAt?.toUtc().toIso8601String() ?? FieldValue.serverTimestamp(),
      'isFavorite': isFavorite,
      'ingredients': ingredients,
      'customName': customName,
      'customDescription': customDescription,
      'weatherContext': weatherContext,
    };
  }

  factory CoffeeRecipe.fromMap(String id, Map<String, dynamic> map) {
    // Helper to parse various timestamp formats (Timestamp, String, int, DateTime)
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String) {
        try {
          return DateTime.parse(value).toLocal();
        } catch (e) {
          print('Error parsing date from string: $e');
          return null;
        }
      }
      if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
      if (value is double) return DateTime.fromMillisecondsSinceEpoch(value.toInt());
      return null;
    }

    final created = parseDate(map['createdAt']) ?? DateTime.now();
    final updated = parseDate(map['updatedAt']);

    return CoffeeRecipe(
      id: id,
      userId: map['userId'] ?? '',
      coffeeType: map['coffeeType'] ?? 'espresso',
      cupSize: map['cupSize'] ?? 'medium',
      strength: map['strength'] ?? 'regular',
      coffeeAmount: (map['coffeeAmount'] as num?)?.toDouble() ?? 0.0,
      waterAmount: (map['waterAmount'] as num?)?.toDouble() ?? 0.0,
      milkAmount: (map['milkAmount'] as num?)?.toDouble(),
      chocolateAmount: (map['chocolateAmount'] as num?)?.toDouble(),
      instructions: List<String>.from(map['instructions'] ?? []),
      createdAt: created,
      updatedAt: updated,
      isFavorite: map['isFavorite'] ?? false,
      ingredients: Map<String, double>.from(map['ingredients'] ?? {}),
      customName: map['customName'],
      customDescription: map['customDescription'],
      weatherContext: map['weatherContext'],
    );
  }

  // Get display name (either custom name or coffee type)
  String get displayName {
    return customName ?? coffeeType.toUpperCase();
  }
}
