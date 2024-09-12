import 'dart:math';

import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/features/chat/models/message_model.dart';
import 'package:lessay_learn/services/i_chat_service.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';

class ChatService implements IChatService {
  final ILocalStorageService localStorageService; // Use interface

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



 @override
  Future<List<MessageModel>> getMessagesForChat(String chatId) async {
    final savedMessages = await localStorageService.getMessagesForChat(chatId);
    return savedMessages.isNotEmpty ? savedMessages : _getMockMessages(chatId);
  }

  @override
  Future<void> sendMessage(MessageModel message) async {
    await localStorageService.saveMessage(message);
    // Update the last message for the chat
    final chat = await localStorageService.getChatById(message.chatId);
    if (chat != null) {
      final updatedChat = chat.copyWith(
        lastMessage: message.content,
        time: '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
        date: message.timestamp,
      );
      await localStorageService.updateChat(updatedChat);
    }
  }

  @override
  Future<void> markMessageAsRead(String messageId) async {
    final message = await localStorageService.getMessageById(messageId);
    if (message != null) {
      final updatedMessage = message.copyWith(isRead: true);
      await localStorageService.updateMessage(updatedMessage);
    }
  }

  @override
  Future<void> deleteChat(String chatId) async {
    await localStorageService.deleteChat(chatId);
    await localStorageService.deleteMessagesForChat(chatId);
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
        avatarUrl: 'assets/blank.png',
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

   List<MessageModel> _getMockMessages(String chatId) {
    final random = Random();
    final List<MessageModel> mockMessages = [];

    final now = DateTime.now();
    for (int i = 0; i < 20; i++) {
      mockMessages.add(MessageModel(
        id: '${chatId}_${i + 1}',
        chatId: chatId,
        senderId: random.nextBool() ? 'user' : 'other',
        content: 'Mock message ${random.nextInt(100)}',
        timestamp: now.subtract(Duration(minutes: random.nextInt(60 * 24))),
        isRead: random.nextBool(),
      ));
    }

    mockMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return mockMessages;
  }
}
