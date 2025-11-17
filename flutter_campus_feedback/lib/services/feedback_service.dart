import 'package:flutter/material.dart';
import '../models/feedback_model.dart';

class FeedbackService with ChangeNotifier {
  final List<FeedbackModel> _feedbacks = [
    
  ];

  List<FeedbackModel> get feedbacks => _feedbacks;

  void addFeedback(FeedbackModel feedback) {
    _feedbacks.insert(0, feedback); // Tambah di awal list
    notifyListeners();
  }

  void removeFeedback(String id) {
    _feedbacks.removeWhere((feedback) => feedback.id == id);
    notifyListeners();
  }

  // Statistik
  double get averageRating {
    if (_feedbacks.isEmpty) return 0;
    final total = _feedbacks.map((f) => f.rating).reduce((a, b) => a + b);
    return total / _feedbacks.length;
  }

  Map<String, double> getFacilityStats() {
    final Map<String, List<int>> facilityRatings = {};

    for (var feedback in _feedbacks) {
      if (!facilityRatings.containsKey(feedback.facilityType)) {
        facilityRatings[feedback.facilityType] = [];
      }
      facilityRatings[feedback.facilityType]!.add(feedback.rating);
    }

    final Map<String, double> averageRatings = {};
    facilityRatings.forEach((facility, ratings) {
      final average = ratings.reduce((a, b) => a + b) / ratings.length;
      averageRatings[facility] = double.parse(average.toStringAsFixed(1));
    });

    return averageRatings;
  }

  Map<int, int> getRatingDistribution() {
    final distribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (var feedback in _feedbacks) {
      distribution[feedback.rating] = distribution[feedback.rating]! + 1;
    }
    return distribution;
  }
}
