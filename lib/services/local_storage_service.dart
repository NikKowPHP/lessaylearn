import 'package:hive/hive.dart';
import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/features/chat/models/message_model.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/models/flashcard_model.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';

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
    // box.clear();
    final chatList = box.get(_chatsBoxName, defaultValue: []) as List;
    return chatList.map((chat) => ChatModel.fromJson(chat)).toList();
  }

  @override
  Future<ChatModel?> getChatById(String chatId) async {
    final chats = await getChats();
    try {
      return chats.firstWhere((chat) => chat.id == chatId);
    } catch (e) {
      // TODO: Handle the case where no chat with the given ID is found
      // You can either return null or throw an exception
      return null; // Or throw an exception: throw ChatNotFoundException();
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
    final box = await _openMessagesBox();
    await box.put(message.id, message.toJson());
  }

 @override
Future<List<MessageModel>> getMessagesForChat(String chatId) async {
  final box = await _openMessagesBox();
  final allMessages = box.values.map((json) {
    if (json is Map<String, dynamic>) {
      return MessageModel.fromJson(json);
    } else if (json is Map) {
      return MessageModel.fromJson(Map<String, dynamic>.from(json));
    }
    throw FormatException('Invalid message format');
  }).toList();
  return allMessages.where((message) => message.chatId == chatId).toList();
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

  @override
  Future<List<UserModel>> getUsers() async {
    final box = await _openUsersBox();
   
    final userList = box.get('users', defaultValue: []) as List;
    return userList
        .map((user) => UserModel.fromJson(Map<String, dynamic>.from(user)))
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
    final deckList = box.values.toList();
    return deckList.map((deck) => DeckModel.fromJson(deck)).toList();
  }

  @override
  Future<List<FlashcardModel>> getFlashcardsForDeck(String deckId) async {
    final box = await _openFlashcardsBox();
    // TODO: TEST PURPOSES REMOVE THIS
    box.clear();
    final flashcardData = box.get(deckId) as Map?;

    if (flashcardData == null) {
      return [];
    }
    // final flashcardList = box.get(deckId, defaultValue: []) as List;

    // if (flashcardList.isEmpty) {
    // final mockFlashcards = _getMockFlashcards(deckId);
    // for (var flashcard in mockFlashcards) {
    //   await addFlashcard(flashcard);
    // }
    // }

    return flashcardData.values
        .map((flashcard) => FlashcardModel.fromJson(
            Map<String, dynamic>.from(flashcard as Map)))
        .toList();
  }

  List<FlashcardModel> _getMockFlashcards(String deckId) {
    if (deckId == '1') {
      // Spanish Basics
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
    } else if (deckId == '2') {
      // French Verbs
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
  return userJson != null ? UserModel.fromJson(Map<String, dynamic>.from(userJson)) : null;
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
}
