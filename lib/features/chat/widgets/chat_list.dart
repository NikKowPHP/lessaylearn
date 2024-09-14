import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lessay_learn/core/providers/chat_provider.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/features/chat/services/chat_service.dart';
import 'package:lessay_learn/features/home/providers/current_user_provider.dart';
import 'package:lessay_learn/features/profile/widgets/avatar_widget.dart';
import 'package:lessay_learn/services/i_chat_service.dart';
import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:go_router/go_router.dart';

class ChatList extends ConsumerWidget {


  ChatList({Key? key}) : super(key: key);

@override
Widget build(BuildContext context, WidgetRef ref) {
      final chatService = ref.watch(chatServiceProvider);
 
 final currentUserAsync = ref.watch(currentUserProvider);
  return currentUserAsync.when(
    data: (currentUser) {
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

          final chats = snapshot.data!;
          return _buildChatListView(context, ref, chats, currentUser);
        },
      );
    },
    loading: () => _buildLoadingIndicator(),
    error: (error, stackTrace) => buildErrorWidget(error.toString()),
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

 Widget _buildChatListView(BuildContext context, WidgetRef ref, List<ChatModel> chats, UserModel currentUser) {
    return CustomScrollView( 
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            // Implement refresh logic here
          },
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
         (context, index) => _buildChatListItem(context, ref, chats, index, currentUser),
            childCount: chats.length * 2 - 1,
          ),
        ),
      ],
    );
  }





  Widget _buildChatListItem(BuildContext context, WidgetRef ref, List<ChatModel> chats, int index, UserModel currentUser) {
    if (index.isOdd) {
    return _buildSeparator();
  }
  final chatService = ref.watch(chatServiceProvider);
  final chatIndex = index ~/ 2;
  final chat = chats[chatIndex];
  final isFirstOfDay = chatIndex == 0 || 
    !_isSameDay(chat.lastMessageTimestamp, chats[chatIndex - 1].lastMessageTimestamp);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
        if (isFirstOfDay) _buildDateHeader(chat.lastMessageTimestamp),
        FutureBuilder<UserModel?>(
          future: chatService.getChatPartner(chat.id, currentUser.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CupertinoActivityIndicator();
            }
            final partner = snapshot.data;
            return ChatListItem(chat: chat, partner: partner);
          },
        ),
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
  final UserModel? partner;

  const ChatListItem({Key? key, required this.chat, this.partner}) : super(key: key);


   Widget _buildCupertinoAvatar(String avatarUrl) {
    return AvatarWidget(imageUrl: avatarUrl, size: 50, isNetworkImage: false);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      leading: ClipOval(
        child: Container(
          width: 50,
          height: 50,
          // child: Image.network(
          //   chat.avatarUrl,
          //   fit: BoxFit.cover,
          //   errorBuilder: (context, error, stackTrace) {
          //     return Container(
          //       color: CupertinoColors.systemGrey,
          //       child: Icon(CupertinoIcons.person_fill, color: CupertinoColors.white),
          //     );
          //   },
          // ),
           child: partner != null ? _buildCupertinoAvatar(partner!.avatarUrl) : Icon(CupertinoIcons.person_fill, color: CupertinoColors.systemGrey),
         
        ),
        
      ),
      title: Text(partner?.name ?? 'Unknown', style: TextStyle(fontWeight: FontWeight.bold)),
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
          Text(
            _formatTime(chat.lastMessageTimestamp),
            style: TextStyle(color: CupertinoColors.systemGrey),
          ),
          SizedBox(height: 4),
          Icon(CupertinoIcons.chevron_right, size: 16, color: CupertinoColors.systemGrey),
        ],
      ),
      onTap: () {
        context.go('/chat/${chat.id}', extra: chat); 
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
String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Now';
    }
  }

}

