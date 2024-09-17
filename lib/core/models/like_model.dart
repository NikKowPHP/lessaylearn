import 'package:uuid/uuid.dart';

class LikeModel {
  final String id;
  final String userId;
  final String toId;
  final DateTime timestamp;

  LikeModel({
    String? id,
    required this.userId,
    required this.toId,
    DateTime? timestamp,
  }) : 
    this.id = id ?? Uuid().v4(),
    this.timestamp = timestamp ?? DateTime.now();

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    return LikeModel(
      id: json['id'],
      userId: json['userId'],
      toId: json['toId'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'toId': toId,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  LikeModel copyWith({
    String? id,
    String? userId,
    String? toId,
    DateTime? timestamp,
  }) {
    return LikeModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      toId: toId ?? this.toId,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}