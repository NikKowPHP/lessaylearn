class ChatModel {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final String avatarUrl;
  final DateTime date;
  final String chatTopic;
  final String languageLevel;
  final String sourceLanguage;
  final String targetLanguage;

  ChatModel({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.avatarUrl,
    required this.date,
    required this.chatTopic,
    required this.languageLevel,
    required this.sourceLanguage,
    required this.targetLanguage,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastMessage': lastMessage,
      'time': time,
      'avatarUrl': avatarUrl,
      'date': date.toIso8601String(),
      'chatTopic': chatTopic,
      'languageLevel': languageLevel,
      'sourceLanguage': sourceLanguage,
      'targetLanguage': targetLanguage,
    };
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      name: json['name'],
      lastMessage: json['lastMessage'],
      time: json['time'],
      avatarUrl: json['avatarUrl'],
      date: DateTime.parse(json['date']),
      chatTopic: json['chatTopic'],
      languageLevel: json['languageLevel'],
      sourceLanguage: json['sourceLanguage'],
      targetLanguage: json['targetLanguage'],
    );
  }
}
