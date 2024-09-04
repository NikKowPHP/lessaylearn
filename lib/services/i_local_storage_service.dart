import 'package:lessay_learn/features/chat/models/chat_model.dart';

abstract class ILocalStorageService {
  Future<bool> isUserLoggedIn();
  Future<void> saveChats(List<ChatModel> chats);
  Future<List<ChatModel>> getChats();
}