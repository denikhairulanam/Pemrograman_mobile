import 'dart:convert';

class User {
  String name;
  String email;
  String phone;
  String bio;
  DateTime birthDate;
  String gender;
  String password;
  String? profileImagePath; 

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.bio,
    required this.birthDate,
    required this.gender,
    required this.password,
    this.profileImagePath,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      bio: json['bio'] ?? '',
      birthDate:
          DateTime.parse(json['birthDate'] ?? DateTime.now().toIso8601String()),
      gender: json['gender'] ?? 'Laki-laki',
      password: json['password'] ?? '',
      profileImagePath: json['profileImagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'bio': bio,
      'birthDate': birthDate.toIso8601String(),
      'gender': gender,
      'password': password,
      'profileImagePath': profileImagePath,
    };
  }

  User copyWith({
    String? name,
    String? email,
    String? phone,
    String? bio,
    DateTime? birthDate,
    String? gender,
    String? password,
    String? profileImagePath,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      password: password ?? this.password,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }
}
