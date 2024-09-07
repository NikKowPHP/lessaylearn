// lib/features/learn/presentation/deck_detail_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/presentation/study_session_screen.dart';
import 'package:lessay_learn/features/learn/presentation/widgets/flashcard_list_item.dart';
import 'package:lessay_learn/features/learn/providers/flashcard_provider.dart';

class DeckDetailScreen extends ConsumerWidget {
  final DeckModel deck;

  const DeckDetailScreen({Key? key, required this.deck}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flashcardsAsyncValue = ref.watch(flashcardsForDeckProvider(deck.id));

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(deck.name),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                deck.description,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            CupertinoButton.filled(
              child: const Text('Start Study Session'),
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => StudySessionScreen(deck: deck),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: flashcardsAsyncValue.when(
                data: (flashcards) => ListView.builder(
                  itemCount: flashcards.length,
                  itemBuilder: (context, index) => FlashcardListItem(flashcard: flashcards[index]),
                ),
                loading: () => const Center(child: CupertinoActivityIndicator()),
                error: (error, stackTrace) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}