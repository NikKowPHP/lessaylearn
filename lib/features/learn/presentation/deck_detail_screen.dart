// lib/features/learn/presentation/deck_detail_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/models/flashcard_model.dart';
import 'package:lessay_learn/features/learn/presentation/study_session_screen.dart';
import 'package:lessay_learn/features/learn/presentation/widgets/flashcard_list_item.dart';
import 'package:lessay_learn/features/learn/providers/flashcard_provider.dart';

class DeckDetailScreen extends ConsumerWidget {
  final DeckModel deck;

  const DeckDetailScreen({Key? key, required this.deck}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flashcardsAsyncValue = ref.watch(flashcardsForDeckProvider(deck.id));
    final dueFlashcardsAsyncValue = ref.watch(dueFlashcardsProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(deck.name),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildDeckInfo(),
            _buildStudyButton(context, ref),
            _buildFlashcardList(flashcardsAsyncValue),
          ],
        ),
      ),
    );
  }

  Widget _buildDeckInfo() {
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

Widget _buildStudyButton(BuildContext context, WidgetRef ref) {
  final flashcardStatusAsyncValue = ref.watch(flashcardStatusProvider(deck.id));

  return flashcardStatusAsyncValue.when(
    data: (flashcardStatus) {
      final newCount = flashcardStatus['new']?.length ?? 0;
      final learnCount = flashcardStatus['learn']?.length ?? 0;
      final reviewCount = flashcardStatus['review']?.length ?? 0;
      final totalCount = newCount + learnCount + reviewCount;

      return CupertinoButton.filled(
        child: Text('Study Now ($totalCount cards)'),
        onPressed: totalCount > 0 ? () => _startStudySession(context, flashcardStatus) : null,
      );
    },
    loading: () => CupertinoActivityIndicator(),
    error: (_, __) => Text('Error loading flashcards'),
  );
}

void _startStudySession(BuildContext context, Map<String, List<FlashcardModel>> flashcardStatus) {
  final allFlashcards = [
    ...?flashcardStatus['new'],
    ...?flashcardStatus['learn'],
    ...?flashcardStatus['review'],
  ];
  Navigator.push(
    context,
    CupertinoPageRoute(
      builder: (context) => StudySessionScreen(flashcards: allFlashcards),
    ),
  );
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
