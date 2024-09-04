class ChatModel {
  final String name;
  final String lastMessage;
  final String time;
  final String avatarUrl;
  final DateTime date;

  ChatModel({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.avatarUrl,
    required this.date,
  });
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastMessage': lastMessage,
      'time': time,
      'avatarUrl': avatarUrl,
      'date': date.toIso8601String(),
    };
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      name: json['name'],
      lastMessage: json['lastMessage'],
      time: json['time'],
      avatarUrl: json['avatarUrl'],
      date: DateTime.parse(json['date']),
    );
  }
}
