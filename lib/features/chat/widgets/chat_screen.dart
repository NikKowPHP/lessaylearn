import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/features/chat/models/message_model.dart';
import 'package:lessay_learn/core/providers/chat_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/features/home/providers/current_user_provider.dart';
import 'package:lessay_learn/features/profile/widgets/avatar_widget.dart';

class IndividualChatScreen extends ConsumerStatefulWidget {
  final ChatModel chat;

  const IndividualChatScreen({
    Key? key,
    required this.chat,
  }) : super(key: key);

  @override
  ConsumerState<IndividualChatScreen> createState() =>
      _IndividualChatScreenState();
}

class _IndividualChatScreenState extends ConsumerState<IndividualChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<MessageModel> _messages = [];
  UserModel? _chatPartner;
  @override
  void initState() {
    super.initState();
    _loadMessages();
    _loadChatPartner();
  }

Future<void> _loadChatPartner() async {
  final chatService = ref.read(chatServiceProvider);
  final currentUserAsync = ref.read(currentUserProvider);
  
  await currentUserAsync.when(
    data: (currentUser) async {
      final partnerUserId = widget.chat.hostUserId == currentUser.id
          ? widget.chat.guestUserId
          : widget.chat.hostUserId;
      final partner = await chatService.getUserById(partnerUserId);
      if (mounted) {
        setState(() {
          _chatPartner = partner;
        });
      }
    },
    loading: () => null,
    error: (_, __) => null,
  );
}
  Future<void> _loadMessages() async {
    final chatService = ref.read(chatServiceProvider);
    final messages = await chatService.getMessagesForChat(widget.chat.id);
    setState(() {
      _messages = messages;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
       final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;
    return CupertinoPageScaffold(
       navigationBar: isWideScreen ? null : _buildNavigationBar(),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildMessageList()),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

 

  CupertinoNavigationBar _buildNavigationBar() {
    return CupertinoNavigationBar(
      middle: _chatPartner == null
          ? const CupertinoActivityIndicator()
          : GestureDetector(
              onTap: () => context.push('/profile/${_chatPartner!.id}'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AvatarWidget(
                    imageUrl: _chatPartner!.avatarUrl,
                    size: 30,
                    isNetworkImage: true,
                  ),
                  const SizedBox(width: 8),
                  Text(_chatPartner!.name),
                ],
              ),
            ),
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        child: const Icon(CupertinoIcons.back),
        onPressed: () => context.go('/'),
      ),
      trailing: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Icon(CupertinoIcons.info),
        onPressed: () {
          // Show chat info
        },
      ),
    );
  }

  Widget _buildMessageList() {
    final currentUserId = 'user1';
    //TODO: Replace with actual user ID
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CupertinoScrollbar(
        controller: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          final isLastInSequence = index == _messages.length - 1 ||
              _messages[index + 1].senderId != message.senderId;

          return MessageBubble(
            message: message,
            currentUserId: ref.read(currentUserProvider).value!.id,
            isLastInSequence: isLastInSequence,
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: CupertinoTextField(
              controller: _messageController,
              placeholder: 'Type a message...',
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          SizedBox(width: 8),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.paperplane_fill),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

void _sendMessage() async {
  final messageContent = _messageController.text.trim();
  if (messageContent.isNotEmpty) {
    final currentUser = ref.read(currentUserProvider);
    
    if (currentUser.value == null || _chatPartner == null) {
      // Show an error message or wait for the data to load
          // Show an error message or wait for the data to load
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text('Error'),
          content: Text('Unable to send message. Please try again.'),
          actions: [
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    final newMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: widget.chat.id,
      senderId: currentUser.value!.id,
      receiverId: _chatPartner!.id,
      content: messageContent,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });

    final chatService = ref.read(chatServiceProvider);
    await chatService.sendMessage(newMessage);

    // Update the chat in the chats list
    ref.read(chatsProvider.notifier).updateChat(widget.chat.copyWith(
      lastMessage: newMessage.content,
      lastMessageTimestamp: newMessage.timestamp,
    ));

    _scrollToBottom();
  }
}

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final String currentUserId;
final bool isLastInSequence;
  const MessageBubble({
    Key? key,
    required this.message,
    required this.currentUserId,
    required this.isLastInSequence,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUserMessage = message.senderId == currentUserId;

    debugPrint('Message sender ID: ${message.senderId}');
  return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: 2,
                bottom: isLastInSequence ? 8 : 2,
                left: 8,
                right: 8,
              ),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isUserMessage
                    ? CupertinoColors.activeBlue
                    : CupertinoColors.systemGrey5,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(isUserMessage || !isLastInSequence ? 16 : 4),
                  bottomRight: Radius.circular(isUserMessage && isLastInSequence ? 4 : 16),
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 64),
                    child: TappableText(text: message.content, isUserMessage: isUserMessage),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTimestamp(message.timestamp),
                          style: TextStyle(
                            fontSize: 10,
                            color: isUserMessage
                                ? CupertinoColors.white.withOpacity(0.7)
                                : CupertinoColors.systemGrey,
                          ),
                        ),
                        SizedBox(width: 4),
                        if (isUserMessage) _buildReadIndicator(message.isRead),
                      ],
                    ),
                  ),
                ],
              ),
            ),
           if (isLastInSequence)
              Positioned(
                bottom: 3,
                right: isUserMessage ? 8 : null,
                left: isUserMessage ? null : 8,
              
                child: CustomPaint(
                  painter: BubbleWingPainter(
                    color: isUserMessage
                        ? CupertinoColors.activeBlue
                        : CupertinoColors.systemGrey5,
                    isUserMessage: isUserMessage,
                  ),
                  size: Size(8, 8),
                ),
              ),
          ],
        ),
      ),
    );
  
  }

 Widget _buildReadIndicator(bool isRead) {
    return SizedBox(
      width: 18,
      height: 16,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: Icon(
              CupertinoIcons.checkmark_alt,
              size: 16,
              color: CupertinoColors.white,
            ),
          ),
          if (isRead)
            Positioned(
              left: 5,
              child: Icon(
                CupertinoIcons.checkmark_alt,
                size: 16 ,
                color: CupertinoColors.white,
              ),
            ),
        ],
      ),
    );
  }

   String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}

class TappableText extends StatelessWidget {
  final String text;
  final bool isUserMessage;

  const TappableText(
      {Key? key, required this.text, required this.isUserMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final words = text.split(' ');
    return Wrap(
      children: words.map((word) => _buildTappableWord(word)).toList(),
    );
  }

  Widget _buildTappableWord(String word) {
    final tooltipController = JustTheController();
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        bool isStarred = false;
        return JustTheTooltip(
          controller: tooltipController,
          preferredDirection: AxisDirection.up,
          tailLength: 10.0,
          tailBaseWidth: 20.0,
          backgroundColor: CupertinoColors.systemBackground,
          content: _buildTooltipContent(word, isStarred, setState),
          child: GestureDetector(
            onLongPress: tooltipController.showTooltip,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                word,
                style: TextStyle(
                  color: isUserMessage
                      ? CupertinoColors.white
                      : CupertinoColors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTooltipContent(
      String word, bool isStarred, StateSetter setState) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(word),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () => setState(() => isStarred = !isStarred),
            child: Icon(
              isStarred ? CupertinoIcons.star_fill : CupertinoIcons.star,
              color: CupertinoColors.activeBlue,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}


class BubbleWingPainter extends CustomPainter {
  final Color color;
  final bool isUserMessage;

  BubbleWingPainter({required this.color, required this.isUserMessage});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    if (isUserMessage) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(0, 0);
      path.lineTo(0, size.height);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}