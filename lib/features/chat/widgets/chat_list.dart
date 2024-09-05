import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:lessay_learn/features/chat/widgets/chat_screen.dart';
import 'package:lessay_learn/services/local_storage_service.dart';
import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/features/chat/services/chat_service.dart';

class ChatList extends StatelessWidget {
final ChatService chatService = ChatService(LocalStorageService());

  ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChatModel>>(
      future: chatService.getChats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.error.toString());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyListWidget();
        }

        final chats = snapshot.data!..sort((a, b) => b.date.compareTo(a.date));
        return _buildChatListView(chats);
      },
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

Widget _buildLoadingIndicator() {
    return Center(child: CupertinoActivityIndicator());
  }

Widget buildErrorWidget(String error) {
  return Center(child: Text('Error: $error'));
}

  Widget _buildEmptyListWidget() {
    return Center(child: Text('No chats available'));
  }

  Widget _buildChatListView(List<ChatModel> chats) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            // Implement refresh logic here
          },
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildChatListItem(chats, index),
            childCount: chats.length * 2 - 1,
          ),
        ),
      ],
    );
  }

  Widget _buildChatListItem(List<ChatModel> chats, int index) {
    if (index.isOdd) {
      return _buildSeparator();
    }
    final chatIndex = index ~/ 2;
    final chat = chats[chatIndex];
    final isFirstOfDay = chatIndex == 0 || 
      !_isSameDay(chat.date, chats[chatIndex - 1].date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isFirstOfDay) _buildDateHeader(chat.date),
        ChatListItem(chat: chat),
      ],
    );
  }

  Widget _buildSeparator() {
    return Container(
      height: 1,
      color: CupertinoColors.separator,
    );
  }

  Widget _buildDateHeader(DateTime date) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        _formatDate(date),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: CupertinoColors.systemGrey,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (_isSameDay(date, now)) {
      return 'Today';
    } else if (_isSameDay(date, now.subtract(Duration(days: 1)))) {
      return 'Yesterday';
    } else {
      return DateFormat('MMMM d, y').format(date);
    }
  }
   bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }

class ChatListItem extends StatelessWidget {
  final ChatModel chat;

  const ChatListItem({Key? key, required this.chat}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      leading: ClipOval(
        child: Container(
          width: 50,
          height: 50,
          child: Image.network(
            chat.avatarUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: CupertinoColors.systemGrey,
                child: Icon(CupertinoIcons.person_fill, color: CupertinoColors.white),
              );
            },
          ),
        ),
      ),
      title: Text(chat.name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(chat.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
          SizedBox(height: 4),
          Row(
            children: [
              _buildTag(chat.languageLevel, CupertinoColors.activeBlue),
              SizedBox(width: 8),
              _buildTag(chat.chatTopic, CupertinoColors.activeGreen),
            ],
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(chat.time, style: TextStyle(color: CupertinoColors.systemGrey)),
          SizedBox(height: 4),
          Icon(CupertinoIcons.chevron_right, size: 16, color: CupertinoColors.systemGrey),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => IndividualChatScreen(chat: chat),
          ),
        );
      },
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12),
      ),
    );
  }
}