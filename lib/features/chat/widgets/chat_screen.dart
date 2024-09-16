import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/dependency_injection.dart';
import 'package:lessay_learn/core/models/favorite_model.dart';
import 'package:lessay_learn/core/models/known_word_model.dart';
import 'package:lessay_learn/core/providers/favorite_repository_provider.dart';
import 'package:lessay_learn/core/providers/known_word_repository_provider.dart';
import 'package:lessay_learn/core/services/favorite_service.dart';
import 'package:lessay_learn/core/services/known_word_service.dart';
import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/features/chat/models/message_model.dart';
import 'package:lessay_learn/core/providers/chat_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/features/home/providers/current_user_provider.dart';
import 'package:lessay_learn/features/profile/widgets/avatar_widget.dart';
import 'package:flutter/material.dart' show TooltipTriggerMode;

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
  final FocusNode _rootFocusNode = FocusNode();
  List<FavoriteModel> _favorites = [];
  List<KnownWordModel> _knownWords = [];

  final KnownWordService _knownWordService = getIt<KnownWordService>();
  final FavoriteService _favoriteService = getIt<FavoriteService>();

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _loadChatPartner();
    _loadFavoritesAndKnownWords();
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
  Future<void> _loadFavoritesAndKnownWords() async {
    final favoriteService = ref.read(favoriteServiceProvider);
    final knownWordService = ref.read(knownWordServiceProvider);

    final favorites = await favoriteService.getFavorites();
    final knownWords = await knownWordService.getKnownWords();

    if (mounted) {
      setState(() {
        _favorites = favorites;
        _knownWords = knownWords;
      });
    }
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
    return GestureDetector(
      onTap: () {
        _rootFocusNode.requestFocus();
        // Close all tooltips
        for (var message in _messages) {
          if (message is TappableText) {
            for (var controller
                in (message as _TappableTextState)._tooltipControllers) {
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
                _buildMessageInput(),
              ],
            ),
          ),
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
              favorites: _favorites,
              knownWords: _knownWords,
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
    _rootFocusNode.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final String currentUserId;
  final bool isLastInSequence;
  final List<FavoriteModel> favorites;
  final List<KnownWordModel> knownWords;
  const MessageBubble({
    Key? key,
    required this.message,
    required this.currentUserId,
    required this.isLastInSequence,
    required this.favorites,
    required this.knownWords,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUserMessage = message.senderId == currentUserId;

    debugPrint('Message sender ID: ${message.senderId}');
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
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
                  bottomLeft: Radius.circular(
                      isUserMessage || !isLastInSequence ? 16 : 4),
                  bottomRight: Radius.circular(
                      isUserMessage && isLastInSequence ? 4 : 16),
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 64),
                    child: TappableText(
                        text: message.content,
                        isUserMessage: isUserMessage,
                        favorites: favorites,
                        knownWords: knownWords),
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
                size: 16,
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

class TappableText extends ConsumerStatefulWidget {
   final String text;
  final bool isUserMessage;
  final List<FavoriteModel> favorites;
  final List<KnownWordModel> knownWords;

  const TappableText({
    Key? key,
    required this.text,
    required this.isUserMessage,
    required this.favorites,
    required this.knownWords,
  }) : super(key: key);

  @override
  ConsumerState<TappableText> createState() => _TappableTextState();
}

class _TappableTextState extends ConsumerState<TappableText> {
  final List<JustTheController> _tooltipControllers = [];
  final KnownWordService _knownWordService = getIt<KnownWordService>();
  final FavoriteService _favoriteService = getIt<FavoriteService>();

  @override
  void initState() {
    super.initState();
    _tooltipControllers.addAll(
      widget.text.split(' ').map((_) => JustTheController()),
    );
  }

  @override
  void dispose() {
    for (var controller in _tooltipControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final words = widget.text.split(' ');
    return Wrap(
      children: words.asMap().entries.map((entry) {
        final index = entry.key;
        final word = entry.value;
        return _buildTappableWord(word, index);
      }).toList(),
    );
  }

  Widget _buildTappableWord(String word, int index) {
  final isFavorite = widget.favorites.any((favorite) => favorite.sourceText == word);
  final isKnown = widget.knownWords.any((knownWord) => knownWord.word == word);

  return GestureDetector(
    onTap: () {
      if (!isKnown) {
        _makeWordKnown(word);
      }
      _tooltipControllers[index].showTooltip();
    },
    child: JustTheTooltip(
      controller: _tooltipControllers[index],
      preferredDirection: AxisDirection.up,
      tailLength: 10.0,
      tailBaseWidth: 20.0,
      backgroundColor: CupertinoColors.systemBackground,
      content: _buildTooltipContent(word, isFavorite),
      triggerMode: TooltipTriggerMode.manual,
       isModal: true, 
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: _getHighlightColor(isKnown, isFavorite),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            word,
            style: TextStyle(
              color: widget.isUserMessage
                  ? CupertinoColors.white
                  : CupertinoColors.black,
              fontWeight: isKnown ? FontWeight.bold : FontWeight.normal,
              decoration: isFavorite ? TextDecoration.underline : TextDecoration.none,
            ),
          ),
        ),
      ),
    ),
  );
}

Color _getHighlightColor(bool isKnown, bool isFavorite) {
  if (!isKnown) {
    return CupertinoColors.systemYellow.withOpacity(0.3);
  } else if (isFavorite) {
    return widget.isUserMessage
        ? CupertinoColors.systemPink.withOpacity(0.3)  // Different color for current user's favorites
        : CupertinoColors.systemBlue.withOpacity(0.3); // Slight blue for other user's favorites
  } else {
    return CupertinoColors.transparent;
  }
}
  Widget _buildTooltipContent(String word, bool isFavorite) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(word),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () => _toggleFavorite(word, isFavorite),
                child: Icon(
                  isFavorite ? CupertinoIcons.star_fill : CupertinoIcons.star,
                  color: CupertinoColors.activeBlue,
                  size: 20,
                ),
              ),
            ],
          ),
        );
      },
    );
  }



    Future<void> _makeWordKnown(String word) async {
    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser == null) return;

    if (!widget.knownWords.any((knownWord) => knownWord.word == word)) {
      setState(() {
        widget.knownWords.add(KnownWordModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: currentUser.id,
          word: word,
          language: 'en', // Replace with actual language
        ));
      });

      final newKnownWord = KnownWordModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: currentUser.id,
        word: word,
        language: 'en', // Replace with actual language
      );
      await _knownWordService.addKnownWord(newKnownWord);
    }
  }

  Future<void> _toggleFavorite(String word, bool isFavorite) async {
    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser == null) return;

    setState(() {
      if (isFavorite) {
        widget.favorites.removeWhere((favorite) => favorite.sourceText == word);
      } else {
        widget.favorites.add(FavoriteModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: currentUser.id,
          sourceText: word,
          translatedText: '', // You might want to add translation functionality
          sourceLanguage: 'en', // Replace with actual source language
          targetLanguage: 'es', // Replace with actual target language
        ));
      }
    });

    if (isFavorite) {
      await _favoriteService.removeFavorite(word);
    } else {
      final newFavorite = FavoriteModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: currentUser.id,
        sourceText: word,
        translatedText: '', // You might want to add translation functionality
        sourceLanguage: 'en', // Replace with actual source language
        targetLanguage: 'es', // Replace with actual target language
      );
      await _favoriteService.addFavorite(newFavorite);
    }
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
