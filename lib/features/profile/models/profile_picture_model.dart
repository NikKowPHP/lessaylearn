import 'package:uuid/uuid.dart';

class ProfilePictureModel {
  final String id;
  final String userId;
  final String imageUrl;
  final List<String> likeIds;
  final List<String> commentIds;
  final DateTime createdAt;

  ProfilePictureModel({
    String? id,
    required this.userId,
    required this.imageUrl,
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
      imageUrl: json['imageUrl'],
      likeIds: List<String>.from(json['likeIds'] ?? []),
      commentIds: List<String>.from(json['commentIds'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'imageUrl': imageUrl,
      'likeIds': likeIds,
      'commentIds': commentIds,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  ProfilePictureModel copyWith({
    String? id,
    String? userId,
    String? imageUrl,
    List<String>? likeIds,
    List<String>? commentIds,
    DateTime? createdAt,
  }) {
    return ProfilePictureModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imageUrl: imageUrl ?? this.imageUrl,
      likeIds: likeIds ?? this.likeIds,
      commentIds: commentIds ?? this.commentIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}