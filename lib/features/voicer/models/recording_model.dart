import 'package:uuid/uuid.dart';

class RecordingModel {
  final String id;
  final String userId;
  final String languageId;
  final String audioPath;
  final DateTime createdAt;
  final int durationInSeconds;
  final String? transcription;

  RecordingModel({
    String? id,
    required this.userId,
    required this.languageId,
    required this.audioPath,
    DateTime? createdAt,
    required this.durationInSeconds,
    this.transcription,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  factory RecordingModel.fromJson(Map<String, dynamic> json) {
    return RecordingModel(
      id: json['id'],
      userId: json['userId'],
      languageId: json['languageId'],
      audioPath: json['audioPath'],
      createdAt: DateTime.parse(json['createdAt']),
      durationInSeconds: json['durationInSeconds'],
      transcription: json['transcription'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'languageId': languageId,
      'audioPath': audioPath,
      'createdAt': createdAt.toIso8601String(),
      'durationInSeconds': durationInSeconds,
      'transcription': transcription,
    };
  }

  RecordingModel copyWith({
    String? id,
    String? userId,
    String? languageId,
    String? audioPath,
    DateTime? createdAt,
    int? durationInSeconds,
    String? transcription,
  }) {
    return RecordingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      languageId: languageId ?? this.languageId,
      audioPath: audioPath ?? this.audioPath,
      createdAt: createdAt ?? this.createdAt,
      durationInSeconds: durationInSeconds ?? this.durationInSeconds,
      transcription: transcription ?? this.transcription,
    );
  }
}