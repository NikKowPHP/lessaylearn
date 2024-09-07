import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/models/flashcard_model.dart';
import 'package:lessay_learn/features/learn/providers/flashcard_provider.dart';

class StudySessionScreen extends ConsumerStatefulWidget {
  final DeckModel deck;
  const StudySessionScreen({Key? key, required this.deck}) : super(key: key);

  @override
  _StudySessionScreenState createState() => _StudySessionScreenState();
}

class _StudySessionScreenState extends ConsumerState<StudySessionScreen> {
  int _currentIndex = 0;
  bool _showAnswer = false;

  @override
  Widget build(BuildContext context) {
    final flashcardsAsyncValue = ref.watch(flashcardsForDeckProvider(widget.deck.id));

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Studying ${widget.deck.name}'),
      ),
      child: SafeArea(
        child: flashcardsAsyncValue.when(
          data: (flashcards) => _buildStudySession(flashcards),
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  Widget _buildStudySession(List<FlashcardModel> flashcards) {
    if (flashcards.isEmpty) {
      return const Center(child: Text('No flashcards available'));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _showAnswer = !_showAnswer;
              });
            },
            child: Center(
              child: Text(
                _showAnswer ? flashcards[_currentIndex].back : flashcards[_currentIndex].front,
                style: const TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        if (_showAnswer)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CupertinoButton(
                child: const Text('Again'),
                onPressed: () => _answerCard(flashcards, 0),
              ),
              CupertinoButton(
                child: const Text('Hard'),
                onPressed: () => _answerCard(flashcards, 1),
              ),
              CupertinoButton(
                child: const Text('Good'),
                onPressed: () => _answerCard(flashcards, 2),
              ),
              CupertinoButton(
                child: const Text('Easy'),
                onPressed: () => _answerCard(flashcards, 3),
              ),
            ],
          ),
      ],
    );
  }

  void _answerCard(List<FlashcardModel> flashcards, int answerQuality) {
    final flashcard = flashcards[_currentIndex];
    final updatedFlashcard = _updateFlashcard(flashcard, answerQuality);
    ref.read(flashcardProvider.notifier).updateFlashcard(updatedFlashcard);
    setState(() {
      _showAnswer = false;
      _currentIndex = (_currentIndex + 1) % flashcards.length;
    });
  }

  FlashcardModel _updateFlashcard(FlashcardModel flashcard, int answerQuality) {
    // Implement spaced repetition algorithm (e.g., SuperMemo 2) here
    // This is a simplified version
    final newInterval = (flashcard.interval * flashcard.easeFactor).round();
    final newEaseFactor = flashcard.easeFactor + (0.1 - (5 - answerQuality) * (0.08 + (5 - answerQuality) * 0.02));
    return flashcard.copyWith(
      interval: newInterval,
      easeFactor: newEaseFactor.clamp(1.3, 2.5),
      nextReview: DateTime.now().add(Duration(days: newInterval)),
    );
  }
}