import 'package:flutter/src/widgets/icon_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class User {
  final String email;
  final String password;
  final UserProfile profile;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  User({
    required this.email,
    required this.password,
    required this.profile,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class UserProfile {
  final int? age;
  final String? fitnessGoals;
  final String? dietaryPreferences;
  int healthPoints;

  UserProfile({
    this.age,
    this.fitnessGoals,
    this.dietaryPreferences,
    this.healthPoints = 0,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}

@JsonSerializable()
class Goal {
  final String userId;
  final DateTime date;
  final int steps;
  final int water;
  final int activeBreaks;
  final int nutritiousMeals;

  Goal({
    required this.userId,
    required this.date,
    this.steps = 0,
    this.water = 0,
    this.activeBreaks = 0,
    this.nutritiousMeals = 0,
  });

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);

  Map<String, dynamic> toJson() => _$GoalToJson(this);
}

@JsonSerializable()
class Badge {
  final String userId;
  final String name;
  final String? description;
  final DateTime earnedDate;
  final int iconCode;

  Badge({
    required this.userId,
    required this.name,
    this.description,
    required this.earnedDate,
    required this.iconCode,
  });

  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);
  Map<String, dynamic> toJson() => _$BadgeToJson(this);

  IconData get icon => IconData(iconCode, fontFamily: 'MaterialIcons');
}
