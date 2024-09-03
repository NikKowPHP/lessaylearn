import 'package:flutter/cupertino.dart';
import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/features/chat/services/chat_service.dart';

class ChatList extends StatelessWidget {
  final ChatService chatService = ChatService();

  ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chats = chatService.getChats();

    return CupertinoScrollbar(
      child: ListView.separated(
        itemCount: chats.length,
         separatorBuilder: (context, index) => Container(
          height: 1,
          color: CupertinoColors.separator,
        ),
        itemBuilder: (context, index) {
          return ChatListItem(chat: chats[index]);
        },
      ),
    );
  }
}

class ChatListItem extends StatelessWidget {
  final ChatModel chat;

  const ChatListItem({Key? key, required this.chat}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      leading: ClipOval(
        child: Container(
          width: 40,
          height: 40,
          child: Image.network(
            chat.avatarUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('Error loading image: $error');
              return Container(
                color: CupertinoColors.systemGrey,
                child: Icon(CupertinoIcons.person_fill, color: CupertinoColors.white),
              );
            },
          ),
        ),
      ),
      title: Text(chat.name),
      subtitle: Text(chat.lastMessage),
      trailing: Text(chat.time),
      onTap: () {
        // Handle chat item tap
      },
    );
  }
}