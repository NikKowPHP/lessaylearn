
// lib/features/learn/presentation/widgets/flashcard_list_item.dart
import 'package:flutter/cupertino.dart';
import 'package:lessay_learn/features/learn/models/flashcard_model.dart';

class FlashcardListItem extends StatelessWidget {
  final FlashcardModel flashcard;

  const FlashcardListItem({Key? key, required this.flashcard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      title: Text(flashcard.front),
      subtitle: Text('Next review: ${_formatDate(flashcard.nextReview)}'),
      trailing: const CupertinoListTileChevron(),
      onTap: () {
        _showFlashcardDetails(context, flashcard);
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showFlashcardDetails(BuildContext context, FlashcardModel flashcard) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Flashcard Details'),
        message: Column(
          children: [
            Text('Front: ${flashcard.front}'),
            const SizedBox(height: 8),
            Text('Back: ${flashcard.back}'),
          ],
        ),
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Edit'),
            onPressed: () {
              Navigator.pop(context);
              // Implement edit functionality
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Delete'),
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              // Implement delete functionality
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}