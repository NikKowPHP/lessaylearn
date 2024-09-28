import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/providers/tts_provider.dart';
import 'package:lessay_learn/features/learn/models/flashcard_model.dart';
import 'package:lessay_learn/features/learn/providers/deck_provider.dart';
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
        .read(flashcardNotifierProvider.notifier)
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
      mainAxisAlignment:
          MainAxisAlignment.center, // Center the column vertically
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
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center the content vertically
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
                        await ttsService.speak(flashcards[_currentIndex].front,
                            'en'); // Replace 'en' with the target language code
                      } catch (e) {
                        debugPrint("Failed to use TTS: $e");
                        // Optionally show an error message to the user
                      }
                    },
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
          _buildAnswerButtons(),
     
      ],
    );
  }
Widget _buildAnswerButtons() {
  if (!_showAnswer) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: CupertinoButton.filled(
          child: const Text('Show Answer'),
          onPressed: () {
            setState(() {
              _showAnswer = true;
            });
          },
        ),
      ),
    );
  }

 return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildAnswerButton('Again', const Color(0xFFEF5350), () => _answerCard(0)),
        _buildAnswerButton('Hard', const Color(0xFFFFC107), () => _answerCard(1)),
        _buildAnswerButton('Good', const Color(0xFF66BB6A), () => _answerCard(2)),
        _buildAnswerButton('Easy', const Color(0xFF42A5F5), () => _answerCard(3)),
      ],
    ),
  );
}

Widget _buildAnswerButton(String label, Color color, VoidCallback onPressed) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: CupertinoButton(
        padding: EdgeInsets.all(8),
        color: color,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: CupertinoColors.white),
          ),
        ),
        onPressed: onPressed,
      ),
    ),
  );
}
  Widget _buildCustomSeparator() {
    return Container(
      height: 1.0,
      color: CupertinoColors.systemGrey, // Custom color for the separator
      margin: const EdgeInsets.symmetric(vertical: 10.0), // Margin for spacing
    );
  }

  void _answerCard(int answerQuality) async {
    final flashcard = _dueFlashcards[_currentIndex];
    final updatedFlashcard = await ref
        .read(flashcardNotifierProvider.notifier)
        .reviewFlashcard(flashcard, answerQuality);

    setState(() {
      _showAnswer = false;
      if (answerQuality == 0) {
        // For 'Again' responses, move the card to the end of the queue
        _dueFlashcards.removeAt(_currentIndex);
        _dueFlashcards.add(updatedFlashcard);
      } else {
        // For other responses, remove the card from the queue
        _dueFlashcards.removeAt(_currentIndex);
      }

      if (_dueFlashcards.isEmpty) {
        _showSessionSummary();
      } else if (_currentIndex >= _dueFlashcards.length) {
        _currentIndex = 0;
      }
    });
  }

  void _endSession() async {
    await ref
        .read(flashcardNotifierProvider.notifier)
        .updateDeckProgress(widget.deckId);
    // Refresh the flashcard state
    ref.invalidate(flashcardsForDeckProvider(widget.deckId));
    ref.invalidate(flashcardStatusProvider(widget.deckId));
    ref.invalidate(dueFlashcardCountsProvider(widget.deckId));
    ref.invalidate(dueFlashcardCountProvider(widget.deckId));

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
