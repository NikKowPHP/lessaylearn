import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/dependency_injection.dart';
import 'package:lessay_learn/core/models/favorite_model.dart';
import 'package:lessay_learn/core/models/known_word_model.dart';
import 'package:lessay_learn/core/providers/favorite_provider.dart';
import 'package:lessay_learn/core/providers/known_word_provider.dart';
import 'package:lessay_learn/core/services/favorite_service.dart';
import 'package:lessay_learn/core/services/known_word_service.dart';
import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/features/chat/models/message_model.dart';
import 'package:lessay_learn/core/providers/chat_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/features/chat/widgets/message_bubble/bubble_wing_painter.dart';
import 'package:lessay_learn/features/chat/widgets/message_bubble/message_bubble.dart';
import 'package:lessay_learn/features/chat/widgets/message_bubble/tappable_text.dart';
// import 'package:lessay_learn/features/home/providers/current_user_provider.dart';

import 'package:lessay_learn/features/profile/widgets/avatar_widget.dart';
import 'package:lessay_learn/core/providers/user_provider.dart';
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

  UserModel? _chatPartner;
  final FocusNode _rootFocusNode = FocusNode();

  bool _hasMarkedAsRead = false;

  @override
  void initState() {
    super.initState();
    _loadChatPartner();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _markPartnerMessagesAsRead();
    });
    _scrollToBottom();
  }

  // Add this method
  void _markPartnerMessagesAsRead() {
    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser != null) {
      ref
          .read(messagesProvider(widget.chat.id).notifier)
          .markPartnerMessagesAsRead(currentUser.id);
    }
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
    final messages = ref.watch(messagesProvider(widget.chat.id));
    final currentUser = ref.watch(currentUserProvider).value;

    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;

    // MESSAGES LISTENER (Corrected)
    ref.listen<AsyncValue<MessageModel>>(
      messageStreamProvider(widget.chat.id),
      (_, next) {
        next.whenData((message) {
          if (message.senderId != currentUser?.id) {
            // Use the watched currentUser
            ref
                .read(messagesProvider(widget.chat.id).notifier)
                .addMessage(message);
            _markPartnerMessagesAsRead();
            // _scrollToBottom();  Remove this here – scrolling is handled below
          }
        });
      },
    );

    ref.watch(messagesProvider(widget.chat.id)); // No need for AsyncValue
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (messages.isNotEmpty) {
        // Only scroll if there are messages
        _scrollToBottom();
      }
    });

    return GestureDetector(
      onTap: () {
        _rootFocusNode.requestFocus();
        // Close all tooltips
        for (var message in messages) {
          if (message is TappableText) {
            for (var controller
                in (message as TappableTextState).tooltipControllers) {
              controller.hideTooltip();
            }
          }
        }
      },
      child: CupertinoPageScaffold(
        navigationBar: isWideScreen ? null : _buildNavigationBar(),
        child: SafeArea(
          child: Focus(
            focusNode: _rootFocusNode,
            child: Column(
              children: [
                Expanded(child: _buildMessageList()),
                _buildTypingIndicator(widget.chat.id),
                _buildMessageInput(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(String chatId) {
    return Consumer(
      builder: (context, ref, child) {
        final typingIndicatorAsyncValue =
            ref.watch(typingIndicatorStreamProvider(chatId));

        return typingIndicatorAsyncValue.when(
          data: (isTyping) {
            return isTyping
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: Text('Partner is typing...')),
                  )
                : const SizedBox.shrink();
          },
          loading: () => const Center(child: SizedBox.shrink()),
          error: (error, stackTrace) => Text('Error: $error'),
        );
      },
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
                    isNetworkImage: false,
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
    final messages = ref.watch(messagesProvider(widget.chat.id));
    final currentUser = ref.watch(currentUserProvider).value;

    return CupertinoScrollbar(
      controller: _scrollController,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          final isLastInSequence = index == messages.length - 1 ||
              messages[index + 1].senderId != message.senderId;

          return MessageBubble(
            message: message,
            currentUserId: currentUser!.id,
            favorites: ref.watch(favoritesProvider),
            knownWords: ref.watch(knownWordsProvider),
            isLastInSequence: isLastInSequence,
          );
        },
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
              onChanged: (text) {
                if (text.isNotEmpty && !_hasMarkedAsRead) {
                  // Mark all messages as read when typing starts
                  final currentUser = ref.read(currentUserProvider).value;
                  if (currentUser != null) {
                    ref
                        .read(messagesProvider(widget.chat.id).notifier)
                        .markAllAsRead(currentUser.id);
                  }

                  setState(() {
                    _hasMarkedAsRead = true;
                  });
                }
              },
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
      _messageController.clear();
     await ref
          .read(messagesProvider(widget.chat.id).notifier)
          .sendMessage(newMessage);

      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _rootFocusNode.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
