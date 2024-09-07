
// lib/features/learn/presentation/widgets/deck_list_item.dart
import 'package:flutter/cupertino.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/presentation/deck_detail_screen.dart';

class DeckListItem extends StatelessWidget {
  final DeckModel deck;

  const DeckListItem({Key? key, required this.deck}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      leading: const Icon(CupertinoIcons.book),
      title: Text(deck.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${deck.cardCount} cards'),
          const SizedBox(height: 4),
          Row(
            children: [
              _buildTag(deck.languageLevel, CupertinoColors.activeBlue),
              const SizedBox(width: 8),
              _buildTag('${deck.sourceLanguage} → ${deck.targetLanguage}', CupertinoColors.activeGreen),
            ],
          ),
        ],
      ),
      trailing: const CupertinoListTileChevron(),
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => DeckDetailScreen(deck: deck),
          ),
        );
      },
    );
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