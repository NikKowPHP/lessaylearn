import 'package:hive/hive.dart';
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
// import 'package:lessay_learn/services/i_local_storage_service.dart';
import 'package:lessay_learn/services/mock_storage_service.dart';
import 'package:flutter/foundation.dart';

abstract class ILocalStorageService {
  Future<void> addUser(UserModel user);
  Future<bool> isUserLoggedIn();
  Future<void> saveChats(List<ChatModel> chats);
  Future<List<ChatModel>> getChats();
  Future<ChatModel?> getChatById(String chatId);
  Future<void> updateChat(ChatModel chat);
  Future<void> deleteChat(String chatId);
  Future<void> saveMessage(MessageModel message);
  Future<List<MessageModel>> getMessagesForChat(String chatId);
  Future<MessageModel?> getMessageById(String messageId);
  Future<void> updateMessage(MessageModel message);
  Future<void> deleteMessagesForChat(String chatId);
  Future<List<UserModel>> getUsers(); // Add getUsers method
  Future<void> saveUsers(List<UserModel> users); // Add saveUsers method
  // Add the missing methods for flashcards and decks
  Future<List<DeckModel>> getDecks();
  Future<void> addDeck(DeckModel deck);
  Future<void> updateDeck(DeckModel deck);
  Future<void> deleteDeck(String deckId);
  Future<List<FlashcardModel>> getFlashcardsForDeck(String deckId);
  Future<List<FlashcardModel>> getAllFlashcards(); // You might need this
  Future<void> addFlashcard(FlashcardModel flashcard);
  Future<void> updateFlashcard(FlashcardModel flashcard);
  Future<void> deleteFlashcard(String flashcardId);
  Future<bool> hasFlashcards();
  Future<DeckModel?> getDeckById(String deckId);
  Future<void> updateDeckLastStudied(String deckId, DateTime lastStudied);
  Future<void> saveChat(ChatModel chat);
  Future<UserModel?> getUserById(String userId);
  Future<void> clearAllData();
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getCurrentUser();
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(String userId);
  Future<List<UserModel>> getAllUsers();
  Future<void> clearCurrentUser();

  // Known Words methods
  Future<void> saveKnownWord(KnownWordModel knownWord);
  Future<List<KnownWordModel>> getKnownWords();
  Future<void> deleteKnownWord(String knownWordId);

  // Favorites methods
  Future<void> saveFavorite(FavoriteModel favorite);
  Future<List<FavoriteModel>> getFavorites();
  Future<void> deleteFavorite(String favoriteId);
  Future<FavoriteModel?> getFavoriteById(String favoriteId);
  Future<void> updateFavorite(FavoriteModel favorite);
  Future<void> saveCurrentUser(UserModel user);
  // Language methods
  Future<void> saveUserLanguage(UserLanguage language);
  Future<List<UserLanguage>> getUserLanguagesByUserId(String userId);
  Future<UserLanguage?> getUserLanguageById(String languageId);
  Future<void> updateUserLanguage(UserLanguage language);
  Future<void> deleteUserLanguage(String languageId);
  Future<List<UserLanguage>> getUserLanguages();
// Profile Picture methods
  Future<void> saveProfilePicture(ProfilePictureModel picture);
  Future<List<ProfilePictureModel>> getProfilePicturesForUser(String userId);
  Future<ProfilePictureModel?> getProfilePictureById(String pictureId);
  Future<void> deleteProfilePicture(String pictureId);

  // Like methods
  Future<void> saveLike(LikeModel like);
  Future<void> deleteLike(String likeId);
  Future<List<LikeModel>> getLikesForPicture(String pictureId);
  Future<List<LikeModel>> getLikes();
  // Comment methods
  Future<void> saveComment(CommentModel comment);
  Future<void> deleteComment(String commentId);
  Future<List<CommentModel>> getCommentsForPicture(String pictureId);
  Future<List<CommentModel>> getComments();
  // Add these methods to the ILocalStorageService abstract class

  Future<List<ChartModel>> getCharts();
  Future<void> saveChart(ChartModel chart);
  Future<void> updateChart(ChartModel chart);
  Future<void> deleteChart(String chartId);
  Future<List<ChartModel>> getUserCharts(String userId);

