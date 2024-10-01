
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/features/chat/models/message_model.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/services/i_chat_service.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';

class ChatService implements IChatService {
  final ILocalStorageService localStorageService; // Use interface
  final StreamController<MessageModel> _messageStreamController = StreamController<MessageModel>.broadcast();

  @override
  Stream<MessageModel> get messageStream => _messageStreamController.stream;



  ChatService(this.localStorageService);
  @override
  @override
  Future<void> createChat(ChatModel chat) async {
    await localStorageService.saveChat(chat);
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    await localStorageService.deleteMessagesForChat(messageId);
    // Optionally, notify listeners or update the UI
  }

  @override
  Future<void> markAllMessagesAsRead(String chatId) async {
    final messages = await getMessagesForChat(chatId);
    for (var message in messages) {
      if (!message.isRead) {
        await markMessageAsRead(message.id);
      }
    }
  }

   @override
  Future<UserModel?> getChatPartner(String chatId, String currentUserId) async {
    final chat = await localStorageService.getChatById(chatId);
    if (chat == null) return null;

    final partnerUserId = chat.hostUserId == currentUserId ? chat.guestUserId : chat.hostUserId;
    return await localStorageService.getUserById(partnerUserId);
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
    final updatedChat = await _updateChatWithLastMessage(message);

    _messageStreamController.add(message);
    // Notify listeners about the updated chat
    _notifyChatsUpdated();
  }

    Future<ChatModel> _updateChatWithLastMessage(MessageModel message) async {
    final chat = await localStorageService.getChatById(message.chatId);
    if (chat != null) {
      final updatedChat = chat.copyWith(
        lastMessage: message.content,
        lastMessageTimestamp: message.timestamp,
      );
      await localStorageService.updateChat(updatedChat);
      return updatedChat;
    }
    throw Exception('Chat not found');
  }

  void _notifyChatsUpdated() {
    // Implement a method to notify listeners about updated chats
  }

    @override
  Future<UserModel?> getUserById(String userId) async {
    return await localStorageService.getUserById(userId);
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
