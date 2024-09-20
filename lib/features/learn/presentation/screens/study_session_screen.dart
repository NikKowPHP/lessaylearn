import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/providers/tts_provider.dart';
import 'package:lessay_learn/features/learn/models/flashcard_model.dart';
import 'package:lessay_learn/features/learn/providers/flashcard_provider.dart';
import 'package:go_router/go_router.dart';

class StudySessionScreen extends ConsumerStatefulWidget {
 final String deckId;
  const StudySessionScreen({Key? key, required this.deckId}) : super(key: key);

  @override
  _StudySessionScreenState createState() => _StudySessionScreenState();
}

class _StudySessionScreenState extends ConsumerState<StudySessionScreen> {
  int _currentIndex = 0;
  bool _showAnswer = false;
  List<FlashcardModel> _dueFlashcards = [];

  @override
  void initState() {
    super.initState();
    _loadDueFlashcards();
  }
 Future<void> _loadDueFlashcards() async {
    final flashcards = await ref
        .read(flashcardProvider.notifier)
        .getDueFlashcardsForDeck(widget.deckId);
    setState(() {
      _dueFlashcards = flashcards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Study Session'),
      ),
      child: SafeArea(
        child: _buildStudySession(_dueFlashcards),
      ),
    );
  }

  Widget _buildStudySession(List<FlashcardModel> flashcards) {
    if (flashcards.isEmpty) {
      return const Center(child: Text('No flashcards available'));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Center the column vertically
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
                mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
                children: [
                  Text(
                    flashcards[_currentIndex].front,
                    style: const TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  CupertinoButton(
  child: const Icon(CupertinoIcons.volume_up),
  onPressed: () async {
    try {
      final ttsService = ref.read(ttsServiceProvider);
      await ttsService.speak(flashcards[_currentIndex].front, 'en'); // Replace 'en' with the target language code
    } catch (e) {
      debugPrint("Failed to use TTS: $e");
      // Optionally show an error message to the user
    }
  },
),
                  if (_showAnswer) _buildCustomSeparator(), // Use custom separator
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


 void _endSession() async {
    await ref.read(flashcardNotifierProvider.notifier).updateDeckProgress(widget.deckId);
    // Refresh the flashcard state
    ref.refresh(flashcardsForDeckProvider(widget.deckId));
    ref.refresh(flashcardStatusProvider(widget.deckId));
    // Use GoRouter to pop the route
    GoRouter.of(context).pop();
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
            Navigator.of(dialogContext).pop(); 
            _endSession(); 
          },
          ),
        ],
      ),
    ),
  );
}
}
