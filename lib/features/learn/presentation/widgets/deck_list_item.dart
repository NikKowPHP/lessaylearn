// lib/features/learn/presentation/widgets/deck_list_item.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/providers/flashcard_provider.dart';

class DeckListItem extends ConsumerWidget {
  final DeckModel deck;
  final VoidCallback onTap;

  const DeckListItem({Key? key, required this.deck, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flashcardsAsyncValue = ref.watch(flashcardsForDeckProvider(deck.id));
    debugPrint('flashcards $flashcardsAsyncValue');
    return flashcardsAsyncValue.when(
      data: (flashcards) {
        final newCount = flashcards.where((f) => f.repetitions == 0).length;
        debugPrint('new cards $newCount');
        final reviewCount = flashcards.where((f) => f.repetitions > 0 && f.interval > 1 && f.nextReview.isBefore(DateTime.now())).length;
        final learnCount = flashcards.where((f) => f.repetitions > 0 && f.interval <= 1).length;

        return CupertinoListTile(
          title: Text(deck.name),
          subtitle: Text(deck.description),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCountIndicator(newCount, CupertinoColors.activeBlue),
              SizedBox(width: 4),
              _buildCountIndicator(learnCount, CupertinoColors.destructiveRed),
              SizedBox(width: 4),
              _buildCountIndicator(reviewCount, CupertinoColors.activeGreen),
            ],
          ),
          onTap: onTap,
        );
      },
      loading: () => CupertinoListTile(title: Text(deck.name), trailing: CupertinoActivityIndicator()),
      error: (_, __) => CupertinoListTile(title: Text(deck.name), trailing: Icon(CupertinoIcons.exclamationmark_triangle)),
    );
  }

  Widget _buildCountIndicator(int count, Color color) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          count.toString(),
          style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
 String _formatDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }
  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
