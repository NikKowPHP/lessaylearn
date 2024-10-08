import 'package:lessay_learn/core/models/comment_model.dart';
import 'package:lessay_learn/core/models/favorite_model.dart';
import 'package:lessay_learn/core/models/known_word_model.dart';
import 'package:lessay_learn/core/models/language_model.dart';
import 'package:lessay_learn/core/models/user_language_model.dart';
import 'package:lessay_learn/core/models/like_model.dart';
import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/features/chat/models/message_model.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/models/flashcard_model.dart';
import 'package:lessay_learn/features/profile/models/profile_picture_model.dart';
import 'package:lessay_learn/features/statistics/models/chart_model.dart';
import 'package:lessay_learn/features/voicer/models/recording_model.dart';

class MockStorageService {
  static final List<UserModel> _users = [
    UserModel(
      id: 'user1',
      name: 'Alice',
      avatarUrl: 'assets/avatar-1.png',
      email: 'alice@example.com',
      languageLevel: 'Intermediate',
      sourceLanguageIds: ['lang_en'],
      targetLanguageIds: ['lang_es'],
      spokenLanguageIds: ['lang_en', 'lang_es'],
      location: 'New York',
      age: 28,
      bio: 'Language enthusiast and travel lover',
      interests: ['Reading', 'Cooking', 'Hiking'],
      occupation: 'Software Developer',
      education: 'Bachelor in Computer Science',
      languageIds: ['lang_en', 'lang_es'],
      profilePictureIds: ['pic1', 'pic2'],
    ),
    UserModel(
      id: 'user2',
      email: 'bob@example.com',
      name: 'Bob',
      avatarUrl: 'assets/avatar-2.png',
      languageLevel: 'Beginner',
      sourceLanguageIds: ['lang_en'],
      targetLanguageIds: ['lang_fr', 'lang_ja'],
      spokenLanguageIds: ['lang_en', 'lang_fr'],
      location: 'London',
      age: 32,
      bio: 'Aspiring polyglot and coffee addict',
      interests: ['Coffee', 'Photography', 'Yoga'],
      occupation: 'Marketing Manager',
      education: 'MBA',
      languageIds: ['lang_en', 'lang_fr', 'lang_ja'],
      profilePictureIds: ['pic3', 'pic4'],
    ),
    UserModel(
      id: 'user3',
      name: 'Charlie',
      email: 'bob@example.com',
      avatarUrl: 'assets/avatar-3.png',
      languageLevel: 'Advanced',
      sourceLanguageIds: ['lang_en', 'lang_fr'],
      targetLanguageIds: ['lang_es', 'lang_it'],
      spokenLanguageIds: ['lang_en', 'lang_fr', 'lang_es'],
      location: 'Madrid',
      age: 25,
      bio: 'Passionate about languages and cultures',
      interests: ['Traveling', 'Dancing', 'Cooking'],
      occupation: 'Teacher',
      education: 'Master in Education',
      languageIds: ['lang_en', 'lang_fr', 'lang_es', 'lang_it'],
      profilePictureIds: ['pic5', 'pic6'],
    ),
    UserModel(
      id: 'user4',
      name: 'Diana',
      email: 'alice@example.com',
      avatarUrl: 'assets/avatar-4.png',
      languageLevel: 'Advanced',
      sourceLanguageIds: ['lang_en', 'lang_de'],
      targetLanguageIds: ['lang_fr', 'lang_zh'],
      spokenLanguageIds: ['lang_en', 'lang_de', 'lang_fr', 'lang_it'],
      location: 'Paris',
      age: 30,
      bio: 'Language lover and art enthusiast',
      interests: ['Painting', 'Museums', 'Wine tasting'],
      occupation: 'Art Curator',
      education: 'PhD in Art History',
      languageIds: ['lang_en', 'lang_de', 'lang_fr', 'lang_zh'],
      profilePictureIds: ['pic7', 'pic8'],
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
      sourceLanguageId: 'lang_en',
      targetLanguageId: 'lang_es',
      isAi: false,
    ),
    ChatModel(
      id: 'chat2',
      hostUserId: 'user2',
      guestUserId: 'user1',
      lastMessage: 'Bonjour! Comment allez-vous?',
      lastMessageTimestamp: DateTime.now().subtract(Duration(hours: 1)),
      chatTopic: 'French Basics',
      languageLevel: 'Beginner',
      sourceLanguageId: 'lang_en',
      targetLanguageId: 'lang_fr',
      isAi: false,
    ),
    ChatModel(
      id: 'chat3',
      hostUserId: 'user3',
      guestUserId: 'user1',
      lastMessage: 'Hola! ¿Cómo estás?',
      lastMessageTimestamp: DateTime.now().subtract(Duration(minutes: 5)),
      chatTopic: 'Spanish Conversation',
      languageLevel: 'Intermediate',
      sourceLanguageId: 'lang_en',
      targetLanguageId: 'lang_es',
      isAi: true,
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
      sourceLanguageId: 'lang_en',
      targetLanguageId: 'lang_es',
    ),
    DeckModel(
      id: 'deck2',
      name: 'French Verbs',
      description: 'Common French verbs and conjugations',
      cardCount: 2,
      lastStudied: DateTime.now().subtract(Duration(days: 3)),
      languageLevel: 'Intermediate',
      sourceLanguageId: 'lang_en',
      targetLanguageId: 'lang_fr',
    ),
  ];

