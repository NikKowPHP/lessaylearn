class UserModel {
  final String id;
  final String name;
  final String avatarUrl;
  final String languageLevel;
 final List<String> sourceLanguageIds; // Changed from sourceLanguages
  final List<String> targetLanguageIds; // Changed from targetLanguages
  final List<String> spokenLanguageIds;
  final String location;
  final int age;
  final String? bio;
  final List<String> interests;
  final String? occupation;
  final String? education;
  final List<String> languageIds;

  UserModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.languageLevel,
     required this.sourceLanguageIds,
    required this.targetLanguageIds,
    required this.spokenLanguageIds,
    required this.location,
    required this.age,
    this.bio,
    this.interests = const [],
    this.occupation,
    this.education,
    this.languageIds = const [],
  });

  @override
  String toString() {
    return '''UserModel(
      id: $id,
      name: $name,
      avatarUrl: $avatarUrl,
      languageLevel: $languageLevel,
       sourceLanguageIds: $sourceLanguageIds,
      targetLanguageIds: $targetLanguageIds,
      spokenLanguageIds: $spokenLanguageIds,
      location: $location,
      age: $age,
      bio: $bio,
      interests: $interests,
      occupation: $occupation,
      education: $education,
      languageIds: $languageIds
    )''';
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      languageLevel: json['languageLevel'] ?? '',
      sourceLanguageIds: List<String>.from(json['sourceLanguageIds'] ?? []),
      targetLanguageIds: List<String>.from(json['targetLanguageIds'] ?? []),
      spokenLanguageIds: List<String>.from(json['spokenLanguageIds'] ?? []),
      location: json['location'] ?? '',
      age: json['age'] ?? 0,
      bio: json['bio'],
      interests: List<String>.from(json['interests'] ?? []),
      occupation: json['occupation'],
      education: json['education'],
       languageIds: List<String>.from(json['languageIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'languageLevel': languageLevel,
     'sourceLanguageIds': sourceLanguageIds,
      'targetLanguageIds': targetLanguageIds,
      'spokenLanguageIds': spokenLanguageIds,
      'location': location,
      'age': age,
      'bio': bio,
      'interests': interests,
      'occupation': occupation,
      'education': education,
        'languageIds': languageIds,
    };
  }
   UserModel copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    String? languageLevel,
    List<String>? sourceLanguageIds,
    List<String>? targetLanguageIds,
    List<String>? spokenLanguageIds,
    String? location,
    int? age,
    String? bio,
    List<String>? interests,
    String? occupation,
    String? education,
    List<String>? languageIds,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      languageLevel: languageLevel ?? this.languageLevel,
     sourceLanguageIds: sourceLanguageIds ?? this.sourceLanguageIds,
      targetLanguageIds: targetLanguageIds ?? this.targetLanguageIds,
      spokenLanguageIds: spokenLanguageIds ?? this.spokenLanguageIds,
      location: location ?? this.location,
      age: age ?? this.age,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      occupation: occupation ?? this.occupation,
      education: education ?? this.education,
      languageIds: languageIds ?? this.languageIds,
    );
  }
}