import 'package:hive/hive.dart';
import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/features/chat/models/message_model.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';



class LocalStorageService implements ILocalStorageService {
  static const String _chatsBoxName = 'chats';
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _messagesBoxName = 'messages';

  Future<Box> _openChatsBox() async {
    return await Hive.openBox(_chatsBoxName);
  }
    Future<Box> _openMessagesBox() async {
    return await Hive.openBox(_messagesBoxName);
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final box = await _openChatsBox();
    return box.get(_isLoggedInKey, defaultValue: false);
  }

  @override
  Future<void> saveChats(List<ChatModel> chats) async {
    if (await isUserLoggedIn()) {
      final box = await _openChatsBox();
      final chatList = chats.map((chat) => chat.toJson()).toList();
      await box.put(_chatsBoxName, chatList);
    }
  }

  @override
  Future<List<ChatModel>> getChats() async {
    final box = await _openChatsBox();
    final chatList = box.get(_chatsBoxName, defaultValue: []) as List;
    return chatList.map((chat) => ChatModel.fromJson(chat)).toList();
  }

   @override
Future<ChatModel?> getChatById(String chatId) async {
  final chats = await getChats();
  try {
    return chats.firstWhere((chat) => chat.id == chatId);
  } catch (e) {
    // TODO: Handle the case where no chat with the given ID is found
    // You can either return null or throw an exception
    return null; // Or throw an exception: throw ChatNotFoundException();
  }
}

  @override
  Future<void> updateChat(ChatModel chat) async {
    final chats = await getChats();
    final index = chats.indexWhere((c) => c.id == chat.id);
    if (index != -1) {
      chats[index] = chat;
      await saveChats(chats);
    }
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final chats = await getChats();
    chats.removeWhere((chat) => chat.id == chatId);
    await saveChats(chats);
  }

  @override
  Future<void> saveMessage(MessageModel message) async {
    final box = await _openMessagesBox();
    await box.put(message.id, message.toJson());
  }

  @override
  Future<List<MessageModel>> getMessagesForChat(String chatId) async {
    final box = await _openMessagesBox();
    final allMessages = box.values.map((json) => MessageModel.fromJson(json)).toList();
    return allMessages.where((message) => message.chatId == chatId).toList();
  }

  @override
  Future<MessageModel?> getMessageById(String messageId) async {
    final box = await _openMessagesBox();
    final json = box.get(messageId);
    return json != null ? MessageModel.fromJson(json) : null;
  }

  @override
  Future<void> updateMessage(MessageModel message) async {
    final box = await _openMessagesBox();
    await box.put(message.id, message.toJson());
  }

  @override
  Future<void> deleteMessagesForChat(String chatId) async {
    final box = await _openMessagesBox();
    final keysToDelete = box.values
        .where((json) => MessageModel.fromJson(json).chatId == chatId)
        .map((json) => MessageModel.fromJson(json).id)
        .toList();
    await box.deleteAll(keysToDelete);
  }
}
