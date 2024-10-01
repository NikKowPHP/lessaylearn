import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/features/chat/models/message_model.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';

abstract class IChatService {
  Future<List<ChatModel>> getChats();
  Future<void> saveChats(List<ChatModel> chats);
  Future<List<MessageModel>> getMessagesForChat(String chatId);
  Future<void> sendMessage(MessageModel message);
  Future<void> markMessageAsRead(String messageId);
  Future<void> deleteChat(String chatId);
  Future<void> createChat(ChatModel chat);
  Future<String> getChatPartnerName(String chatId, String currentUserId);
   Future<ChatModel?> getChatById(String chatId);
    Future<UserModel?> getUserById(String userId);
    Future<UserModel?> getChatPartner(String chatId, String currentUserId);
     // New methods added
  Stream<MessageModel> get messageStream; // Stream for real-time message updates
  Future<void> deleteMessage(String messageId); // Method to delete a specific message
  Future<void> markAllMessagesAsRead(String chatId); // Method to mark all messages in a chat as read
}