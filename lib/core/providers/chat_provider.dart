import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/providers/local_storage_provider.dart';
import 'package:lessay_learn/features/chat/models/chat_model.dart';

import 'package:lessay_learn/features/chat/services/chat_service.dart';
import 'package:lessay_learn/services/i_chat_service.dart';
import 'package:lessay_learn/services/local_storage_service.dart';


final selectedChatIdProvider = StateProvider<String?>((ref) => null);


final chatServiceProvider = Provider<IChatService>((ref) {
  final localStorageService = ref.watch(localStorageServiceProvider);
  return ChatService(localStorageService);
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