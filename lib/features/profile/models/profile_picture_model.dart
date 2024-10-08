import 'package:uuid/uuid.dart';

class ProfilePictureModel {
  final String id;
  final String userId;
  final String base64Image;
  final List<String> likeIds;
  final List<String> commentIds;
  final DateTime createdAt;

  ProfilePictureModel({
    String? id,
    required this.userId,
    required this.base64Image,
    List<String>? likeIds,
    List<String>? commentIds,
    DateTime? createdAt,
  }) : 
    this.id = id ?? Uuid().v4(),
    this.likeIds = likeIds ?? [],
    this.commentIds = commentIds ?? [],
    this.createdAt = createdAt ?? DateTime.now();

  factory ProfilePictureModel.fromJson(Map<String, dynamic> json) {
    return ProfilePictureModel(
      id: json['id'],
      userId: json['userId'],
      base64Image: json['base64Image'],
      likeIds: List<String>.from(json['likeIds'] ?? []),
      commentIds: List<String>.from(json['commentIds'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'base64Image': base64Image,
      'likeIds': likeIds,
      'commentIds': commentIds,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  ProfilePictureModel copyWith({
    String? id,
    String? userId,
    String? base64Image,
    List<String>? likeIds,
    List<String>? commentIds,
    DateTime? createdAt,
  }) {
    return ProfilePictureModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      base64Image: base64Image ?? this.base64Image,
      likeIds: likeIds ?? this.likeIds,
      commentIds: commentIds ?? this.commentIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}