  Future<List<FavoriteModel>> getFavoritesByUserAndLanguage(
      String userId, String languageId);
  Future<List<KnownWordModel>> getKnownWordsByUserAndLanguage(
      String userId, String languageId);
  Future<void> saveRecording(RecordingModel recording);
  Future<List<RecordingModel>> getRecordingsForUser(String userId);
  Future<List<RecordingModel>> getRecordingsForUserAndLanguage(
      String userId, String languageId);
  Future<void> deleteRecording(String recordingId);
  Future<void> updateRecording(RecordingModel recording);
  Future<void> saveLanguage(LanguageModel language);
  Future<List<LanguageModel>> getLanguages();
  Future<LanguageModel?> getLanguageById(String languageId);
  Future<void> updateLanguage(LanguageModel language);
  Future<void> deleteLanguage(String languageId);
  Future<void> ensureMockLanguages();
}

class LocalStorageService implements ILocalStorageService {
  static const String _chartsBoxName = 'charts';

  static const String _chatsBoxName = 'chats';
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _messagesBoxName = 'messages';
  static const String _usersBoxName = 'users';
  static const String _decksBoxName = 'decks';
  static const String _flashcardsBoxName = 'flashcards';
  static const String _currentUserKey = 'currentUser';
  static const String _knownWordsBoxName = 'knownWords';
  static const String _favoritesBoxName = 'favorites';
  static const String _userLanguagesBoxName = 'userLanguages';
  static const String _languagesBoxName = 'languages';
  static const String _profilePicturesBoxName = 'profilePictures';
  static const String _likesBoxName = 'likes';
  static const String _commentsBoxName = 'comments';

  static const String _recordingsBoxName = 'recordings';

  Future<Box> _openChartsBox() async {
    return await Hive.openBox(_chartsBoxName);
  }
    Future<Box> _openLanguagesBox() async {
    return await Hive.openBox(_languagesBoxName);
  }

  Future<Box> _openRecordingsBox() async {
    return await Hive.openBox(_recordingsBoxName);
  }

  Future<Box> _openKnownWordsBox() async {
    return await Hive.openBox(_knownWordsBoxName);
  }

  Future<Box> _openUserLanguagesBox() async {
    return await Hive.openBox(_userLanguagesBoxName);
  }

  Future<Box> _openFavoritesBox() async {
    return await Hive.openBox(_favoritesBoxName);
  }

  Future<Box> _openChatsBox() async {
    return await Hive.openBox(_chatsBoxName);
  }

  Future<Box> _openMessagesBox() async {
    return await Hive.openBox(_messagesBoxName);
  }

  Future<Box> _openUsersBox() async {
    return await Hive.openBox(_usersBoxName);
  }

  Future<Box> _openDecksBox() async {
    return await Hive.openBox(_decksBoxName);
  }

  Future<Box> _openFlashcardsBox() async {
    return await Hive.openBox(_flashcardsBoxName);
  }

  Future<Box> _openProfilePicturesBox() async {
    return await Hive.openBox(_profilePicturesBoxName);
  }

  Future<Box> _openLikesBox() async {
    return await Hive.openBox(_likesBoxName);
  }

  Future<Box> _openCommentsBox() async {
    return await Hive.openBox(_commentsBoxName);
  }

  // Map to store opened boxes
  final Map<String, Box> _boxes = {};

  // Method to get or open a box
  Future<Box<T>> _getBox<T>(String boxName) async {
    if (_boxes.containsKey(boxName)) {
      return _boxes[boxName] as Box<T>;
    }
    final box = await Hive.openBox<T>(boxName);
    _boxes[boxName] = box;
    return box;
  }

  @override
  Future<void> saveRecording(RecordingModel recording) async {
    final box = await _openRecordingsBox();
    await box.put(recording.id, recording.toJson());
  }

