import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
              child: Column(
                children: [
                  Text(
                    flashcards[_currentIndex].front,
                    style: const TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  if (_showAnswer)
                    _buildCustomSeparator(), // Use custom separator
                  if (_showAnswer)
                    Text(
                      flashcards[_currentIndex].back, // Show translation
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  
                ],
              ),
            ),
          ),
        ),
        
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (_showAnswer) // Show the answer variants only if _showAnswer is true
                ...[
                  CupertinoButton(
                    child: const Text('Again'),
                    color: const Color(0xFFEF5350), // Anki red color
                    onPressed: () => _answerCard(0),
                  ),
                  CupertinoButton(
                    child: const Text('Hard'),
                    color: const Color(0xFFFFC107), // Anki yellow color
                    onPressed: () => _answerCard(1),
                  ),
                  CupertinoButton(
                    child: const Text('Good'),
                    color: const Color(0xFF66BB6A), // Anki green color
                    onPressed: () => _answerCard(2),
                  ),
                  CupertinoButton(
                    child: const Text('Easy'),
                    color: const Color(0xFF42A5F5), // Anki blue color
                    onPressed: () => _answerCard(3),
                  ),
                ],
              if (!_showAnswer) // Show the button only if _showAnswer is false
                CupertinoButton(
                  child: const Text('Show Answer'),
                  onPressed: () {
                    setState(() {
                      _showAnswer = true;
                    });
                  },
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildCustomSeparator() {
    return Container(
      height: 1.0,
      color: CupertinoColors.systemGrey, // Custom color for the separator
      margin: const EdgeInsets.symmetric(vertical: 10.0), // Margin for spacing
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



void _endSession(BuildContext dialogContext) async {
  if (widget.flashcards.isNotEmpty) {
    String deckId = widget.flashcards.first.deckId;
    await ref.read(flashcardNotifierProvider.notifier).updateDeckProgress(deckId);
     // Refresh the flashcard state
    ref.refresh(flashcardsForDeckProvider(deckId));
    ref.refresh(flashcardStatusProvider(deckId));
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
