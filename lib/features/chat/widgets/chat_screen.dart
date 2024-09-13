import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/features/chat/models/message_model.dart';
import 'package:lessay_learn/core/providers/chat_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class IndividualChatScreen extends ConsumerStatefulWidget {
  final ChatModel chat;

  const IndividualChatScreen({
    Key? key, 
    required this.chat, 
  }) : super(key: key);

  @override
  ConsumerState<IndividualChatScreen> createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends ConsumerState<IndividualChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<MessageModel> _messages = [];
String _chatPartnerName = 'Loading...';
  @override
  void initState() {
    super.initState();
    _loadMessages();
     _loadChatPartnerName();
  }

  Future<void> _loadChatPartnerName() async {
  final chatService = ref.read(chatServiceProvider);
  final currentUserId = 'currentUserId'; // Replace with actual current user ID
  final partnerName = await chatService.getChatPartnerName(widget.chat.id, currentUserId);
  setState(() {
    _chatPartnerName = partnerName;
  });
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
    return CupertinoPageScaffold(
      navigationBar: _buildNavigationBar(),
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
     middle: Text(_chatPartnerName),
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
  final currentUserId = 'user'; 
  //TODO: Replace with actual user ID
  return GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    child: CupertinoScrollbar(
      controller: _scrollController,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _messages.length,
        itemBuilder: (context, index) => MessageBubble(
          message: _messages[index],
          currentUserId: currentUserId,
        ),
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
    final currentUserId = 'user'; // Replace with actual user ID
    final receiverId = widget.chat.hostUserId == currentUserId
        ? widget.chat.guestUserId
        : widget.chat.hostUserId;

    final newMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: widget.chat.id,
      senderId: currentUserId,
      receiverId: receiverId,
      content: messageContent,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });

    final chatService = ref.read(chatServiceProvider);
    await chatService.sendMessage(newMessage);

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

  const MessageBubble({
    Key? key,
    required this.message,
    required this.currentUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUserMessage = message.senderId == currentUserId;
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUserMessage ? CupertinoColors.activeBlue : CupertinoColors.systemGrey5,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TappableText(text: message.content, isUserMessage: isUserMessage),
      ),
    );
  }
}

class TappableText extends StatelessWidget {
  final String text;
  final bool isUserMessage;

  const TappableText({Key? key, required this.text, required this.isUserMessage}) : super(key: key);

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
                  color: isUserMessage ? CupertinoColors.white : CupertinoColors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTooltipContent(String word, bool isStarred, StateSetter setState) {
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