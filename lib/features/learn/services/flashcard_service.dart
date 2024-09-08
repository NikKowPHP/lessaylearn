// lib/features/learn/services/flashcard_service.dart
import 'package:lessay_learn/core/SRSA/engine/srsa_algoritm.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/models/flashcard_model.dart';
import 'package:lessay_learn/features/learn/services/i_flashcard_service.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';

class FlashcardService implements IFlashcardService {
  final ILocalStorageService localStorageService;

  FlashcardService(this.localStorageService);

  @override
  Future<List<DeckModel>> getDecks() async {
    final savedDecks = await localStorageService.getDecks();
    return savedDecks.isNotEmpty ? savedDecks : _getMockDecks();
  }

  @override
  Future<List<FlashcardModel>> getFlashcardsForDeck(String deckId) async {
    final savedFlashcards = await localStorageService.getFlashcardsForDeck(deckId);
    return savedFlashcards.isNotEmpty ? savedFlashcards : _getMockFlashcards(deckId);
  }

  @override
  Future<void> addDeck(DeckModel deck) async {
    await localStorageService.addDeck(deck);
  }
 @override
  Future<void> addFlashcard(FlashcardModel flashcard) async {
    await localStorageService.addFlashcard(flashcard);
  }

  @override
  Future<void> updateFlashcard(FlashcardModel flashcard) async {
    await localStorageService.updateFlashcard(flashcard);
  }

  @override
  Future<void> deleteDeck(String deckId) async {
    await localStorageService.deleteDeck(deckId); 
    // deleteDeck() in LocalStorageService already handles deleting associated flashcards
  }
  @override
  Future<void> deleteFlashcard(String flashcardId) async {
    await localStorageService.deleteFlashcard(flashcardId);
  }

  List<DeckModel> _getMockDecks() {
    return [
      DeckModel(
        id: '1',
        name: 'Spanish Basics',
        description: 'Learn the fundamentals of Spanish grammar and vocabulary.',
        cardCount: 50,
        lastStudied: DateTime.now().subtract(Duration(days: 2)),
        languageLevel: 'Beginner',
        sourceLanguage: 'English',
        targetLanguage: 'Spanish',
      ),
      DeckModel(
        id: '2',
        name: 'French Verbs',
        description: 'Master the most common French verbs and their conjugations.',
        cardCount: 100,
        lastStudied: DateTime.now().subtract(Duration(days: 5)),
        languageLevel: 'Intermediate',
        sourceLanguage: 'English',
        targetLanguage: 'French',
      ),
      // Add more mock decks as needed...
    ];
  }

  List<FlashcardModel> _getMockFlashcards(String deckId) {
    if (deckId == '1') { // Spanish Basics
      return [
        FlashcardModel(
          id: '1',
          deckId: deckId,
          front: 'Hola',
          back: 'Hello',
          nextReview: DateTime.now().add(Duration(days: 1)),
          interval: 1,
          easeFactor: 2.5,
        ),
        FlashcardModel(
          id: '2',
          deckId: deckId,
          front: 'Adiós',
          back: 'Goodbye',
          nextReview: DateTime.now().add(Duration(days: 3)),
          interval: 3,
          easeFactor: 2.8,
        ),
        // Add more flashcards for Spanish Basics...
      ];
    } else if (deckId == '2') { // French Verbs
      return [
        FlashcardModel(
          id: '3',
          deckId: deckId,
          front: 'Être',
          back: 'To be',
          nextReview: DateTime.now().add(Duration(days: 2)),
          interval: 2,
          easeFactor: 2.6,
        ),
        FlashcardModel(
          id: '4',
          deckId: deckId,
          front: 'Avoir',
          back: 'To have',
          nextReview: DateTime.now().add(Duration(days: 4)),
          interval: 4,
          easeFactor: 2.9,
        ),
        // Add more flashcards for French Verbs...
      ];
    } else {
      return []; // Return an empty list if the deckId is not recognized
    }
  }
   Future<List<FlashcardModel>> getAllFlashcards() async {
    final allDecks = await getDecks();
    final allFlashcards = <FlashcardModel>[];
    
    for (final deck in allDecks) {
      final flashcardsForDeck = await getFlashcardsForDeck(deck.id);
      allFlashcards.addAll(flashcardsForDeck);
    }
    
    return allFlashcards;
  }
   Future<void> reviewFlashcard(FlashcardModel flashcard, int quality) async {
    final updatedFlashcard = SRSAlgorithm.processReview(flashcard, quality);
    await updateFlashcard(updatedFlashcard);
  }

  Future<List<FlashcardModel>> getDueFlashcards() async {
    final allFlashcards = await getAllFlashcards();
    final now = DateTime.now();
    return allFlashcards.where((card) => card.nextReview.isBefore(now)).toList();
  }
}
