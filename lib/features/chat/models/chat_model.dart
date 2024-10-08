class ChatModel {
  final String id;
  final String hostUserId;
  final String guestUserId;
  final String lastMessage;
  final DateTime lastMessageTimestamp;
  final String chatTopic;
  final String languageLevel;
  final String sourceLanguageId;
  final String targetLanguageId;
   final bool isAi;

  ChatModel({
    required this.id,
    required this.hostUserId,
    required this.guestUserId,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    required this.chatTopic,
    required this.languageLevel,
    required this.sourceLanguageId,
    required this.targetLanguageId,
      required this.isAi,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] ?? '',
      hostUserId: json['hostUserId'] ?? '',
      guestUserId: json['guestUserId'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTimestamp: json['lastMessageTimestamp'] != null
          ? DateTime.parse(json['lastMessageTimestamp'])
          : DateTime.now(),
      chatTopic: json['chatTopic'] ?? '',
      languageLevel: json['languageLevel'] ?? '',
      sourceLanguageId: json['sourceLanguage'] ?? '',
      targetLanguageId: json['targetLanguage'] ?? '',
        isAi: json['isAi'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hostUserId': hostUserId,
      'guestUserId': guestUserId,
      'lastMessage': lastMessage,
      'lastMessageTimestamp': lastMessageTimestamp.toIso8601String(),
      'chatTopic': chatTopic,
      'languageLevel': languageLevel,
      'sourceLanguage': sourceLanguageId,
      'targetLanguage': targetLanguageId,
      'isAi': isAi,
    };
  }

  ChatModel copyWith({
    String? id,
    String? hostUserId,
    String? guestUserId,
    String? lastMessage,
    DateTime? lastMessageTimestamp,
    String? chatTopic,
    String? languageLevel,
    String? sourceLanguage,
    String? targetLanguage,
    bool? isAi,
  }) {
    return ChatModel(
      id: id ?? this.id,
      hostUserId: hostUserId ?? this.hostUserId,
      guestUserId: guestUserId ?? this.guestUserId,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
      chatTopic: chatTopic ?? this.chatTopic,
      languageLevel: languageLevel ?? this.languageLevel,
      sourceLanguageId: sourceLanguage ?? this.sourceLanguageId,
      targetLanguageId: targetLanguage ?? this.targetLanguageId,
      isAi: isAi ?? this.isAi,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          hostUserId == other.hostUserId &&
          guestUserId == other.guestUserId &&
          lastMessage == other.lastMessage &&
          lastMessageTimestamp == other.lastMessageTimestamp &&
          chatTopic == other.chatTopic &&
          languageLevel == other.languageLevel &&
          sourceLanguageId == other.sourceLanguageId &&
          targetLanguageId == other.targetLanguageId &&
          isAi == other.isAi;

  @override
  int get hashCode =>
      id.hashCode ^
      hostUserId.hashCode ^
      guestUserId.hashCode ^
      lastMessage.hashCode ^
      lastMessageTimestamp.hashCode ^
      chatTopic.hashCode ^
      languageLevel.hashCode ^
      sourceLanguageId.hashCode ^
      targetLanguageId.hashCode ^
      isAi.hashCode
      ;
      
       @override
  String toString() {
    return '''ChatModel(
      id: $id,
      hostUserId: $hostUserId,
      guestUserId: $guestUserId,
      lastMessage: $lastMessage,
      lastMessageTimestamp: $lastMessageTimestamp,
      chatTopic: $chatTopic,
      languageLevel: $languageLevel,
      sourceLanguage: $sourceLanguageId,
      targetLanguage: $targetLanguageId,
      isAi: $isAi
    )''';
  }
}