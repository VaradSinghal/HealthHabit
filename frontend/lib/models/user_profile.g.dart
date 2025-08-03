// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  email: json['email'] as String,
  password: json['password'] as String,
  profile: UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'email': instance.email,
  'password': instance.password,
  'profile': instance.profile,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  age: (json['age'] as num?)?.toInt(),
  fitnessGoals: json['fitnessGoals'] as String?,
  dietaryPreferences: json['dietaryPreferences'] as String?,
  healthPoints: (json['healthPoints'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'age': instance.age,
      'fitnessGoals': instance.fitnessGoals,
      'dietaryPreferences': instance.dietaryPreferences,
      'healthPoints': instance.healthPoints,
    };

Goal _$GoalFromJson(Map<String, dynamic> json) => Goal(
  userId: json['userId'] as String,
  date: DateTime.parse(json['date'] as String),
  steps: (json['steps'] as num?)?.toInt() ?? 0,
  water: (json['water'] as num?)?.toInt() ?? 0,
  activeBreaks: (json['activeBreaks'] as num?)?.toInt() ?? 0,
  nutritiousMeals: (json['nutritiousMeals'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$GoalToJson(Goal instance) => <String, dynamic>{
  'userId': instance.userId,
  'date': instance.date.toIso8601String(),
  'steps': instance.steps,
  'water': instance.water,
  'activeBreaks': instance.activeBreaks,
  'nutritiousMeals': instance.nutritiousMeals,
};

Badge _$BadgeFromJson(Map<String, dynamic> json) => Badge(
  userId: json['userId'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  earnedDate: DateTime.parse(json['earnedDate'] as String),
);

Map<String, dynamic> _$BadgeToJson(Badge instance) => <String, dynamic>{
  'userId': instance.userId,
  'name': instance.name,
  'description': instance.description,
  'earnedDate': instance.earnedDate.toIso8601String(),
};
