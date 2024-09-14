import 'package:hive/hive.dart';
import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/features/chat/models/message_model.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/models/flashcard_model.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';
import 'package:lessay_learn/services/mock_storage_service.dart';
import 'package:flutter/foundation.dart';

class LocalStorageService implements ILocalStorageService {
  static const String _chatsBoxName = 'chats';
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _messagesBoxName = 'messages';
  static const String _usersBoxName = 'users';
  static const String _decksBoxName = 'decks';
  static const String _flashcardsBoxName = 'flashcards';

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

  Future<void> initializeBoxes() async {
    await Hive.openBox(_decksBoxName);
    await Hive.openBox(_flashcardsBoxName);
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final box = await _openChatsBox();
    return box.get(_isLoggedInKey, defaultValue: false);
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
    final box = await _openChatsBox();

    List chatList = box.get(_chatsBoxName, defaultValue: []);
    if (chatList.isEmpty) {
      final mockChats = MockStorageService.getChats();
      await saveChats(mockChats);
      chatList = mockChats.map((chat) => chat.toJson()).toList();
      await box.put(_chatsBoxName, chatList);
    }

    return chatList
        .map((chat) => ChatModel.fromJson(Map<String, dynamic>.from(chat)))
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

    debugPrint('Message saved: $message');
    debugPrint('Messages JSON: $messagesJson');
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

      debugPrint('Chat updated with last message: $updatedChat');
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
    await box.put(message.id, message.toJson());
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
    
    debugPrint('Populated users box with mock data');
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final box = await _openUsersBox();
    
    // box.clear();
    if (box.isEmpty) {
      await _populateUsersWithMockData();
    }
    
    return box.values
        .map((userJson) => UserModel.fromJson(Map<String, dynamic>.from(userJson)))
        .toList();
  }

  @override
  Future<void> saveUsers(List<UserModel> users) async {
    final box = await _openUsersBox();
    final userList = users.map((user) => user.toJson()).toList();
    await box.put('users', userList);
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
    // Always return data from the box, whether it was just populated with mocks or already had data
    return box.values
        .map((deck) => DeckModel.fromJson(Map<String, dynamic>.from(deck)))
        .toList();
  }

  @override
  Future<List<FlashcardModel>> getFlashcardsForDeck(String deckId) async {
    final box = await _openFlashcardsBox();
    Map<String, dynamic> flashcardData = box.get(deckId, defaultValue: {});

    if (flashcardData.isEmpty) {
      final allMockFlashcards = MockStorageService.getFlashcards();
      final mockFlashcardsForDeck =
          allMockFlashcards.where((f) => f.deckId == deckId).toList();

      for (var flashcard in mockFlashcardsForDeck) {
        flashcardData[flashcard.id] = flashcard.toJson();
      }
      await box.put(deckId, flashcardData);
    }

    // Always return data from the box
    return flashcardData.values
        .map((flashcard) =>
            FlashcardModel.fromJson(Map<String, dynamic>.from(flashcard)))
        .toList();
  }

  @override
  Future<List<FlashcardModel>> getAllFlashcards() async {
    final box = await _openFlashcardsBox();
    List<FlashcardModel> allFlashcards = [];

    for (var deckId in box.keys) {
      Map<String, dynamic> flashcards = Map<String, dynamic>.from(
          box.get(deckId, defaultValue: <String, dynamic>{}));
      allFlashcards.addAll(flashcards.values.map((flashcard) =>
          FlashcardModel.fromJson(
              Map<String, dynamic>.from(flashcard as Map))));
    }

    return allFlashcards;
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
    debugPrint('User JSON: $userJson');
    return userJson != null
        ? UserModel.fromJson(Map<String, dynamic>.from(userJson))
        : null;
  }

  @override
  Future<void> addDeck(DeckModel deck) async {
    final box = await _openDecksBox();
    await box.put(deck.id, deck.toJson());
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
    return deckJson != null ? DeckModel.fromJson(deckJson) : null;
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

    // Re-initialize the boxes
    await initializeBoxes();
  }
}
