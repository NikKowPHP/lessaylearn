import 'package:lessay_learn/core/models/favorite_model.dart';
import 'package:lessay_learn/core/models/known_word_model.dart';
import 'package:lessay_learn/core/models/language_model.dart';
import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/features/chat/models/message_model.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/models/flashcard_model.dart';

abstract class ILocalStorageService {
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

 // Known Words methods
  Future<void> saveKnownWord(KnownWordModel knownWord);
  Future<List<KnownWordModel>> getKnownWords();
  Future<void> deleteKnownWord(String knownWordId);

  // Favorites methods
  Future<void> saveFavorite(FavoriteModel favorite);
  Future<List<FavoriteModel>> getFavorites();
  Future<void> deleteFavorite(String favoriteId);

  // Language methods
  Future<void> saveLanguage(LanguageModel language);
  Future<List<LanguageModel>> getLanguagesByUserId(String userId);
  Future<LanguageModel?> getLanguageById(String languageId);
  Future<void> updateLanguage(LanguageModel language);
  Future<void> deleteLanguage(String languageId);

}