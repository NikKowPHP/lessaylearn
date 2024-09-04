import 'package:lessay_learn/features/chat/models/chat_model.dart';

abstract class IChatService {
  Future<List<ChatModel>> getChats();
  Future<void> saveChats(List<ChatModel> chats);
}