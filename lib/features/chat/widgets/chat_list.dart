import 'dart:async';

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

class ChatList extends ConsumerStatefulWidget {
  final bool isWideScreen;
  final String? selectedChatId;
  ChatList({Key? key, this.isWideScreen = false, this.selectedChatId})
      : super(key: key);

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(minutes: 1), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chats = ref.watch(chatsProvider);
    final currentUserAsync = ref.watch(currentUserProvider);
    final isWideScreen = widget.isWideScreen;
    final selectedChatId = widget.selectedChatId;

   return currentUserAsync.when(
      data: (currentUser) => _buildChatListView(context, ref, chats, currentUser, isWideScreen, selectedChatId),
      loading: () => _buildLoadingIndicator(),
      error: (error, stack) => buildErrorWidget(error.toString()),
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

Widget _buildChatListView(
    BuildContext context,
    WidgetRef ref,
    List<ChatModel> chats,
    UserModel currentUser,
    bool isWideScreen,
    String? selectedChatId) {
      chats.sort((a, b) => b.lastMessageTimestamp.compareTo(a.lastMessageTimestamp));
  return CupertinoScrollbar(
    child: CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            await ref.read(chatsProvider.notifier).loadChats();
          },
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildChatListItem(context, ref, chats, index,
                currentUser, isWideScreen, selectedChatId),
            childCount: chats.length,
          ),
        ),
      ],
    ),
  );
}

Widget _buildChatListItem(
    BuildContext context,
    WidgetRef ref,
    List<ChatModel> chats,
    int index,
    UserModel currentUser,
    bool isWideScreen,
    String? selectedChatId) {
  if (index.isOdd) {
    return _buildSeparator();
  }
  final chatService = ref.watch(chatServiceProvider);
  final chatIndex = index ~/ 2;
  final chat = chats[chatIndex];
  final isFirstOfDay = chatIndex == 0 ||
      !_isSameDay(
          chat.lastMessageTimestamp, chats[chatIndex - 1].lastMessageTimestamp);

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
          return ChatListItem(
            chat: chat,
            partner: partner,
            isWideScreen: isWideScreen,
            selectedChatId: selectedChatId,
          );
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
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Text(
      _formatDate(date),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: CupertinoColors.secondaryLabel,
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

class ChatListItem extends ConsumerWidget {
  final ChatModel chat;
  final UserModel? partner;
  final bool isWideScreen;
  final String? selectedChatId;

  const ChatListItem(
      {Key? key,
      required this.chat,
      this.partner,
      this.isWideScreen = false,
      this.selectedChatId})
      : super(key: key);

  Widget _buildCupertinoAvatar(String avatarUrl) {
    return AvatarWidget(imageUrl: avatarUrl, size: 50, isNetworkImage: false);
  }

  Widget _buildAvatar() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: CupertinoColors.systemGrey5,
      ),
      child: ClipOval(
        child: partner != null
            ? _buildCupertinoAvatar(partner!.avatarUrl)
            : Icon(CupertinoIcons.person_fill,
                color: CupertinoColors.systemGrey),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: isWideScreen && chat.id == selectedChatId
          ? CupertinoColors.systemBackground
          : null,
      child: CupertinoListTile(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: _buildAvatar(),
        title: Text(
          partner?.name ?? 'Unknown',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: CupertinoColors.systemGrey4),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              chat.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 14),
            ),
            SizedBox(height: 6),
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
              style:
                  TextStyle(color: CupertinoColors.systemGrey2, fontSize: 12),
            ),
            SizedBox(height: 4),
            Icon(CupertinoIcons.chevron_right,
                size: 16, color: CupertinoColors.systemGrey2),
          ],
        ),
        onTap: () {
          final screenWidth = MediaQuery.of(context).size.width;
          final isWideScreen = screenWidth > 600;
          if (isWideScreen) {
            ref.read(selectedChatIdProvider.notifier).state = chat.id;
          } else {
            context.go('/chat/${chat.id}', extra: chat);
          }
        },
      ),
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
