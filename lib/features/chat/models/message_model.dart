class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final bool isRead;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.isRead = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      chatId: json['chatId'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  MessageModel copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? receiverId,
    String? content,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return MessageModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          chatId == other.chatId &&
          senderId == other.senderId &&
          receiverId == other.receiverId &&
          content == other.content &&
          timestamp == other.timestamp &&
          isRead == other.isRead;

  @override
  int get hashCode =>
      id.hashCode ^
      chatId.hashCode ^
      senderId.hashCode ^
      receiverId.hashCode ^
      content.hashCode ^
      timestamp.hashCode ^
      isRead.hashCode;
      
      @override
String toString() {
  return '''MessageModel(
    id: $id,
    chatId: $chatId,
    senderId: $senderId,
    receiverId: $receiverId,
    content: $content,
    timestamp: $timestamp,
    isRead: $isRead
  )''';
}
}