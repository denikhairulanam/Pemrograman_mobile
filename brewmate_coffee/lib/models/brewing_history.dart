// lib/models/brewing_history.dart (update)
import 'package:cloud_firestore/cloud_firestore.dart';

class BrewingHistory {
  String id;
  String userId;
  String coffeeType;
  Map<String, double> ingredients;
  DateTime brewedAt;
  int brewingTime; 
  double? rating;
  String? notes;
  Map<String, dynamic>? parameters;
  String? recipeId; 

  BrewingHistory({
    required this.id,
    required this.userId,
    required this.coffeeType,
    required this.ingredients,
    required this.brewedAt,
    required this.brewingTime,
    this.rating,
    this.notes,
    this.parameters,
    this.recipeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'coffeeType': coffeeType,
      'ingredients': ingredients,
      'brewedAt': brewedAt.toIso8601String(),
      'brewingTime': brewingTime,
      'rating': rating,
      'notes': notes,
      'parameters': parameters ?? {},
      'recipeId': recipeId,
    };
  }

  factory BrewingHistory.fromMap(String id, Map<String, dynamic> map) {
    DateTime parseBrewedAt(dynamic brewedAt) {
      if (brewedAt is Timestamp) {
        return brewedAt.toDate();
      } else if (brewedAt is String) {
        return DateTime.parse(brewedAt);
      } else {
        return DateTime.now();
      }
    }

    return BrewingHistory(
      id: id,
      userId: map['userId'] ?? '',
      coffeeType: map['coffeeType'] ?? 'espresso',
      ingredients: Map<String, double>.from(map['ingredients'] ?? {}),
      brewedAt: parseBrewedAt(map['brewedAt']),
      brewingTime: map['brewingTime'] ?? 0,
      rating: (map['rating'] as num?)?.toDouble(),
      notes: map['notes'],
      parameters: Map<String, dynamic>.from(map['parameters'] ?? {}),
      recipeId: map['recipeId'],
    );
  }

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (brewedAt.year == today.year &&
        brewedAt.month == today.month &&
        brewedAt.day == today.day) {
      return 'Hari ini ${_formatTime(brewedAt)}';
    } else if (brewedAt.year == yesterday.year &&
        brewedAt.month == yesterday.month &&
        brewedAt.day == yesterday.day) {
      return 'Kemarin ${_formatTime(brewedAt)}';
    } else {
      return '${brewedAt.day}/${brewedAt.month}/${brewedAt.year} ${_formatTime(brewedAt)}';
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
