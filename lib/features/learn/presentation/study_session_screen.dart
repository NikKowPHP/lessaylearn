import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/models/flashcard_model.dart';
import 'package:lessay_learn/features/learn/providers/flashcard_provider.dart';

class StudySessionScreen extends ConsumerStatefulWidget {
 final List<FlashcardModel> flashcards;
  const StudySessionScreen({Key? key, required this.flashcards}) : super(key: key);



  @override
  _StudySessionScreenState createState() => _StudySessionScreenState();
}

class _StudySessionScreenState extends ConsumerState<StudySessionScreen> {
  int _currentIndex = 0;
  bool _showAnswer = false;
  late List<FlashcardModel> _dueFlashcards;

 @override
  void initState() {
    super.initState();
    _dueFlashcards = widget.flashcards;
  }
  // Future<void> _loadDueFlashcards() async {
  //   final flashcards = await ref
  //       .read(flashcardProvider.notifier)
  //       .getDueFlashcardsForDeck(widget.deck.id);
  //   setState(() {
  //     _dueFlashcards = flashcards;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Study Session'),
      ),
      child: SafeArea(
        child: _buildStudySession(widget.flashcards),
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
                _showAnswer
                    ? flashcards[_currentIndex].back
                    : flashcards[_currentIndex].front,
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
              // Update the CupertinoButton onPressed callbacks:
              CupertinoButton(
                child: const Text('Again'),
                onPressed: () => _answerCard(0),
              ),
              CupertinoButton(
                child: const Text('Hard'),
                onPressed: () => _answerCard(1),
              ),
              CupertinoButton(
                child: const Text('Good'),
                onPressed: () => _answerCard(2),
              ),
              CupertinoButton(
                child: const Text('Easy'),
                onPressed: () => _answerCard(3),
              ),
            ],
          ),
      ],
    );
  }

void _answerCard(int answerQuality) {
  final flashcard = _dueFlashcards[_currentIndex];
  ref.read(flashcardProvider.notifier).reviewFlashcard(flashcard, answerQuality);

  setState(() {
    _showAnswer = false;
    if (_currentIndex < _dueFlashcards.length - 1) {
      _currentIndex++;
    } else {
      _showSessionSummary();
    }
  });
}


  FlashcardModel _updateFlashcard(FlashcardModel flashcard, int answerQuality) {
    // Implement spaced repetition algorithm (e.g., SuperMemo 2) here
    // This is a simplified version
    final newInterval = (flashcard.interval * flashcard.easeFactor).round();
    final newEaseFactor = flashcard.easeFactor +
        (0.1 - (5 - answerQuality) * (0.08 + (5 - answerQuality) * 0.02));
    return flashcard.copyWith(
      interval: newInterval,
      easeFactor: newEaseFactor.clamp(1.3, 2.5),
      nextReview: DateTime.now().add(Duration(days: newInterval)),
    );
  }

void _endSession(BuildContext dialogContext) async {
  if (widget.flashcards.isNotEmpty) {
    String deckId = widget.flashcards.first.deckId;
    await ref.read(flashcardNotifierProvider.notifier).updateDeckProgress(deckId);
  }
  Navigator.pop(dialogContext); // Close the dialog
  Navigator.pop(context); // Pop the navigator to the previous page
}

void _showSessionSummary() {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) => Builder(
      builder: (BuildContext dialogContext) => CupertinoAlertDialog(
        title: Text('Session Complete'),
        content: Text('You have reviewed all due cards in this deck.'),
        actions: [
          CupertinoDialogAction(
            child: Text('OK'),
            onPressed: () {
              _endSession(dialogContext);
            },
          ),
        ],
      ),
    ),
  );
}
}
