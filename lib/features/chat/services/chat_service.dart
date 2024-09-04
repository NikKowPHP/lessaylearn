import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/services/i_chat_service.dart';
import 'package:lessay_learn/services/local_storage_service.dart';

class ChatService implements IChatService {
  final LocalStorageService localStorageService;

  ChatService(this.localStorageService);

  @override
  Future<List<ChatModel>> getChats() async {
    final savedChats = await localStorageService.getChats();
    if (savedChats.isNotEmpty) {
      return savedChats;
    }
    return _getMockChats();
  }

  @override
  Future<void> saveChats(List<ChatModel> chats) async {
    await localStorageService.saveChats(chats);
  }

  List<ChatModel> _getMockChats() {
    return [
      ChatModel(
        name: "John Doe",
        lastMessage: "Hey, how are you?",
        time: "10:30 AM",
        avatarUrl: "https://i.pravatar.cc/150?img=3",
        date: DateTime.now().subtract(Duration(hours: 2)),
      ),
      ChatModel(
        name: "Jane Smith",
        lastMessage: "Meeting at 2 PM",
        time: "9:45 AM",
        avatarUrl: "https://i.pravatar.cc/150?img=3",
        date: DateTime.now().subtract(Duration(days: 1)),
      ),
      ChatModel(
        name: "Jane Smith",
        lastMessage: "Meeting at 2 PM",
        time: "9:45 AM",
        avatarUrl: "https://i.pravatar.cc/150?img=3",
        date: DateTime.now().subtract(Duration(days: 2)),
      ),
      ChatModel(
        name: "Jane Smith",
        lastMessage: "Meeting at 2 PM",
        time: "9:45 AM",
        avatarUrl: "https://i.pravatar.cc/150?img=3",
        date: DateTime.now().subtract(Duration(days: 1)),
      ),
      ChatModel(
        name: "Jane Smith",
        lastMessage: "Meeting at 2 PM",
        time: "9:45 AM",
        avatarUrl: "https://i.pravatar.cc/150?img=3",
        date: DateTime.now().subtract(Duration(days: 2)),
      ),
      ChatModel(
        name: "Jane Smith",
        lastMessage: "Meeting at 2 PM",
        time: "9:45 AM",
        avatarUrl: "https://i.pravatar.cc/150?img=3",
        date: DateTime.now().subtract(Duration(days: 1)),
      ),
      ChatModel(
        name: "Jane Smith",
        lastMessage: "Meeting at 2 PM",
        time: "9:45 AM",
        avatarUrl: "https://i.pravatar.cc/150?img=3",
        date: DateTime.now().subtract(Duration(days: 2)),
      ),
      ChatModel(
        name: "Jane Smith",
        lastMessage: "Meeting at 2 PM",
        time: "9:45 AM",
        avatarUrl: "https://i.pravatar.cc/150?img=3",
        date: DateTime.now().subtract(Duration(days: 1)),
      ),
      ChatModel(
        name: "Jane Smith",
        lastMessage: "Meeting at 2 PM",
        time: "9:45 AM",
        avatarUrl: "https://i.pravatar.cc/150?img=3",
        date: DateTime.now().subtract(Duration(days: 2)),
      ),
      // Add more mock chats as needed
    ];
  }
}
