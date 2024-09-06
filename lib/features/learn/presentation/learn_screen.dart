import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Learn'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.plus),
          onPressed: () {
            // TODO: Implement add new deck functionality
          },
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoSearchTextField(
                placeholder: 'Search decks',
                onChanged: (value) {
                  // TODO: Implement search functionality
                },
              ),
            ),
            Expanded(
              child: DeckList(),
            ),
          ],
        ),
      ),
    );
  }
}

class DeckList extends StatelessWidget {
  final List<Deck> decks = [
    Deck(name: 'Spanish Vocabulary', cardCount: 100, dueCount: 20),
    Deck(name: 'French Phrases', cardCount: 75, dueCount: 15),
    Deck(name: 'German Grammar', cardCount: 50, dueCount: 10),
    // Add more decks as needed
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: decks.length,
      separatorBuilder: (context, index) => Divider(height: 1),
      itemBuilder: (context, index) {
        return DeckListItem(deck: decks[index]);
      },
    );
  }
}

class DeckListItem extends StatelessWidget {
  final Deck deck;

  const DeckListItem({Key? key, required this.deck}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      title: Text(deck.name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('${deck.cardCount} cards • ${deck.dueCount} due'),
      trailing: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Icon(CupertinoIcons.right_chevron),
        onPressed: () {
          context.push('/flashcards/${deck.name}');
        },
      ),
      onTap: () {
        context.push('/flashcards/${deck.name}');
      },
    );
  }
}

class Deck {
  final String name;
  final int cardCount;
  final int dueCount;

  Deck({required this.name, required this.cardCount, required this.dueCount});
}

// Placeholder for the Flashcards screen
class FlashcardsScreen extends StatelessWidget {
  final String deckName;

  const FlashcardsScreen({Key? key, required this.deckName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(deckName),
      ),
      child: Center(
        child: Text('Flashcards for $deckName'),
      ),
    );
  }
}