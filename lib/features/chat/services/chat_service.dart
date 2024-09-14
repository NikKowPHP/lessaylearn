import 'dart:math';

import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/features/chat/models/message_model.dart';
import 'package:lessay_learn/services/i_chat_service.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';

class ChatService implements IChatService {
  final ILocalStorageService localStorageService; // Use interface

  ChatService(this.localStorageService);
  @override
  @override
  Future<void> createChat(ChatModel chat) async {
    await localStorageService.saveChat(chat);
  }

  Future<List<ChatModel>> getChats() async {
    final savedChats = await localStorageService.getChats();

    savedChats.sort(
        (a, b) => b.lastMessageTimestamp.compareTo(a.lastMessageTimestamp));
    return savedChats;
  }
@override
  Future<String> getChatPartnerName(String chatId, String currentUserId) async {
  final chat = await localStorageService.getChatById(chatId);
  if (chat == null) return 'Unknown';

  final partnerUserId = chat.hostUserId == currentUserId ? chat.guestUserId : chat.hostUserId;
  final user = await localStorageService.getUserById(partnerUserId);
  return user?.name ?? 'Unknown';
}

  @override
  Future<void> saveChats(List<ChatModel> chats) async {
    await localStorageService.saveChats(chats);

  }
    @override
  Future<ChatModel?> getChatById(String chatId) async {
    return await localStorageService.getChatById(chatId);
  }

  @override
  Future<List<MessageModel>> getMessagesForChat(String chatId) async {
    return await localStorageService.getMessagesForChat(chatId);
  }

  @override
  Future<void> sendMessage(MessageModel message) async {
    await localStorageService.saveMessage(message);
    // Update the last message for the chat
    final chat = await localStorageService.getChatById(message.chatId);
    if (chat != null) {
      final updatedChat = chat.copyWith(
        lastMessage: message.content,
        lastMessageTimestamp: message.timestamp,
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
}
