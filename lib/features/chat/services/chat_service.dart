import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/features/chat/models/message_model.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';

import 'package:lessay_learn/services/local_storage_service.dart';

abstract class IChatService {
  Future<List<ChatModel>> getChats();
  Future<void> saveChats(List<ChatModel> chats);
  Future<List<MessageModel>> getMessagesForChat(String chatId);
  Future<void> sendMessage(MessageModel message);

  Future<void> deleteChat(String chatId);
  Future<void> createChat(ChatModel chat);
  Future<String> getChatPartnerName(String chatId, String currentUserId);
  Future<ChatModel?> getChatById(String chatId);
  Future<UserModel?> getUserById(String userId);
  Future<UserModel?> getChatPartner(String chatId, String currentUserId);
  // New methods added
  Stream<MessageModel> get messageStream;
  Stream<bool> get typingIndicatorStream;
  Future<void> deleteMessage(
      String messageId); // Method to delete a specific message
  Future<List<MessageModel>> markAllMessagesAsRead(
      String chatId, String currentUserId); // Method to mark all messages in a chat as read
}

class ChatService implements IChatService {
  final ILocalStorageService localStorageService; // Use interface
  final StreamController<MessageModel> _messageStreamController =
      StreamController<MessageModel>.broadcast();
  final StreamController<bool> _typingIndicatorStreamController =
      StreamController<bool>.broadcast();

  @override
  Stream<MessageModel> get messageStream => _messageStreamController.stream;
  @override
  Stream<bool> get typingIndicatorStream =>
      _typingIndicatorStreamController.stream;

  ChatService(this.localStorageService);

   @override
  Future<List<MessageModel>> markAllMessagesAsRead(String chatId, String currentUserId) async {
    final messages = await getMessagesForChat(chatId);
    List<MessageModel> updatedMessages = [];

    for (var message in messages) {
      if (!message.isRead && message.receiverId == currentUserId) {
        final updatedMessage = message.copyWith(isRead: true);
        await localStorageService.updateMessage(updatedMessage);
        updatedMessages.add(updatedMessage);
      } else {
        updatedMessages.add(message);
      }
    }

    return updatedMessages;
  }

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
  Future<UserModel?> getChatPartner(String chatId, String currentUserId) async {
    final chat = await localStorageService.getChatById(chatId);
    if (chat == null) return null;

    final partnerUserId =
        chat.hostUserId == currentUserId ? chat.guestUserId : chat.hostUserId;
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

    final partnerUserId =
        chat.hostUserId == currentUserId ? chat.guestUserId : chat.hostUserId;
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

    // Mark all messages in the chat as read
    await markAllMessagesAsRead(message.chatId, message.senderId);

    _messageStreamController.add(message);
    // Notify listeners about the updated chat
    _notifyChatsUpdated();

    // Simulate a reply from the partner (only if it's not a bot)
    if (!message.senderId.startsWith('bot')) {
      _typingIndicatorStreamController.add(true); // Signal typing start
      await Future.delayed(
          Duration(seconds: Random().nextInt(3) + 1)); // Delay 1-3 seconds
      _simulatePartnerReply(message.chatId, message.senderId);
      _typingIndicatorStreamController.add(false); // Signal typing end
    }
  }

  Future<void> _simulatePartnerReply(String chatId, String senderId) async {
    final partner = await getChatPartner(chatId, senderId);
    if (partner != null) {
      final reply = MessageModel(
        id: UniqueKey().toString(),
        chatId: chatId,
        senderId: partner.id,
        receiverId: senderId,
        content: 'This is a simulated reply from ${partner.name}',
        timestamp: DateTime.now(),
      );
      _messageStreamController.add(reply);
      await _updateChatWithLastMessage(reply);
      await localStorageService.saveMessage(reply);
    }
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
  Future<void> deleteChat(String chatId) async {
    await localStorageService.deleteChat(chatId);
    await localStorageService.deleteMessagesForChat(chatId);
  }
}
