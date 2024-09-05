import 'dart:math';

import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/services/i_chat_service.dart';
import 'package:lessay_learn/services/local_storage_service.dart';

class ChatService implements IChatService {
  final LocalStorageService localStorageService;

  ChatService(this.localStorageService);

  @override
  Future<List<ChatModel>> getChats() async {
    final savedChats = await localStorageService.getChats();
    // Ensure that the service returns an empty list or mock data when needed
    return savedChats.isNotEmpty ? savedChats : _getMockChats();
  }

  @override
  Future<void> saveChats(List<ChatModel> chats) async {
    await localStorageService.saveChats(chats);
  }

  List<ChatModel> _getMockChats() {
    final random = Random();
    final List<ChatModel> mockChats = [];

    final List<String> names = [
      'John',
      'Jane',
      'Alice',
      'Bob',
      'Charlie',
      'Diana'
    ];
    final List<String> topics = [
      'Greetings',
      'Weather',
      'Hobbies',
      'Travel',
      'Food',
      'Movies'
    ];
    final List<String> levels = ['Beginner', 'Intermediate', 'Advanced'];
    final List<String> languages = [
      'English',
      'Spanish',
      'French',
      'German',
      'Italian',
      'Chinese'
    ];

    for (int i = 0; i < 20; i++) {
      String sourceLanguage = languages[random.nextInt(languages.length)];
      String targetLanguage;
      do {
        targetLanguage = languages[random.nextInt(languages.length)];
      } while (targetLanguage == sourceLanguage);

      mockChats.add(ChatModel(
        id: '${i + 1}',
        name: names[random.nextInt(names.length)],
        lastMessage: 'Random message ${random.nextInt(100)}',
        time:
            '${random.nextInt(12)}:${random.nextInt(60).toString().padLeft(2, '0')} ${random.nextBool() ? 'AM' : 'PM'}',
        avatarUrl: 'assets/blank.jpg',
        date: DateTime.now().subtract(
            Duration(days: random.nextInt(30), hours: random.nextInt(24))),
        chatTopic: topics[random.nextInt(topics.length)],
        languageLevel: levels[random.nextInt(levels.length)],
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
      ));
    }

    return mockChats;
  }
}
