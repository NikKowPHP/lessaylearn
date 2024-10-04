import 'package:flutter/cupertino.dart';

import 'package:lessay_learn/core/models/favorite_model.dart';
import 'package:lessay_learn/core/models/known_word_model.dart';

import 'package:lessay_learn/features/chat/models/message_model.dart';

import 'package:lessay_learn/features/chat/widgets/message_bubble/bubble_wing_painter.dart';
import 'package:lessay_learn/features/chat/widgets/message_bubble/tappable_text.dart';

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

