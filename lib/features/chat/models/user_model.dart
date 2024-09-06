class UserModel {
  final String id;
  final String name;
  final String avatarUrl;
  final String languageLevel;
  final String sourceLanguage;
  final String targetLanguage;
  final String location;
  final int age;

  UserModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.languageLevel,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.location,
    required this.age,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      languageLevel: json['languageLevel'] ?? '',
      sourceLanguage: json['sourceLanguage'] ?? '',
      targetLanguage: json['targetLanguage'] ?? '',
      location: json['location'] ?? '',
      age: json['age'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'languageLevel': languageLevel,
      'sourceLanguage': sourceLanguage,
      'targetLanguage': targetLanguage,
      'location': location,
      'age': age,
    };
  }
}