import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/features/chat/models/message_model.dart';
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


 static final List<MessageModel> _messages = [
  MessageModel(
    id: 'msg1',
    chatId: 'chat1',
    senderId: 'user1',
    receiverId: 'user2',
    content: 'Hola! ¿Cómo estás?',
    timestamp: DateTime.now().subtract(Duration(minutes: 5)),
    isRead: true,
  ),
  MessageModel(
    id: 'msg2',
    chatId: 'chat1',
    senderId: 'user2',
    receiverId: 'user1',
    content: 'Bien, gracias. ¿Y tú?',
    timestamp: DateTime.now().subtract(Duration(minutes: 4)),
    isRead: true,
  ),
  MessageModel(
    id: 'msg3',
    chatId: 'chat2',
    senderId: 'user2',
    receiverId: 'user1',
    content: 'Bonjour! Comment allez-vous?',
    timestamp: DateTime.now().subtract(Duration(hours: 1)),
    isRead: true,
  ),
  MessageModel(
    id: 'msg4',
    chatId: 'chat2',
    senderId: 'user1',
    receiverId: 'user2',
    content: 'Je vais bien, merci. Et vous?',
    timestamp: DateTime.now().subtract(Duration(minutes: 55)),
    isRead: false,
  ),
];

  // Methods to access mock data
  static List<UserModel> getUsers() => _users;
  static List<ChatModel> getChats() => _chats;
  static List<DeckModel> getDecks() => _decks;
  static List<FlashcardModel> getFlashcards() => _flashcards;

    static List<MessageModel> getMessages() => _messages;

  static List<MessageModel> getMessagesForChat(String chatId) {
    return _messages.where((message) => message.chatId == chatId).toList();
  }

}
