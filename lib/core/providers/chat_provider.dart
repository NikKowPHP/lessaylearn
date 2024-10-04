import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/providers/local_storage_provider.dart';
import 'package:lessay_learn/core/providers/translate_provider.dart';
import 'package:lessay_learn/core/services/translate_service.dart';
import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/features/chat/models/message_model.dart';

import 'package:lessay_learn/features/chat/services/chat_service.dart';



final selectedChatIdProvider = StateProvider<String?>((ref) => null);


final messagesProvider = StateNotifierProvider.family<MessagesNotifier, List<MessageModel>, String>((ref, chatId) {
  final chatService = ref.watch(chatServiceProvider);
  return MessagesNotifier(chatService, chatId);
});

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


// create chat provider
final createChatProvider = Provider<Future<void> Function(ChatModel)>((ref) {
  final chatService = ref.watch(chatServiceProvider);
  return (ChatModel newChat) async {
    await chatService.createChat(newChat);
    ref.read(chatsProvider.notifier).addChat(newChat);
  };
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
  Future<void> markPartnerMessagesAsRead(String currentUserId) async {
    state = await _chatService.markPartnerMessagesAsRead(_chatId, currentUserId);
  }

  Future<void> markAllAsRead(String currentUserId) async {
    state = await _chatService.markAllMessagesAsRead(_chatId, currentUserId);
  }

  void addMessage(MessageModel message) {
    state = [...state, message];
  }

    Future<void> sendMessage(MessageModel message) async {
    // Add the message to the state immediately
    state = [...state, message];
    
    // Send the message through the chat service
    await _chatService.sendMessage(message);
    
  
  }

  void updateMessage(MessageModel updatedMessage) {
    state = [
      for (final message in state)
        if (message.id == updatedMessage.id) updatedMessage else message
    ];
  }

  void updateMessages(List<MessageModel> updatedMessages) {
    state = updatedMessages;
  }
}


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

   void updateChatWithLastMessage(MessageModel message) {
    state = [
      for (final chat in state)
        if (chat.id == message.chatId)
          chat.copyWith(
            lastMessage: message.content,
            lastMessageTimestamp: message.timestamp,
          )
        else
          chat
    ];
  }

  void addChat(ChatModel newChat) {
    state = [newChat, ...state];
  }
}

final translationTriggerProvider = StateProvider<TranslationTrigger?>((ref) => null);

class TranslationTrigger {
  final String messageId;
  final String text;
  final String targetLanguage;

  TranslationTrigger({
    required this.messageId,
    required this.text,
    required this.targetLanguage,
  });
}

final translatedMessageProvider = FutureProvider.autoDispose.family<TranslationResult?, String>((ref, messageId) async {
  final trigger = ref.watch(translationTriggerProvider);
  if (trigger == null || trigger.messageId != messageId) return null;

  final translation = await ref.watch(translateProvider(
    TranslateParams(text: trigger.text, targetLanguage: trigger.targetLanguage)
  ).future);

  return translation;
});