  static final List<FlashcardModel> _flashcards = [
    FlashcardModel(
      id: 'card1',
      deckId: 'deck1',
      front: 'Hello',
      back: 'Hola',
      nextReview: DateTime.now(),
      interval: 1,
      easeFactor: 2.5,
      repetitions: 0,
    ),
    FlashcardModel(
      id: 'card2',
      deckId: 'deck1',
      front: 'Goodbye',
      back: 'Adiós',
      nextReview: DateTime.now(),
      interval: 2,
      easeFactor: 2.5,
      repetitions: 1,
    ),
    FlashcardModel(
      id: 'card3',
      deckId: 'deck2',
      front: 'To be',
      back: 'Être',
      nextReview: DateTime.now(),
      interval: 1,
      easeFactor: 2.5,
      repetitions: 0,
    ),
    FlashcardModel(
      id: 'card4',
      deckId: 'deck2',
      front: 'To have',
      back: 'Avoir',
      nextReview: DateTime.now(),
      interval: 3,
      easeFactor: 2.5,
      repetitions: 1,
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

  static final List<ProfilePictureModel> _profilePictures = [
    ProfilePictureModel(
      id: 'pic1',
      userId: 'user1',
      base64Image: 'assets/avatar-1.png',
      likeIds: ['like1', 'like2'],
      commentIds: ['comment1', 'comment2'],
    ),
    ProfilePictureModel(
      id: 'pic2',
      userId: 'user1',
      base64Image: 'assets/avatar-1.png',
      likeIds: [],
      commentIds: [],
    ),
    ProfilePictureModel(
      id: 'pic3',
      userId: 'user2',
      base64Image: 'assets/avatar-2.png',
      likeIds: ['like3'],
      commentIds: ['comment3'],
    ),
    ProfilePictureModel(
      id: 'pic4',
      userId: 'user2',
      base64Image: 'assets/avatar-2.png',
      likeIds: [],
      commentIds: [],
    ),
    ProfilePictureModel(
      id: 'pic5',
      userId: 'user3',
      base64Image: 'assets/avatar-3.png',
      likeIds: ['like4', 'like5'],
      commentIds: ['comment4', 'comment5'],
    ),
    ProfilePictureModel(
      id: 'pic6',
      userId: 'user3',
      base64Image: 'assets/avatar-3.png',
      likeIds: [],
      commentIds: [],
    ),
    ProfilePictureModel(
      id: 'pic7',
      userId: 'user4',
      base64Image: 'assets/avatar-4.png',
      likeIds: ['like6', 'like7'],
      commentIds: ['comment6', 'comment7'],
    ),
    ProfilePictureModel(
      id: 'pic8',
      userId: 'user4',
      base64Image: 'assets/avatar-4.png',
      likeIds: [],
      commentIds: [],
    ),
  ];

  static final List<LikeModel> _likes = [
    LikeModel(id: 'like1', userId: 'user2', toId: 'pic1'),
    LikeModel(id: 'like2', userId: 'user3', toId: 'pic1'),
    LikeModel(id: 'like3', userId: 'user1', toId: 'pic3'),
    LikeModel(id: 'like4', userId: 'user2', toId: 'pic5'),
    LikeModel(id: 'like5', userId: 'user4', toId: 'pic5'),
    LikeModel(id: 'like6', userId: 'user1', toId: 'pic7'),
    LikeModel(id: 'like7', userId: 'user3', toId: 'pic7'),
  ];

  static final List<CommentModel> _comments = [
    CommentModel(
        id: 'comment1',
        userId: 'user2',
        toId: 'pic1',
        content: 'Great picture!'),
    CommentModel(
        id: 'comment2', userId: 'user3', toId: 'pic1', content: 'Love this!'),
    CommentModel(
        id: 'comment3', userId: 'user1', toId: 'pic3', content: 'Nice avatar!'),
    CommentModel(
        id: 'comment4', userId: 'user2', toId: 'pic5', content: 'Cool!'),
    CommentModel(
        id: 'comment5', userId: 'user4', toId: 'pic5', content: 'Awesome!'),
    CommentModel(
        id: 'comment6', userId: 'user1', toId: 'pic7', content: 'Beautiful!'),
    CommentModel(
        id: 'comment7', userId: 'user3', toId: 'pic7', content: 'Amazing!'),
  ];

  static final List<KnownWordModel> _knownWords = [
    KnownWordModel(
        id: 'kw1', userId: 'user1', word: 'bonjour', language: 'lang_en'),
    KnownWordModel(
        id: 'kw2', userId: 'user1', word: 'merci', language: 'lang_es'),
    KnownWordModel(
        id: 'kw3', userId: 'user2', word: 'hola', language: 'lang_es'),
    KnownWordModel(
        id: 'kw4', userId: 'user2', word: 'gracias', language: 'lang_en'),
  ];

  static final List<FavoriteModel> _favorites = [
    FavoriteModel(
      id: 'fav1',
      userId: 'user1',
      sourceText: 'Hello',
      translatedText: 'Hola',
      sourceLanguageId: 'lang_en', // Updated to 'lang_en'
      targetLanguageId: 'lang_es',
    ),
    FavoriteModel(
      id: 'fav2',
      userId: 'user2',
      sourceText: 'Goodbye',
      translatedText: 'Adiós',
      sourceLanguageId: 'lang_es', // Updated to 'lang_en'
      targetLanguageId: 'lang_en',
    ),
    FavoriteModel(
      id: 'fav3',
      userId: 'user1',
      sourceText: 'Thank you',
      translatedText: 'Merci',
      sourceLanguageId: 'lang_es', // Updated to 'lang_en'
      targetLanguageId: 'lang_en',
    ),
  ];
  static List<LanguageModel> getGenericLanguages() {
    return [
      LanguageModel(
          id: 'lang_en',
          name: 'English',
          shortcut: 'en',
          emoji: '🇬🇧',
          asciiShortcut: 'en_US'),
      LanguageModel(
          id: 'lang_es',
          name: 'Spanish',
          shortcut: 'es',
          emoji: '🇪🇸',
          asciiShortcut: 'es_ES'),
      LanguageModel(
          id: 'lang_fr',
          name: 'French',
          shortcut: 'fr',
          emoji: '🇫🇷',
          asciiShortcut: 'fr_FR'),
      LanguageModel(
          id: 'lang_de',
          name: 'German',
          shortcut: 'de',
          emoji: '🇩🇪',
          asciiShortcut: 'de_DE'),
      LanguageModel(
          id: 'lang_it',
          name: 'Italian',
          shortcut: 'it',
          emoji: '🇮🇹',
          asciiShortcut: 'it_IT'),
      LanguageModel(
          id: 'lang_pt',
          name: 'Portuguese',
          shortcut: 'pt',
          emoji: '🇧🇷',
          asciiShortcut: 'pt_BR'),
      LanguageModel(
          id: 'lang_ru',
          name: 'Russian',
          shortcut: 'ru',
          emoji: '🇷🇺',
          asciiShortcut: 'ru_RU'),
      LanguageModel(
          id: 'lang_zh',
          name: 'Chinese',
          shortcut: 'zh',
          emoji: '🇨🇳',
          asciiShortcut: 'zh_CN'),
      LanguageModel(
          id: 'lang_ja',
          name: 'Japanese',
          shortcut: 'ja',
          emoji: '🇯🇵',
          asciiShortcut: 'ja_JP'),
      LanguageModel(
          id: 'lang_ko',
          name: 'Korean',
          shortcut: 'ko',
          emoji: '🇰🇷',
          asciiShortcut: 'ko_KR'),
      LanguageModel(
          id: 'lang_ar',
          name: 'Arabic',
          shortcut: 'ar',
          emoji: '🇸🇦',
          asciiShortcut: 'ar_SA'),
      LanguageModel(
          id: 'lang_hi',
          name: 'Hindi',
          shortcut: 'hi',
          emoji: '🇮🇳',
          asciiShortcut: 'hi_IN'),
      LanguageModel(
          id: 'lang_tr',
          name: 'Turkish',
          shortcut: 'tr',
          emoji: '🇹🇷',
          asciiShortcut: 'tr_TR'),
      LanguageModel(
          id: 'lang_nl',
          name: 'Dutch',
          shortcut: 'nl',
          emoji: '🇳🇱',
          asciiShortcut: 'nl_NL'),
      LanguageModel(
          id: 'lang_sv',
          name: 'Swedish',
          shortcut: 'sv',
          emoji: '🇸🇪',
          asciiShortcut: 'sv_SE'),
      LanguageModel(
          id: 'lang_no',
          name: 'Norwegian',
          shortcut: 'no',
          emoji: '🇳🇴',
          asciiShortcut: 'no_NO'),
      LanguageModel(
          id: 'lang_da',
          name: 'Danish',
          shortcut: 'da',
          emoji: '🇩🇰',
          asciiShortcut: 'da_DK'),
      LanguageModel(
          id: 'lang_fi',
          name: 'Finnish',
          shortcut: 'fi',
          emoji: '🇫🇮',
          asciiShortcut: 'fi_FI'),
      LanguageModel(
          id: 'lang_el',
          name: 'Greek',
          shortcut: 'el',
          emoji: '🇬🇷',
          asciiShortcut: 'el_GR'),
      LanguageModel(
          id: 'lang_he',
          name: 'Hebrew',
          shortcut: 'he',
          emoji: '🇮🇱',
          asciiShortcut: 'he_IL'),
      LanguageModel(
          id: 'lang_th',
          name: 'Thai',
          shortcut: 'th',
          emoji: '🇹🇭',
          asciiShortcut: 'th_TH'),
      LanguageModel(
          id: 'lang_vi',
          name: 'Vietnamese',
          shortcut: 'vi',
          emoji: '🇻🇳',
          asciiShortcut: 'vi_VN'),
      LanguageModel(
          id: 'lang_id',
          name: 'Indonesian',
          shortcut: 'id',
          emoji: '🇮🇩',
          asciiShortcut: 'id_ID'),
      LanguageModel(
          id: 'lang_ms',
          name: 'Malay',
          shortcut: 'ms',
          emoji: '🇲🇾',
          asciiShortcut: 'ms_MY'),
      LanguageModel(
          id: 'lang_cz',
          name: 'Czech',
          shortcut: 'cs',
          emoji: '🇨🇿',
          asciiShortcut: 'cs_CZ'),
      LanguageModel(
          id: 'lang_hu',
          name: 'Hungarian',
          shortcut: 'hu',
          emoji: '🇭🇺',
          asciiShortcut: 'hu_HU'),
      LanguageModel(
          id: 'lang_sk',
          name: 'Slovak',
          shortcut: 'sk',
          emoji: '🇸🇰',
          asciiShortcut: 'sk_SK'),
      LanguageModel(
          id: 'lang_ro',
          name: 'Romanian',
          shortcut: 'ro',
          emoji: '🇷🇴',
          asciiShortcut: 'ro_RO'),
      LanguageModel(
          id: 'lang_bg',
          name: 'Bulgarian',
          shortcut: 'bg',
          emoji: '🇧🇬',
          asciiShortcut: 'bg_BG'),
      LanguageModel(
          id: 'lang_sr',
          name: 'Serbian',
          shortcut: 'sr',
          emoji: '🇷🇸',
          asciiShortcut: 'sr_RS'),
      LanguageModel(
          id: 'lang_sl',
          name: 'Slovenian',
          shortcut: 'sl',
          emoji: '🇸🇮',
          asciiShortcut: 'sl_SI'),
      LanguageModel(
          id: 'lang_lt',
          name: 'Lithuanian',
          shortcut: 'lt',
          emoji: '🇱🇹',
          asciiShortcut: 'lt_LT'),
      LanguageModel(
          id: 'lang_lv',
          name: 'Latvian',
          shortcut: 'lv',
          emoji: '🇱🇻',
          asciiShortcut: 'lv_LV'),
      LanguageModel(
          id: 'lang_et',
          name: 'Estonian',
          shortcut: 'et',
          emoji: '🇪🇪',
          asciiShortcut: 'et_EE'),
    ];
  }

  static final List<UserLanguage> _languages = [
    UserLanguage(
      id: 'lang_en', // todo: should be autogenerated
      userId: 'user1',
      languageId: 'lang_en',
      name: 'English',
      shortcut: 'en',
      timestamp: DateTime.now(),
      level: 'Advanced',
      score: 900,
    ),
    UserLanguage(
      id: 'lang_fr',
      userId: 'user1',
      languageId: 'lang_en',
      name: 'French',
      shortcut: 'fr',
      timestamp: DateTime.now(),
      level: 'Intermediate',
      score: 750,
    ),
    UserLanguage(
      id: 'lang_es',
      userId: 'user2',
      languageId: 'lang_en',
      name: 'Spanish',
      shortcut: 'es',
      timestamp: DateTime.now(),
      level: 'Beginner',
      score: 300,
    ),
    UserLanguage(
      id: 'lang_de',
      userId: 'user2',
      languageId: 'lang_en',
      name: 'German',
      shortcut: 'de',
      timestamp: DateTime.now(),
      level: 'Intermediate',
      score: 600,
    ),
    UserLanguage(
      id: 'lang_it',
      userId: 'user3',
      languageId: 'lang_en',
      name: 'Italian',
      shortcut: 'it',
      timestamp: DateTime.now(),
      level: 'Advanced',
      score: 850,
    ),
    UserLanguage(
      id: 'lang_ja',
      userId: 'user3',
      languageId: 'lang_en',
      name: 'Japanese',
      shortcut: 'ja',
      timestamp: DateTime.now(),
      level: 'Beginner',
      score: 200,
    ),
    UserLanguage(
      id: 'lang_zh',
      userId: 'user4',
      languageId: 'lang_en',
      name: 'Chinese',
      shortcut: 'zh',
      timestamp: DateTime.now(),
      level: 'Intermediate',
      score: 500,
    ),
  ];

  static final List<ChartModel> charts = [
    ChartModel(
      id: 'chart1',
      userId: 'user1',
      languageId: 'lang_en',
      reading: 0.7,
      writing: 0.6,
      speaking: 0.5,
      listening: 0.8,
    ),
    ChartModel(
      id: 'chart2',
      userId: 'user1',
      languageId: 'lang_fr',
      reading: 0.5,
      writing: 0.4,
      speaking: 0.3,
      listening: 0.6,
    ),
    ChartModel(
      id: 'chart3',
      userId: 'user1',
      languageId: 'lang_es',
      reading: 0.3,
      writing: 0.2,
      speaking: 0.4,
      listening: 0.5,
    ),
    ChartModel(
      id: 'chart4',
      userId: 'user1',
      languageId: 'lang_fr',
      reading: 0.6,
      writing: 0.5,
      speaking: 0.7,
      listening: 0.8,
    ),
    ChartModel(
      id: 'chart5',
      userId: 'user3',
      languageId: 'lang_it',
      reading: 0.8,
      writing: 0.7,
      speaking: 0.9,
      listening: 0.8,
    ),
    ChartModel(
      id: 'chart6',
      userId: 'user3',
      languageId: 'lang_ja',
      reading: 0.2,
      writing: 0.1,
      speaking: 0.3,
      listening: 0.4,
    ),
    ChartModel(
      id: 'chart7',
      userId: 'user4',
      languageId: 'lang_zh',
      reading: 0.5,
      writing: 0.4,
      speaking: 0.6,
      listening: 0.7,
    ),
  ];

  static final List<RecordingModel> _recordings = [
    RecordingModel(
      userId: 'user1',
      languageId: 'lang_en',
      audioPath: 'assets/recordings/recording1.m4a',
      createdAt: DateTime.now().subtract(Duration(days: 1)),
      durationInSeconds: 120,
      transcription: 'This is a sample transcription for recording 1.',
    ),
    RecordingModel(
      userId: 'user1',
      languageId: 'lang_es',
      audioPath: 'assets/recordings/recording2.m4a',
      createdAt: DateTime.now().subtract(Duration(days: 2)),
      durationInSeconds: 150,
      transcription:
          'Esta es una transcripción de ejemplo para la grabación 2.',
    ),
    RecordingModel(
      userId: 'user1',
      languageId: 'lang_fr',
      audioPath: 'assets/recordings/recording3.m4a',
      createdAt: DateTime.now().subtract(Duration(days: 3)),
      durationInSeconds: 90,
      transcription:
          'Ceci est une transcription d\'exemple pour l\'enregistrement 3.',
    ),
  ];

  // Methods to access mock data
  static List<RecordingModel> getRecordings() => _recordings;
  static List<UserModel> getUsers() => _users;
  static List<ChatModel> getChats() => _chats;
  static List<DeckModel> getDecks() => _decks;
  static List<FlashcardModel> getFlashcards() => _flashcards;
  static List<UserLanguage> getLanguages() => _languages;
  static List<MessageModel> getMessages() => _messages;
  static List<ProfilePictureModel> getProfilePictures() => _profilePictures;
  static List<LikeModel> getLikes() => _likes;
  static List<CommentModel> getComments() => _comments;
  static List<KnownWordModel> getKnownWords() => _knownWords;
  static List<FavoriteModel> getFavorites() => _favorites;

  static List<MessageModel> getMessagesForChat(String chatId) {
    return _messages.where((message) => message.chatId == chatId).toList();
  }

  static List<ChartModel> getCharts() => charts;
}
