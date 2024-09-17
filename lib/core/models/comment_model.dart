import 'package:uuid/uuid.dart';

class CommentModel {
  final String id;
  final String userId;
  final String toId;
  final String content;
  final DateTime timestamp;

  CommentModel({
    String? id,
    required this.userId,
    required this.toId,
    required this.content,
    DateTime? timestamp,
  }) : 
    this.id = id ?? Uuid().v4(),
    this.timestamp = timestamp ?? DateTime.now();

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      userId: json['userId'],
      toId: json['toId'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'toId': toId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  CommentModel copyWith({
    String? id,
    String? userId,
    String? toId,
    String? content,
    DateTime? timestamp,
  }) {
    return CommentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      toId: toId ?? this.toId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}