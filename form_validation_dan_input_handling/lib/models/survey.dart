import 'dart:convert';

class Survey {
  String name;
  int age;
  String occupation;
  List<String> interests;
  int satisfaction;
  String feedback;

  Survey({
    required this.name,
    required this.age,
    required this.occupation,
    required this.interests,
    required this.satisfaction,
    required this.feedback,
  });

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      occupation: json['occupation'] ?? '',
      interests: List<String>.from(json['interests'] ?? []),
      satisfaction: json['satisfaction'] ?? 0,
      feedback: json['feedback'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'occupation': occupation,
      'interests': interests,
      'satisfaction': satisfaction,
      'feedback': feedback,
    };
  }
}
