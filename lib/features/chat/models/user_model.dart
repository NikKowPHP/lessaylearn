class UserModel {
  final String id;
  final String name;
  final String avatarUrl;
  final String languageLevel;
  final List<String> sourceLanguages;
  final List<String> targetLanguages;
  final List<String> spokenLanguages;
  final String location;
  final int age;
  final String? bio;
  final List<String> interests;
  final String? occupation;
  final String? education;

  UserModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.languageLevel,
    required this.sourceLanguages,
    required this.targetLanguages,
    required this.spokenLanguages,
    required this.location,
    required this.age,
    this.bio,
    this.interests = const [],
    this.occupation,
    this.education,
  });

  @override
  String toString() {
    return '''UserModel(
      id: $id,
      name: $name,
      avatarUrl: $avatarUrl,
      languageLevel: $languageLevel,
      sourceLanguages: $sourceLanguages,
      targetLanguages: $targetLanguages,
      spokenLanguages: $spokenLanguages,
      location: $location,
      age: $age,
      bio: $bio,
      interests: $interests,
      occupation: $occupation,
      education: $education
    )''';
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      languageLevel: json['languageLevel'] ?? '',
      sourceLanguages: List<String>.from(json['sourceLanguages'] ?? []),
      targetLanguages: List<String>.from(json['targetLanguages'] ?? []),
      spokenLanguages: List<String>.from(json['spokenLanguages'] ?? []),
      location: json['location'] ?? '',
      age: json['age'] ?? 0,
      bio: json['bio'],
      interests: List<String>.from(json['interests'] ?? []),
      occupation: json['occupation'],
      education: json['education'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'languageLevel': languageLevel,
      'sourceLanguages': sourceLanguages,
      'targetLanguages': targetLanguages,
      'spokenLanguages': spokenLanguages,
      'location': location,
      'age': age,
      'bio': bio,
      'interests': interests,
      'occupation': occupation,
      'education': education,
    };
  }
}