  @override
  Future<List<RecordingModel>> getRecordingsForUser(String userId) async {
    final box = await _openRecordingsBox();
    return box.values
        .where((json) => json['userId'] == userId)
        .map((json) => RecordingModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<List<RecordingModel>> getRecordingsForUserAndLanguage(
      String userId, String languageId) async {
    final box = await _openRecordingsBox();
    return box.values
        .where((json) =>
            json['userId'] == userId && json['languageId'] == languageId)
        .map((json) => RecordingModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<void> deleteRecording(String recordingId) async {
    final box = await _openRecordingsBox();
    await box.delete(recordingId);
  }

  @override
  Future<void> updateRecording(RecordingModel recording) async {
    final box = await _openRecordingsBox();
    await box.put(recording.id, recording.toJson());
  }

  @override
  Future<List<FavoriteModel>> getFavoritesByUserAndLanguage(
      String userId, String languageId) async {
    final box = await Hive.openBox(_favoritesBoxName);

    // Debug print for the box state
    debugPrint('Total favorites in box: ${box.values.length}');

    // Step 1: Retrieve all favorites from the box
    final allFavorites = box.values
        .map((json) => FavoriteModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();

    // Debug print for all favorites retrieved
    debugPrint('All favorites retrieved: ${allFavorites.length}');
    debugPrint(
        'Favorites details: ${allFavorites.map((fav) => fav.toJson()).toList()}');

    // Step 2: Filter favorites by userId
    final userFavorites =
        allFavorites.where((favorite) => favorite.userId == userId).toList();

    // Debug print for favorites filtered by userId
    debugPrint('Total favorites for user $userId: ${userFavorites.length}');
    debugPrint(
        'User favorites details: ${userFavorites.map((fav) => fav.toJson()).toList()}');

    // Step 3: Apply languageId filter
    final filteredFavorites = userFavorites
        .where((favorite) => favorite.targetLanguageId == languageId)
        .toList();

    // Debug print for favorites filtered by userId and languageId
    debugPrint(
        'Total favorites for user $userId and language $languageId: ${filteredFavorites.length}');
    if (filteredFavorites.isNotEmpty) {
      debugPrint(
          'Filtered favorites: ${filteredFavorites.map((fav) => fav.toJson()).toList()}');
    } else {
      debugPrint(
          'No favorites found for user $userId and language $languageId.');
    }

    return filteredFavorites;
  }

  @override
  Future<List<KnownWordModel>> getKnownWordsByUserAndLanguage(
      String userId, String languageId) async {
    final box = await Hive.openBox(_knownWordsBoxName);
    // Step 1: Retrieve all known words from the box
    final allKnownWords = box.values
        .map((json) => KnownWordModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();

    // Debug print for all known words
    // debugPrint('Total known words retrieved from box: ${allKnownWords.length}');
    // debugPrint('All known words: ${allKnownWords.map((kw) => kw.toJson()).toList()}');

    // Step 2: Filter known words by userId
    final userKnownWords =
        allKnownWords.where((knownWord) => knownWord.userId == userId).toList();

    // Debug print for known words filtered by userId
    // debugPrint('Total known words for user $userId: ${userKnownWords.length}');
    // debugPrint('Known words for user $userId: ${userKnownWords.map((kw) => kw.toJson()).toList()}');

    // Step 3: Apply languageId filter
    final filteredKnownWords = userKnownWords
        .where((knownWord) => knownWord.language == languageId)
        .toList();

    // Debug print for known words filtered by userId and languageId
    // debugPrint('Total known words for user $userId and language $languageId: ${filteredKnownWords.length}');
    if (filteredKnownWords.isNotEmpty) {
      // debugPrint('Filtered known words: ${filteredKnownWords.map((kw) => kw.toJson()).toList()}');
    } else {
      debugPrint(
          'No known words found for user $userId and language $languageId.');
    }

    return filteredKnownWords;
  }

// Known Words methods
  @override
  Future<void> saveKnownWord(KnownWordModel knownWord) async {
    final box = await _openKnownWordsBox();

    // Debug print before saving
    debugPrint(
        'Saving known word: ${knownWord.toJson()} with ID: ${knownWord.id}');

    await box.put(knownWord.id, knownWord.toJson());

    // Debug print after saving
    debugPrint('Known word saved successfully with ID: ${knownWord.id}');
  }

  @override
  Future<List<KnownWordModel>> getKnownWords() async {
    final box = await _openKnownWordsBox();
    return box.values
        .map((json) => KnownWordModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<void> deleteKnownWord(String knownWordId) async {
    final box = await _openKnownWordsBox();
    await box.delete(knownWordId);
  }

  // Favorites methods
  @override
  Future<void> saveFavorite(FavoriteModel favorite) async {
    debugPrint('favorite : $favorite');
    final box = await _openFavoritesBox();
    await box.put(favorite.id, favorite.toJson());
  }

  @override
  Future<List<FavoriteModel>> getFavorites() async {
    final box = await _openFavoritesBox();
    return box.values
        .map((json) => FavoriteModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<void> deleteFavorite(String favoriteId) async {
    final box = await _openFavoritesBox();
    await box.delete(favoriteId);
  }

  @override
  Future<FavoriteModel?> getFavoriteById(String favoriteId) async {
    final box = await _openFavoritesBox();
    final favoriteJson = box.get(favoriteId);
    if (favoriteJson != null) {
      return FavoriteModel.fromJson(Map<String, dynamic>.from(favoriteJson));
    }
    return null;
  }

  @override
  Future<void> saveUserLanguage(UserLanguage language) async {
    final box = await _openUserLanguagesBox();
    await box.put(language.id, language.toJson());
  }

  @override
  Future<List<UserLanguage>> getUserLanguagesByUserId(String userId) async {
    final box = await _openUserLanguagesBox();
    final languages = box.values
        .map((json) => UserLanguage.fromJson(Map<String, dynamic>.from(json)))
        .where((language) => language.userId == userId)
        .toList();
    return languages;
  }

  @override
  Future<UserLanguage?> getUserLanguageById(String languageId) async {
    final box = await _openUserLanguagesBox();
    final languageJson = box.get(languageId);
    return languageJson != null
        ? UserLanguage.fromJson(Map<String, dynamic>.from(languageJson))
        : null;
  }

  @override
  Future<void> updateUserLanguage(UserLanguage language) async {
    final box = await _openUserLanguagesBox();
    if (box.containsKey(language.id)) {
      await box.put(language.id, language.toJson());
    } else {
      throw Exception('Language not found');
    }
  }

  @override
  Future<void> deleteUserLanguage(String languageId) async {
    final box = await _openUserLanguagesBox();
    await box.delete(languageId);
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final box = await _openChatsBox();
    return box.get(_isLoggedInKey, defaultValue: false);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final box = await _openUsersBox();
    final userJson = box.get(_currentUserKey);
    if (userJson != null) {
      return UserModel.fromJson(Map<String, dynamic>.from(userJson));
    }

    return null;
  }

@override
  Future<void> saveCurrentUser(UserModel user) async {
    final box = await _openUsersBox();
    await box.put(_currentUserKey, user.toJson());
  }

  @override
  Future<void> saveChats(List<ChatModel> chats) async {
    if (await isUserLoggedIn()) {
      final box = await _openChatsBox();
      final chatList = chats.map((chat) => chat.toJson()).toList();
      await box.put(_chatsBoxName, chatList);
    }
  }

  @override
  Future<List<ChatModel>> getChats() async {
    await initializeDatabase();
    final box = await _openChatsBox();

    // box.clear();
    //  await box.clear();
    List chatList = box.get(_chatsBoxName, defaultValue: []);

    return chatList
        .map((chat) => ChatModel.fromJson(Map<String, dynamic>.from(chat)))
        .toList();
  }

  @override
  Future<List<UserLanguage>> getUserLanguages() async {
    final box = await _openUserLanguagesBox();

    return box.values
        .map((json) => UserLanguage.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  Future<ChatModel?> getChatById(String chatId) async {
    final box = await _openChatsBox();
    final chatList = box.get(_chatsBoxName, defaultValue: []) as List;

    if (chatList.isEmpty) {
      // If the chat list is empty, populate it with mock data
      final mockChats = MockStorageService.getChats();
      await saveChats(mockChats);
      chatList.addAll(mockChats.map((chat) => chat.toJson()));
    }

    try {
      final chatJson = chatList.firstWhere((chat) => chat['id'] == chatId);
      return ChatModel.fromJson(Map<String, dynamic>.from(chatJson));
    } catch (e) {
      // If no chat with the given ID is found, return null
      debugPrint('No chat with the given ID is found');
      return null;
    }
  }

  @override
  Future<void> updateChat(ChatModel chat) async {
    final chats = await getChats();
    final index = chats.indexWhere((c) => c.id == chat.id);
    if (index != -1) {
      chats[index] = chat;
      await saveChats(chats);
    }
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final chats = await getChats();
    chats.removeWhere((chat) => chat.id == chatId);
    await saveChats(chats);
  }

  @override
  Future<void> saveMessage(MessageModel message) async {
    final messagesBox = await _openMessagesBox();

    // Save the message
    List<dynamic> messagesJson =
        messagesBox.get(message.chatId, defaultValue: []);
    messagesJson.add(message.toJson());
    await messagesBox.put(message.chatId, messagesJson);

    // Update the chat with the new message
    await updateChatWithLastMessage(
        message.chatId, message.content, message.timestamp);
  }

  Future<void> updateChatWithLastMessage(
      String chatId, String lastMessage, DateTime lastMessageTimestamp) async {
    final chatsBox = await _openChatsBox();

    List<dynamic> chatsJson = chatsBox.get(_chatsBoxName, defaultValue: []);
    int chatIndex = chatsJson.indexWhere((chat) => chat['id'] == chatId);

    if (chatIndex != -1) {
      Map<String, dynamic> chatJson =
          Map<String, dynamic>.from(chatsJson[chatIndex]);
      ChatModel updatedChat = ChatModel.fromJson(chatJson).copyWith(
        lastMessage: lastMessage,
        lastMessageTimestamp: lastMessageTimestamp,
      );
      chatsJson[chatIndex] = updatedChat.toJson();
      await chatsBox.put(_chatsBoxName, chatsJson);

      // debugPrint('Chat updated with last message: $updatedChat');
    } else {
      debugPrint('Chat not found for updating: $chatId');
    }
  }

  @override
  Future<List<MessageModel>> getMessagesForChat(String chatId) async {
    final box = await _openMessagesBox();
    final messagesJson = box.get(chatId) as List?;

    if (messagesJson == null || messagesJson.isEmpty) {
      // If no messages exist, get mock messages from MockStorageService
      final mockMessages = MockStorageService.getMessagesForChat(chatId);

      // Save mock messages to local storage
      await box.put(chatId, mockMessages.map((m) => m.toJson()).toList());

      return mockMessages;
    }

    return messagesJson
        .map((json) => MessageModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<MessageModel?> getMessageById(String messageId) async {
    final box = await _openMessagesBox();
    final json = box.get(messageId);
    return json != null ? MessageModel.fromJson(json) : null;
  }

  @override
  Future<void> updateMessage(MessageModel message) async {
    final box = await _openMessagesBox();

    // Get the list of messages for the chat
    List<dynamic> messagesJson = box.get(message.chatId, defaultValue: []);

    // Find the index of the message to update
    int messageIndex = messagesJson.indexWhere((m) => m['id'] == message.id);

    if (messageIndex != -1) {
      // Update the message in the list
      messagesJson[messageIndex] = message.toJson();

      // Save the updated list back to the box
      await box.put(message.chatId, messagesJson);
    } else {
      debugPrint('Message not found for updating: ${message.id}');
    }
  }

  @override
  Future<void> deleteMessagesForChat(String chatId) async {
    final box = await _openMessagesBox();
    final keysToDelete = box.values
        .where((json) => MessageModel.fromJson(json).chatId == chatId)
        .map((json) => MessageModel.fromJson(json).id)
        .toList();
    await box.deleteAll(keysToDelete);
  }

  Future<void> _populateUsersWithMockData() async {
    final box = await _openUsersBox();
    final mockUsers = MockStorageService.getUsers();

    for (var user in mockUsers) {
      await box.put(user.id, user.toJson());
    }

    // debugPrint('Populated users box with ${mockUsers.length} mock users');
  }

  @override
  Future<void> addUser(UserModel user) async {
    final box = await _openUsersBox(); // Open the users box
    await box.put(
        user.id, user.toJson()); // Save the user using their ID as the key
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final box = await _openUsersBox();

    // await box.clear();
    // if (box.isEmpty) {
    //   await _populateUsersWithMockData();
    // }
    // debugPrint('Users: ${box.values}');

    return box.values
        .map((userJson) =>
            UserModel.fromJson(Map<String, dynamic>.from(userJson)))
        .toList();
  }

  @override
  Future<void> saveUsers(List<UserModel> users) async {
    final box = await _openUsersBox();
    final userList = users.map((user) => user.toJson()).toList();
    await box.put('users', userList);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    final box = await _openUsersBox();
    await box.put(user.id, user.toJson());

    // Only set as current user if there isn't one already
    final currentUser = await getCurrentUser();
    if (currentUser == null) {
      await saveCurrentUser(user);
    }
  }

  @override
  Future<List<DeckModel>> getDecks() async {
    final box = await _openDecksBox();
    if (box.isEmpty) {
      final mockDecks = MockStorageService.getDecks();
      for (var deck in mockDecks) {
        await box.put(deck.id, deck.toJson());
      }
    }

    return box.values
        .map((deck) => DeckModel.fromJson(Map<String, dynamic>.from(deck)))
        .toList();
  }

  @override
  @override
  Future<List<FlashcardModel>> getFlashcardsForDeck(String deckId) async {
    final box = await _openFlashcardsBox();

    final allFlashcards = box.values
        .expand((deckMap) => (deckMap as Map).values)
        .where((json) => json is Map && json['deckId'] == deckId)
        .map((json) => FlashcardModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();

    // debugPrint('Flashcards for deck $deckId: $allFlashcards');
    return allFlashcards;
  }

  @override
  Future<List<FlashcardModel>> getAllFlashcards() async {
    final box = await _openFlashcardsBox();
    // debugPrint('Flashcards box: ${box.values}');
    return box.values
        .map((json) => FlashcardModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<void> updateFlashcard(FlashcardModel flashcard) async {
    final box = await _openFlashcardsBox();
    Map<String, dynamic> flashcards = Map<String, dynamic>.from(
        box.get(flashcard.deckId, defaultValue: <String, dynamic>{}));
    flashcards[flashcard.id] = flashcard.toJson();
    await box.put(flashcard.deckId, flashcards);
  }

  @override
  Future<UserModel?> getUserById(String userId) async {
    final box = await _openUsersBox();
    final userJson = box.get(userId);
    return userJson != null
        ? UserModel.fromJson(Map<String, dynamic>.from(userJson))
        : null;
  }

  @override
  Future<void> updateUser(UserModel user) async {
    final box = await _openUsersBox();
    await box.put(user.id, user.toJson());
  }

  @override
  Future<void> deleteUser(String userId) async {
    final box = await _openUsersBox();
    await box.delete(userId);
  }

  @override
  Future<void> addDeck(DeckModel deck) async {
    final box = await _openDecksBox();
    debugPrint('Adding deck: ${deck.toJson()}');
    await box.put(deck.id, deck.toJson());
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final box = await _openUsersBox();
    return box.values
        .map((userJson) =>
            UserModel.fromJson(Map<String, dynamic>.from(userJson)))
        .toList();
  }

  @override
  Future<void> clearCurrentUser() async {
    final box = await _openUsersBox();
    await box.delete(_currentUserKey);
  }

  @override
  Future<void> updateDeck(DeckModel deck) async {
    final box = await _openDecksBox();
    await box.put(deck.id, deck.toJson());
  }

  @override
  Future<void> deleteDeck(String deckId) async {
    final decksBox = await _openDecksBox();
    await decksBox.delete(deckId);

    // Delete all flashcards associated with this deck
    final flashcardsBox = await _openFlashcardsBox();
    final flashcardsToDelete = flashcardsBox.values
        .where((flashcard) => flashcard['deckId'] == deckId);
    for (var flashcard in flashcardsToDelete) {
      await flashcardsBox.delete(flashcard['id']);
    }
  }

  @override
  Future<void> addFlashcard(FlashcardModel flashcard) async {
    final box = await _openFlashcardsBox();
    Map<String, dynamic> flashcards = Map<String, dynamic>.from(
        box.get(flashcard.deckId, defaultValue: <String, dynamic>{}));
    flashcards[flashcard.id] = flashcard.toJson();
    await box.put(flashcard.deckId, flashcards);
  }

  @override
  Future<void> deleteFlashcard(String flashcardId) async {
    final box = await _openFlashcardsBox();
    await box.delete(flashcardId);
  }

  Future<bool> hasFlashcards() async {
    final box = await _openFlashcardsBox();
    return box.isNotEmpty;
  }

  Future<DeckModel?> getDeckById(String deckId) async {
    final box = await _openDecksBox();
    final deckJson = box.get(deckId);
    return deckJson != null
        ? DeckModel.fromJson(Map<String, dynamic>.from(
            deckJson as Map)) // Cast to Map<String, dynamic>
        : null;
  }

  Future<void> updateDeckLastStudied(
      String deckId, DateTime lastStudied) async {
    final box = await _openDecksBox();
    final deck = await getDeckById(deckId);
    if (deck != null) {
      final updatedDeck = deck.copyWith(lastStudied: lastStudied);
      await box.put(deckId, updatedDeck.toJson());
    }
  }

  @override
  Future<void> saveChat(ChatModel chat) async {
    final box = await _openChatsBox();
    final chats = await getChats();
    chats.add(chat);
    await box.put(_chatsBoxName, chats.map((c) => c.toJson()).toList());
  }

  Future<void> clearAllData() async {
    await Hive.deleteBoxFromDisk(_chatsBoxName);
    await Hive.deleteBoxFromDisk(_messagesBoxName);
    await Hive.deleteBoxFromDisk(_usersBoxName);
    await Hive.deleteBoxFromDisk(_decksBoxName);
    await Hive.deleteBoxFromDisk(_flashcardsBoxName);
    await Hive.deleteBoxFromDisk(_knownWordsBoxName);
    await Hive.deleteBoxFromDisk(_favoritesBoxName);
    await Hive.deleteBoxFromDisk(_profilePicturesBoxName);
    await Hive.deleteBoxFromDisk(_likesBoxName);
    await Hive.deleteBoxFromDisk(_commentsBoxName);
  }

  @override
  Future<void> saveProfilePicture(ProfilePictureModel picture) async {
    final box = await _openProfilePicturesBox();
    await box.put(picture.id, picture.toJson());
  }

  @override
  Future<List<ProfilePictureModel>> getProfilePicturesForUser(
      String userId) async {
    final box = await _openProfilePicturesBox();
    return box.values
        .where((json) => json['userId'] == userId)
        .map((json) =>
            ProfilePictureModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<ProfilePictureModel?> getProfilePictureById(String pictureId) async {
    final box = await _openProfilePicturesBox();
    final json = box.get(pictureId);
    return json != null
        ? ProfilePictureModel.fromJson(Map<String, dynamic>.from(json))
        : null;
  }

  @override
  Future<void> deleteProfilePicture(String pictureId) async {
    final box = await _openProfilePicturesBox();
    await box.delete(pictureId);
  }

  @override
  Future<void> saveLike(LikeModel like) async {
    final box = await _openLikesBox();
    await box.put(like.id, like.toJson());
  }

  @override
  Future<void> deleteLike(String likeId) async {
    final box = await _openLikesBox();
    await box.delete(likeId);
  }

  @override
  Future<List<LikeModel>> getLikesForPicture(String pictureId) async {
    final box = await _openLikesBox();
    return box.values
        .where((json) => json['toId'] == pictureId)
        .map((json) => LikeModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<void> saveComment(CommentModel comment) async {
    final box = await _openCommentsBox();
    await box.put(comment.id, comment.toJson());
  }

  @override
  Future<void> deleteComment(String commentId) async {
    final box = await _openCommentsBox();
    await box.delete(commentId);
  }

  @override
  Future<List<CommentModel>> getCommentsForPicture(String pictureId) async {
    final box = await _openCommentsBox();
    return box.values
        .where((json) => json['toId'] == pictureId)
        .map((json) => CommentModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  Future<String> saveAvatar(String userId, String base64Avatar) async {
        final box = await _openProfilePicturesBox();
        final avatar = ProfilePictureModel(id: userId, userId: userId, base64Image: base64Avatar);
        await box.put(userId, avatar.toJson());
        return userId; // Return the user ID as a placeholder for the avatar path
    }

  Future<void> initializeDatabase() async {
    final usersBox = await _openUsersBox();
    final chatsBox = await _openChatsBox();
    final messagesBox = await _openMessagesBox();
    final decksBox = await _openDecksBox();
    final flashcardsBox = await _openFlashcardsBox();
    final knownWordsBox = await _openKnownWordsBox();
    final favoritesBox = await _openFavoritesBox();
    final userLanguagesBox = await _openUserLanguagesBox();
    final profilePicturesBox = await _openProfilePicturesBox();
    final likesBox = await _openLikesBox();
    final commentsBox = await _openCommentsBox();
    final chartsBox = await _openChartsBox();
    final recordingsBox = await _openRecordingsBox();
    final languages = await _openLanguagesBox();


    // print('chartsBox is empty: ${chartsBox.isEmpty}');
    // print('chartsBox is empty: ${knownWordsBox.isEmpty}');
   
    if (usersBox.isEmpty) {
      await _populateUsersWithMockData();
    }
    // Debug print for all users in the box
    // debugPrint('Users in box: ${usersBox.values.map((userJson) => UserModel.fromJson(Map<String, dynamic>.from(userJson))).toList()}');

    if (recordingsBox.isEmpty) {
      final mockRecordings = MockStorageService.getRecordings();
      for (var recording in mockRecordings) {
        await saveRecording(recording);
      }
    }

    if (chatsBox.isEmpty) {
      final mockChats = MockStorageService.getChats();
      await saveChats(mockChats);
    }

    if (messagesBox.isEmpty) {
      final mockMessages = MockStorageService.getMessages();
      for (var message in mockMessages) {
        await saveMessage(message);
      }
    }

//  debugPrint('Current decks in box before adding mock decks: ${decksBox.values.toList()}');

    if (decksBox.isEmpty) {
      final mockDecks = MockStorageService.getDecks();
      for (var deck in mockDecks) {
        debugPrint('Mock deck to be added: ${deck.toJson()}');
        await addDeck(deck);
      }
    }

// await flashcardsBox.clear();
    if (flashcardsBox.isEmpty) {
      final mockFlashcards = MockStorageService.getFlashcards();
      for (var flashcard in mockFlashcards) {
        await addFlashcard(flashcard);
      }
    }

    if (knownWordsBox.isEmpty) {
      final mockKnownWords = MockStorageService.getKnownWords();
      for (var knownWord in mockKnownWords) {
        await saveKnownWord(knownWord);
      }
    }

    // // Debug print for known words
    // final allKnownWords = knownWordsBox.values
    //     .map((json) => KnownWordModel.fromJson(Map<String, dynamic>.from(json)))
    //     .toList();

    // for (var knownWord in allKnownWords) {
    //   print(knownWord.toJson());
    // }

    // await favoritesBox.clear();

    if (favoritesBox.isEmpty) {
      final mockFavorites = MockStorageService.getFavorites();
      for (var favorite in mockFavorites) {
        await saveFavorite(favorite);
      }
    }


    if (userLanguagesBox.isEmpty) {
      final mockLanguages = MockStorageService.getLanguages();
      for (var language in mockLanguages) {
        await saveUserLanguage(language);
      }
    }
      // await languages.clear();
     if (languages.isEmpty) {
      final mockLanguages = MockStorageService.getGenericLanguages();
      for (var language in mockLanguages) {
        await saveLanguage(language);
      }
    }

    if (profilePicturesBox.isEmpty) {
      final mockProfilePictures = MockStorageService.getProfilePictures();
      for (var picture in mockProfilePictures) {
        await saveProfilePicture(picture);
      }
    }

    if (likesBox.isEmpty) {
      final mockLikes = MockStorageService.getLikes();
      for (var like in mockLikes) {
        await saveLike(like);
      }
    }

    if (commentsBox.isEmpty) {
      final mockComments = MockStorageService.getComments();
      for (var comment in mockComments) {
        await saveComment(comment);
      }
    }
    if (chartsBox.isEmpty) {
      // print('chartsBox is empty. Populating with mock data.');
      final mockCharts = MockStorageService.getCharts();
      print('Retrieved ${mockCharts.length} mock charts.');

      for (var chart in mockCharts) {
        print('Saving chart: ${chart.toJson()}');
        await saveChart(chart);
      }
    }
    // else {
    //   print('chartsBox already populated with data.');
    //   final allCharts = chartsBox.values
    //       .map((json) => ChartModel.fromJson(Map<String, dynamic>.from(json)))
    //       .toList();

    //   for (var chart in allCharts) {
    //     print(chart.toJson());
    //   }
    // }

    try {
      // await closeBoxes();
    } catch (e) {
      print('Error closing boxes: $e');
    }
  }

  @override
  Future<List<LikeModel>> getLikes() async {
    final box = await _openLikesBox();
    return box.values
        .map((json) => LikeModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<List<CommentModel>> getComments() async {
    final box = await _openCommentsBox();
    return box.values
        .map((json) => CommentModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<List<ChartModel>> getCharts() async {
    final box = await _openChartsBox();
    return box.values
        .map((json) => ChartModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<void> saveChart(ChartModel chart) async {
    final box = await _openChartsBox();
    await box.put(chart.id, chart.toJson());
    debugPrint('Saved chart: ${chart.toJson()}');
  }

  @override
  Future<void> updateChart(ChartModel chart) async {
    final box = await _openChartsBox();
    await box.put(chart.id, chart.toJson());
    print('Updated chart: ${chart.toJson()}');
  }

  @override
  Future<void> deleteChart(String chartId) async {
    final box = await _openChartsBox();
    await box.delete(chartId);
    print('Deleted chart with id: $chartId');
  }

  @override
  Future<List<ChartModel>> getUserCharts(String userId) async {
    final box = await _openChartsBox();
    final allCharts = box.values
        .map((json) => ChartModel.fromJson(Map<String, dynamic>.from(json)))
        .where((chart) => chart.userId == userId)
        .toList();

    debugPrint('Retrieved ${allCharts.length} charts for user $userId');
    return allCharts;
  }

  @override
  Future<void> updateFavorite(FavoriteModel favorite) async {
    final box = await _openFavoritesBox();
    debugPrint('Updating favorite!!!!: ${favorite.toJson()}');
    await box.put(favorite.id, favorite.toJson());
  }

  Future<void> closeBoxes() async {
    await Hive.close();
  }

  @override
  Future<void> saveLanguage(LanguageModel language) async {
    final box = await _openLanguagesBox();
    await box.put(language.id, language.toJson());
  }

  @override
  Future<List<LanguageModel>> getLanguages() async {
    await initializeDatabase();
    final box = await _openLanguagesBox();
    return box.values
        .map((json) => LanguageModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<LanguageModel?> getLanguageById(String languageId) async {
    final box = await _openLanguagesBox();
    final languageJson = box.get(languageId);
    return languageJson != null
        ? LanguageModel.fromJson(Map<String, dynamic>.from(languageJson))
        : null;
  }

  @override
  Future<void> updateLanguage(LanguageModel language) async {
    final box = await _openLanguagesBox();
    if (box.containsKey(language.id)) {
      await box.put(language.id, language.toJson());
    } else {
      throw Exception('Language not found');
    }
  }

  @override
  Future<void> deleteLanguage(String languageId) async {
    final box = await _openLanguagesBox();
    await box.delete(languageId);
  }

  // Ensure mock languages are saved if there are no existing languages
  Future<void> ensureMockLanguages() async {
    final box = await _openLanguagesBox();
    if (box.isEmpty) {
      final mockLanguages = MockStorageService
          .getLanguages(); // Assuming you have a method to get mock languages
      for (var language in mockLanguages) {
        await saveUserLanguage(language);
      }
    }
  }
}
