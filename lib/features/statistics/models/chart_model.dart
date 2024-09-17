class ChartModel {
  final String id;
  final String userId;
  final String languageId;
  final double reading;
  final double writing;
  final double speaking;
  final double listening;

  ChartModel({
    required this.id,
    required this.userId,
    required this.languageId,
    required this.reading,
    required this.writing,
    required this.speaking,
    required this.listening,
  });

  factory ChartModel.fromJson(Map<String, dynamic> json) {
    return ChartModel(
      id: json['id'],
      userId: json['userId'],
      languageId: json['languageId'],
      reading: json['reading'].toDouble(),
      writing: json['writing'].toDouble(),
      speaking: json['speaking'].toDouble(),
      listening: json['listening'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'languageId': languageId,
      'reading': reading,
      'writing': writing,
      'speaking': speaking,
      'listening': listening,
    };
  }
}