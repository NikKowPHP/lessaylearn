import 'package:lessay_learn/core/models/language_model.dart';
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
      avatarUrl: 'assets/avatar-1.png',
      languageLevel: 'Intermediate',
      sourceLanguageIds: ['lang_en'], // Updated to use language IDs
      targetLanguageIds: ['lang_es'], // Updated to use language IDs
      spokenLanguageIds: ['lang_en', 'lang_es'], // Updated to use language IDs
      location: 'New York',
      age: 28,
      bio: 'Language enthusiast and travel lover',
      interests: ['Reading', 'Cooking', 'Hiking'],
      occupation: 'Software Developer',
      education: 'Bachelor in Computer Science',
      languageIds: ['lang_en', 'lang_es'], // Updated to use language IDs
    ),
    UserModel(
      id: 'user2',
      name: 'Bob',
      avatarUrl: 'assets/avatar-2.png',
      languageLevel: 'Beginner',
      sourceLanguageIds: ['lang_en'], // Updated to use language IDs
      targetLanguageIds: ['lang_fr', 'lang_ja'], // Updated to use language IDs
      spokenLanguageIds: ['lang_en', 'lang_fr'], // Updated to use language IDs
      location: 'London',
      age: 32,
      bio: 'Aspiring polyglot and coffee addict',
      interests: ['Coffee', 'Photography', 'Yoga'],
      occupation: 'Marketing Manager',
      education: 'MBA',
      languageIds: ['lang_en', 'lang_fr', 'lang_ja'], // Updated to use language IDs
    ),
    UserModel(
      id: 'user3',
      name: 'Charlie',
      avatarUrl: 'assets/avatar-3.png',
      languageLevel: 'Advanced',
      sourceLanguageIds: ['lang_en', 'lang_fr'], // Updated to use language IDs
      targetLanguageIds: ['lang_es', 'lang_it'], // Updated to use language IDs
      spokenLanguageIds: ['lang_en', 'lang_fr', 'lang_es'], // Updated to use language IDs
      location: 'Madrid',
      age: 25,
      bio: 'Passionate about languages and cultures',
      interests: ['Traveling', 'Dancing', 'Cooking'],
      occupation: 'Teacher',
      education: 'Master in Education',
      languageIds: ['lang_en', 'lang_fr', 'lang_es', 'lang_it'], // Updated to use language IDs
    ),
    UserModel(
      id: 'user4',
      name: 'Diana',
      avatarUrl: 'assets/avatar-4.png',
      languageLevel: 'Advanced',
      sourceLanguageIds: ['lang_en', 'lang_de'], // Updated to use language IDs
      targetLanguageIds: ['lang_fr', 'lang_zh'], // Updated to use language IDs
      spokenLanguageIds: ['lang_en', 'lang_de', 'lang_fr', 'lang_it'], // Updated to use language IDs
      location: 'Paris',
      age: 30,
      bio: 'Language lover and art enthusiast',
      interests: ['Painting', 'Museums', 'Wine tasting'],
      occupation: 'Art Curator',
      education: 'PhD in Art History',
      languageIds: ['lang_en', 'lang_de', 'lang_fr', 'lang_zh'], // Updated to use language IDs
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
    ChatModel(
      id: 'chat3',
      hostUserId: 'user3',
      guestUserId: 'user1',
      lastMessage: 'Hola! ¿Cómo estás?',
      lastMessageTimestamp: DateTime.now().subtract(Duration(minutes: 5)),
      chatTopic: 'Spanish Conversation',
      languageLevel: 'Intermediate',
      sourceLanguage: 'English',
      targetLanguage: 'Spanish',
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



  static final List<LanguageModel> _languages = [
    LanguageModel(
      id: 'lang_en',
      userId: 'user1', // Associate with user1
      name: 'English',
      shortcut: 'EN',
      timestamp: DateTime.now(),
      level: 'Advanced',
      score: 85,
    ),
    LanguageModel(
      id: 'lang_es',
      userId: 'user1', // Associate with user1
      name: 'Spanish',
      shortcut: 'ES',
      timestamp: DateTime.now(),
      level: 'Intermediate',
      score: 70,
    ),
    LanguageModel(
      id: 'lang_fr',
      userId: 'user2', // Associate with user2
      name: 'French',
      shortcut: 'FR',
      timestamp: DateTime.now(),
      level: 'Beginner',
      score: 50,
    ),
    LanguageModel(
      id: 'lang_de',
      userId: 'user4', // Associate with user4
      name: 'German',
      shortcut: 'DE',
      timestamp: DateTime.now(),
      level: 'Advanced',
      score: 90,
    ),
    LanguageModel(
      id: 'lang_ja',
      userId: 'user2', // Associate with user2
      name: 'Japanese',
      shortcut: 'JA',
      timestamp: DateTime.now(),
      level: 'Beginner',
      score: 40,
    ),
    LanguageModel(
      id: 'lang_it',
      userId: 'user3', // Associate with user3
      name: 'Italian',
      shortcut: 'IT',
      timestamp: DateTime.now(),
      level: 'Intermediate',
      score: 65,
    ),
    LanguageModel(
      id: 'lang_zh',
      userId: 'user4', // Associate with user4
      name: 'Chinese',
      shortcut: 'ZH',
      timestamp: DateTime.now(),
      level: 'Beginner',
      score: 30,
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
  MessageModel(
    id: 'msg5',
    chatId: 'chat3',
    senderId: 'user3',
    receiverId: 'user1',
    content: 'Hola! ¿Cómo estás?',
    timestamp: DateTime.now().subtract(Duration(minutes: 5)),
    isRead: true,
  ),
  MessageModel(
    id: 'msg6',
    chatId: 'chat3',
    senderId: 'user1',
    receiverId: 'user3',
    content: 'Bien, gracias. ¿Y tú?',
    timestamp: DateTime.now().subtract(Duration(minutes: 4)),
    isRead: true,
  ),
];


  // Methods to access mock data
  static List<UserModel> getUsers() => _users;
  static List<ChatModel> getChats() => _chats;
  static List<DeckModel> getDecks() => _decks;
  static List<FlashcardModel> getFlashcards() => _flashcards;
  static List<LanguageModel> getLanguages() => _languages;

    static List<MessageModel> getMessages() => _messages;

  static List<MessageModel> getMessagesForChat(String chatId) {
    return _messages.where((message) => message.chatId == chatId).toList();
  }

}
