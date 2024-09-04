import 'package:hive/hive.dart';
import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';



class LocalStorageService implements ILocalStorageService {
  static const String _chatsBoxName = 'chats';
  static const String _isLoggedInKey = 'isLoggedIn';

  Future<Box> _openChatsBox() async {
    return await Hive.openBox(_chatsBoxName);
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
}
