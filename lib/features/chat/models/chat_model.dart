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
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          lastMessage == other.lastMessage &&
          time == other.time &&
          avatarUrl == other.avatarUrl &&
          date == other.date &&
          chatTopic == other.chatTopic &&
          languageLevel == other.languageLevel &&
          sourceLanguage == other.sourceLanguage &&
          targetLanguage == other.targetLanguage;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      lastMessage.hashCode ^
      time.hashCode ^
      avatarUrl.hashCode ^
      date.hashCode ^
      chatTopic.hashCode ^
      languageLevel.hashCode ^
      sourceLanguage.hashCode ^
      targetLanguage.hashCode;

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
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      time: json['time'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      chatTopic: json['chatTopic'] ?? '',
      languageLevel: json['languageLevel'] ?? '',
      sourceLanguage: json['sourceLanguage'] ?? '',
      targetLanguage: json['targetLanguage'] ?? '',
    );
  }
}
