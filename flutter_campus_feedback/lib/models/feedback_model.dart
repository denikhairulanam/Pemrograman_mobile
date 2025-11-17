class FeedbackModel {
  final String id;
  final String studentName;
  final String studentId;
  final String facilityType;
  final int rating;
  final String comments;
  final DateTime date;

  FeedbackModel({
    required this.id,
    required this.studentName,
    required this.studentId,
    required this.facilityType,
    required this.rating,
    required this.comments,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentName': studentName,
      'studentId': studentId,
      'facilityType': facilityType,
      'rating': rating,
      'comments': comments,
      'date': date.toIso8601String(),
    };
  }

  static FeedbackModel fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'],
      studentName: json['studentName'],
      studentId: json['studentId'],
      facilityType: json['facilityType'],
      rating: json['rating'],
      comments: json['comments'],
      date: DateTime.parse(json['date']),
    );
  }
}
