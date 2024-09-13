import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/features/learn/models/flashcard_model.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';

class MockStorageService {
  static final List<UserModel> _users = [
    UserModel(
      id: 'user1',
      name: 'Alice',
      avatarUrl: 'https://example.com/alice.jpg',
      languageLevel: 'Intermediate',
      sourceLanguage: 'English',
      targetLanguage: 'Spanish',
      location: 'New York',
      age: 28,
    ),
    UserModel(
      id: 'user2',
      name: 'Bob',
      avatarUrl: 'https://example.com/bob.jpg',
      languageLevel: 'Beginner',
      sourceLanguage: 'English',
      targetLanguage: 'French',
      location: 'London',
      age: 32,
    ),
  ];

  static final List<ChatModel> _chats = [
    ChatModel(
      id: 'chat1',
      hostUserId: 'user1',
      guestUserId: 'user2',
      lastMessage: 'Hola! ¿Cómo estás?',
      lastMessageTimestamp: DateTime.now().subtract(Duration(minutes: 5)),
      chatTopic: 'Spanish Conversation',
      languageLevel: 'Intermediate',
      sourceLanguage: 'English',
      targetLanguage: 'Spanish',
    ),
    ChatModel(
      id: 'chat2',
      hostUserId: 'user2',
      guestUserId: 'user1',
      lastMessage: 'Bonjour! Comment allez-vous?',
      lastMessageTimestamp: DateTime.now().subtract(Duration(hours: 1)),
      chatTopic: 'French Basics',
      languageLevel: 'Beginner',
      sourceLanguage: 'English',
      targetLanguage: 'French',
    ),
  ];

  static final List<DeckModel> _decks = [
  DeckModel(
    id: 'deck1',
    name: 'Spanish Vocabulary',
    description: 'Basic Spanish words and phrases',
    cardCount: 2,
    lastStudied: DateTime.now().subtract(Duration(days: 1)),
    languageLevel: 'Beginner',
    sourceLanguage: 'English',
    targetLanguage: 'Spanish',
  ),
  DeckModel(
    id: 'deck2',
    name: 'French Verbs',
    description: 'Common French verbs and conjugations',
    cardCount: 2,
    lastStudied: DateTime.now().subtract(Duration(days: 3)),
    languageLevel: 'Intermediate',
    sourceLanguage: 'English',
    targetLanguage: 'French',
  ),
];

  static final List<FlashcardModel> _flashcards = [
    FlashcardModel(
      id: 'card1',
      deckId: 'deck1',
      front: 'Hello',
      back: 'Hola',
      nextReview: DateTime.now().add(Duration(days: 1)),
      interval: 1,
    ),
    FlashcardModel(
      id: 'card2',
      deckId: 'deck1',
      front: 'Goodbye',
      back: 'Adiós',
      nextReview: DateTime.now().add(Duration(days: 2)),
      interval: 2,
    ),
    FlashcardModel(
      id: 'card3',
      deckId: 'deck2',
      front: 'To be',
      back: 'Être',
      nextReview: DateTime.now().add(Duration(days: 1)),
      interval: 1,
    ),
    FlashcardModel(
      id: 'card4',
      deckId: 'deck2',
      front: 'To have',
      back: 'Avoir',
      nextReview: DateTime.now().add(Duration(days: 3)),
      interval: 3,
    ),
  ];

  // Methods to access mock data
  static List<UserModel> getUsers() => _users;
  static List<ChatModel> getChats() => _chats;
  static List<DeckModel> getDecks() => _decks;
  static List<FlashcardModel> getFlashcards() => _flashcards;

}
