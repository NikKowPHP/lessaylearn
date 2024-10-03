class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final String languageLevel;
  final List<String> sourceLanguageIds;
  final List<String> targetLanguageIds;
  final List<String> spokenLanguageIds;
  final String location;
  final int age;
  final String? bio;
  final List<String> interests;
  final String? occupation;
  final String? education;
  final List<String> languageIds;
  final List<String> profilePictureIds;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl = '',
    this.languageLevel = '',
    this.sourceLanguageIds = const [],
    this.targetLanguageIds = const [],
    this.spokenLanguageIds = const [],
    this.location = '',
    this.age = 0,
    this.bio,
    this.interests = const [],
    this.occupation,
    this.education,
    this.languageIds = const [],
    this.profilePictureIds = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
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
      profilePictureIds: List<String>.from(json['profilePictureIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
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
      'profilePictureIds': profilePictureIds,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
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
    List<String>? profilePictureIds,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
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
      profilePictureIds: profilePictureIds ?? this.profilePictureIds,
    );
  }

   @override
  String toString() {
    return '''UserModel(
      id: $id,
      name: $name,
      email: $email,
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
      languageIds: $languageIds,
      profilePictureIds: $profilePictureIds
    )''';
  }
}