// lib/features/learn/presentation/widgets/deck_list_item.dart
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/presentation/deck_detail_screen.dart';

class DeckListItem extends StatelessWidget {
  final DeckModel deck;
  final VoidCallback onTap;

  const DeckListItem({Key? key, required this.deck, required this.onTap})
      : super(key: key);

 @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      leading: Icon(CupertinoIcons.book),
      title: Text(deck.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${deck.cardCount} cards'),
          Text('Last studied: ${_formatDate(deck.lastStudied)}'),
        ],
      ),
      trailing: CupertinoListTileChevron(),
      onTap: onTap,
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
