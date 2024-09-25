// lib/features/learn/presentation/widgets/deck_list_item.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/providers/deck_provider.dart';


class DeckListItem extends ConsumerWidget {
  final DeckModel deck;
  final VoidCallback onTap;

  const DeckListItem({Key? key, required this.deck, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dueCountsAsyncValue = ref.watch(dueFlashcardCountsProvider(deck.id));

    return dueCountsAsyncValue.when(
      data: (dueCounts) {
        final newCount = dueCounts['new'] ?? 0;
        final learnCount = dueCounts['learn'] ?? 0;
        final reviewCount = dueCounts['review'] ?? 0;

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
 
}
