// lib/features/learn/presentation/deck_detail_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/models/flashcard_model.dart';
import 'package:lessay_learn/features/learn/presentation/screens/study_session_screen.dart';
import 'package:lessay_learn/features/learn/presentation/widgets/flashcard_list_item.dart';
import 'package:lessay_learn/features/learn/providers/flashcard_provider.dart';
import 'package:go_router/go_router.dart';


class DeckDetailScreen extends ConsumerWidget {
  final String deckId;

  const DeckDetailScreen({Key? key, required this.deckId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deckAsyncValue = ref.watch(deckByIdProvider(deckId));
    final flashcardsAsyncValue = ref.watch(flashcardsForDeckProvider(deckId));

    return deckAsyncValue.when(
      data: (deck) => _buildDeckDetail(context, ref, deck, flashcardsAsyncValue),
      loading: () => const CupertinoPageScaffold(
        child: Center(child: CupertinoActivityIndicator()),
      ),
      error: (error, _) => CupertinoPageScaffold(
        child: Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildDeckDetail(BuildContext context, WidgetRef ref, DeckModel deck, AsyncValue<List<FlashcardModel>> flashcardsAsyncValue) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(deck.name),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildDeckInfo(deck),
            _buildStudyButton(context, ref, deck),
            _buildFlashcardList(flashcardsAsyncValue),
          ],
        ),
      ),
    );
  }

  Widget _buildDeckInfo(DeckModel deck) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(deck.description, style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          Text('Last studied: ${_formatDate(deck.lastStudied)}'),
          Text('Cards: ${deck.cardCount}'),
        ],
      ),
    );
  }

 Widget _buildStudyButton(BuildContext context, WidgetRef ref, DeckModel deck) {
    final flashcardStatusAsyncValue = ref.watch(flashcardStatusProvider(deck.id));

    return flashcardStatusAsyncValue.when(
      data: (flashcardStatus) {
        final newCount = flashcardStatus['new']?.length ?? 0;
        final learnCount = flashcardStatus['learn']?.length ?? 0;
        final reviewCount = flashcardStatus['review']?.length ?? 0;
        final totalCount = newCount + learnCount + reviewCount;

        return CupertinoButton.filled(
          child: Text('Study Now ($totalCount cards)'),
          onPressed: totalCount > 0 ? () => _startStudySession(context, deck.id) : null,
        );
      },
      loading: () => CupertinoActivityIndicator(),
      error: (_, __) => Text('Error loading flashcards'),
    );
  }

  void _startStudySession(BuildContext context, String deckId) {
    context.push('/study-session/$deckId');
  }

  Widget _buildFlashcardList(
      AsyncValue<List<FlashcardModel>> flashcardsAsyncValue) {
    return Expanded(
      child: flashcardsAsyncValue.when(
        data: (flashcards) => ListView.builder(
          itemCount: flashcards.length,
          itemBuilder: (context, index) =>
              FlashcardListItem(flashcard: flashcards[index]),
        ),
        loading: () => Center(child: CupertinoActivityIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }
}
