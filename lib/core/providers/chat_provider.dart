import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/providers/local_storage_provider.dart';
import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/features/chat/models/message_model.dart';

import 'package:lessay_learn/features/chat/services/chat_service.dart';



final selectedChatIdProvider = StateProvider<String?>((ref) => null);


final messagesProvider = StateNotifierProvider.family<MessagesNotifier, List<MessageModel>, String>((ref, chatId) {
  final chatService = ref.watch(chatServiceProvider);
  return MessagesNotifier(chatService, chatId);
});


class MessagesNotifier extends StateNotifier<List<MessageModel>> {
  final IChatService _chatService;
  final String _chatId;

  MessagesNotifier(this._chatService, this._chatId) : super([]) {
    loadMessages();
  }

  Future<void> loadMessages() async {
    state = await _chatService.getMessagesForChat(_chatId);
  }

  Future<void> markAllAsRead(String currentUserId) async {
    state = await _chatService.markAllMessagesAsRead(_chatId, currentUserId);
  }

  void addMessage(MessageModel message) {
    state = [...state, message];
  }

  void updateMessage(MessageModel updatedMessage) {
    state = [
      for (final message in state)
        if (message.id == updatedMessage.id) updatedMessage else message
    ];
  }
}


// Provider for the typing indicator stream (unchanged)
final typingIndicatorStreamProvider = StreamProvider.autoDispose.family<bool, String>((ref, chatId) {
  final chatService = ref.watch(chatServiceProvider);
  return chatService.typingIndicatorStream;
});


final chatServiceProvider = Provider<IChatService>((ref) {
  final localStorageService = ref.watch(localStorageServiceProvider);
  return ChatService(localStorageService);
});
final messageStreamProvider = StreamProvider.autoDispose.family<MessageModel, String>((ref, chatId) {
  final chatService = ref.watch(chatServiceProvider);
  return chatService.messageStream.where((message) => message.chatId == chatId);
});

final chatsProvider = StateNotifierProvider<ChatsNotifier, List<ChatModel>>((ref) {
  final chatService = ref.watch(chatServiceProvider);
  return ChatsNotifier(chatService);
});

class ChatsNotifier extends StateNotifier<List<ChatModel>> {
  final IChatService _chatService;

  ChatsNotifier(this._chatService) : super([]) {
    loadChats();
  }

  Future<void> loadChats() async {
    state = await _chatService.getChats();
  }

  void updateChat(ChatModel updatedChat) {
    state = [
      for (final chat in state)
        if (chat.id == updatedChat.id) updatedChat else chat
    ];
  }
}