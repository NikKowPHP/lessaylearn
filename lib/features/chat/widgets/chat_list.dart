import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/features/chat/services/chat_service.dart';
class ChatList extends StatelessWidget {
  final ChatService chatService = ChatService();

  ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chats = chatService.getChats()
      ..sort((a, b) => b.date.compareTo(a.date));

    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            // Implement refresh logic here
          },
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index.isOdd) {
                return Container(
                  height: 1,
                  color: CupertinoColors.separator,
                );
              }
              final chatIndex = index ~/ 2;
              final chat = chats[chatIndex];
              final isFirstOfDay = chatIndex == 0 || 
                !isSameDay(chat.date, chats[chatIndex - 1].date);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isFirstOfDay)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        formatDate(chat.date),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ),
                  ChatListItem(chat: chat),
                ],
              );
            },
            childCount: chats.length * 2 - 1,
          ),
        ),
      ],
    );
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    if (isSameDay(date, now)) {
      return 'Today';
    } else if (isSameDay(date, now.subtract(Duration(days: 1)))) {
      return 'Yesterday';
    } else {
      return DateFormat('MMMM d, y').format(date);
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
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