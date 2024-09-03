import 'package:lessay_learn/features/chat/models/chat_model.dart';

class ChatService {
  List<ChatModel> getChats() {
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
