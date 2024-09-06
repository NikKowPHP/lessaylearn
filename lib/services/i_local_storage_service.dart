import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/features/chat/models/message_model.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';

abstract class ILocalStorageService {
  Future<bool> isUserLoggedIn();
  Future<void> saveChats(List<ChatModel> chats);
  Future<List<ChatModel>> getChats();
  Future<ChatModel?> getChatById(String chatId);
  Future<void> updateChat(ChatModel chat);
  Future<void> deleteChat(String chatId);
  Future<void> saveMessage(MessageModel message);
  Future<List<MessageModel>> getMessagesForChat(String chatId);
  Future<MessageModel?> getMessageById(String messageId);
  Future<void> updateMessage(MessageModel message);
  Future<void> deleteMessagesForChat(String chatId);
  Future<List<UserModel>> getUsers(); // Add getUsers method
  Future<void> saveUsers(List<UserModel> users); // Add saveUsers method
}