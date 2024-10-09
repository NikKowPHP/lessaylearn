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

  Stream<MessageModel> get messageStream;
  Stream<bool> get typingIndicatorStream;
  Future<void> deleteMessage(String messageId);
  Future<List<MessageModel>> markAllMessagesAsRead(
      String chatId, String currentUserId);
  Future<List<MessageModel>> markPartnerMessagesAsRead(
      String chatId, String currentUserId);
}

class ChatService implements IChatService {
  final ILocalStorageService localStorageService;
  final StreamController<MessageModel> _messageStreamController =
      StreamController<MessageModel>.broadcast();
  final StreamController<bool> _typingIndicatorStreamController =
      StreamController<bool>.broadcast();

  ChatService(this.localStorageService);

  @override
  Stream<MessageModel> get messageStream => _messageStreamController.stream;
  @override
  Stream<bool> get typingIndicatorStream =>
      _typingIndicatorStreamController.stream;

  @override
  Future<List<MessageModel>> markPartnerMessagesAsRead(
      String chatId, String currentUserId) async {
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
  Future<List<MessageModel>> markAllMessagesAsRead(
      String chatId, String currentUserId) async {
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
    //TODO: Optionally, you can add any additional logic here,
    // such as creating an initial message for the chat
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
    await _updateChatWithLastMessage(message);

    if (!message.senderId.startsWith('bot')) {
      _typingIndicatorStreamController.add(true);

      await Future.delayed(Duration(seconds: Random().nextInt(3) + 1));

      await simulateReply(message.chatId, message.senderId);

      _typingIndicatorStreamController.add(false);
    }
  }

  Future<MessageModel?> simulateReply(String chatId, String senderId) async {
    final partner = await getChatPartner(chatId, senderId);
    debugPrint('Simulating reply for chatId: $chatId, senderId: $senderId');
    debugPrint('Retrieved partner: ${partner?.name}');

    await markAllMessagesAsRead(chatId, partner!.id);

    debugPrint('Marking messages as read for user: $senderId');
    debugPrint('Messages marked as read of current user: $senderId');

    final reply = MessageModel(
      id: UniqueKey().toString(),
      chatId: chatId,
      senderId: partner.id,
      receiverId: senderId,
      content: 'This is a simulated reply from ${partner.name}',
      timestamp: DateTime.now(),
      isRead: false,
    );

    debugPrint(
        'Sending reply: ${reply.content} from ${reply.senderId} to ${reply.receiverId}');
    _messageStreamController.add(reply);

    await _updateChatWithLastMessage(reply);
    await localStorageService.saveMessage(reply);
    debugPrint('Saved message: ${reply.content}');
    return reply;
  }

  Future<void> _updateChatWithLastMessage(MessageModel message) async {
    final chat = await localStorageService.getChatById(message.chatId);
    if (chat != null) {
      final updatedChat = chat.copyWith(
        lastMessage: message.content,
        lastMessageTimestamp: message.timestamp,
      );
      await localStorageService.updateChat(updatedChat);
      // Notify listeners about the updated chat
      _messageStreamController.add(message);
    } else {
      throw Exception('Chat not found');
    }
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
