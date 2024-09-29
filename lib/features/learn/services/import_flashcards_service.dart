import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:lessay_learn/core/models/favorite_model.dart';
import 'package:lessay_learn/core/services/favorite_service.dart';
import 'package:lessay_learn/features/learn/models/deck_model.dart';
import 'package:lessay_learn/features/learn/services/deck_service.dart';
import 'package:lessay_learn/services/i_user_service.dart';
import 'package:lessay_learn/services/user_service.dart';
import 'package:uuid/uuid.dart';

class ImportFlashcardsService {
  final DeckService _deckService;
  final FavoriteService _favoriteService;
  final IUserService _userService;

  ImportFlashcardsService(this._deckService, this._favoriteService, this._userService);

  Future<void> importFlashcards(String deckId) async {
    try {
      final user = await _userService.getCurrentUser();
      DeckModel? deck = await _deckService.getDeckById(deckId);
      if (deck == null) {
        debugPrint('Error: Deck not found');
        return;
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        String csvString = await _readCsvContent(result);
        List<List<dynamic>> csvList = CsvToListConverter().convert(csvString);
        
        // Remove completely empty rows
        csvList = csvList.where((row) => row.any((cell) => cell.toString().trim().isNotEmpty)).toList();

      

        List<FavoriteModel> allFavorites = [];
        int currentIndex = 0;

        while (currentIndex < csvList.length) {
          var chunk = _getNextLanguageChunk(csvList, currentIndex, deck);
          if (chunk == null) break;

          allFavorites.addAll(chunk.favorites);
          currentIndex = chunk.nextIndex;
        }

        // Add all favorites
        for (var favorite in allFavorites) {
          await _favoriteService.addFavorite(favorite);
        }

        debugPrint('Successfully imported ${allFavorites.length} favorites');
      } else {
        debugPrint('No file selected');
      }
    } catch (e) {
      debugPrint('Error importing flashcards: $e');
    }
  }
  Future<List<FavoriteModel>> importFlashcardsWithoutDeckId(String sourceLanguage, String targetLanguage) async {
    try {
      final user = await _userService.getCurrentUser();
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        String csvString = await _readCsvContent(result);
        List<List<dynamic>> csvList = CsvToListConverter().convert(csvString);

        // Remove completely empty rows
        csvList = csvList.where((row) => row.any((cell) => cell.toString().trim().isNotEmpty)).toList();

        List<FavoriteModel> allFavorites = [];
        int currentIndex = 0;

        while (currentIndex < csvList.length) {
          var chunk = _getNextLanguageChunkWithoutDeckId(csvList, currentIndex, sourceLanguage, targetLanguage);
          if (chunk == null) break;

          allFavorites.addAll(chunk.favorites);
          currentIndex = chunk.nextIndex;
        }

      // Add all favorites
        for (var favorite in allFavorites) {
          await _favoriteService.addFavorite(favorite);
        }
        return allFavorites;
      } else {
        throw Exception('No file selected');
      }
    } catch (e) {
      rethrow; // Re-throw the exception to be handled by the caller
    }
  }

  Future<String> _readCsvContent(FilePickerResult result) async {
    if (kIsWeb) {
      final fileBytes = result.files.first.bytes;
      if (fileBytes == null) throw Exception('File bytes are null');
      return String.fromCharCodes(fileBytes);
    } else {
      final filePath = result.files.first.path;
      if (filePath == null) throw Exception('File path is null');
      final file = File(filePath);
      return await file.readAsString();
    }
  }



   LanguageChunk? _getNextLanguageChunkWithoutDeckId(List<List<dynamic>> csvList, int startIndex, String sourceLanguage, String targetLanguage) {
    if (startIndex >= csvList.length) return null;

    // Find the language pair row
    int languagePairIndex = startIndex;
    while (languagePairIndex < csvList.length) {
      var row = csvList[languagePairIndex];
      if (row.length >= 2 && 
          row[0].toString().length == 2 && 
          row[1].toString().length == 2) {
        break;
      }
      languagePairIndex++;
    }

    if (languagePairIndex >= csvList.length) return null;


    // Check if languages match the deck
    // String favoriteSourceLanguage = csvList[languagePairIndex][0].toString().toLowerCase();
    // String favoriteTargetLanguage= csvList[languagePairIndex][1].toString().toLowerCase();
    String favoriteSourceLanguage = sourceLanguage;
    String favoriteTargetLanguage = targetLanguage;
    String deckSourceLanguage = sourceLanguage.toLowerCase().replaceFirst('lang_', '');
    String deckTargetLanguage = targetLanguage.toLowerCase().replaceFirst('lang_', '');

    debugPrint('favoriteSourceLanguage: $favoriteSourceLanguage');
    debugPrint('deckSourceLanguage: $deckSourceLanguage');
    debugPrint('favoriteTargetLanguage: $favoriteTargetLanguage');
    debugPrint('deckTargetLanguage: $deckTargetLanguage');
  
    if (favoriteSourceLanguage != deckSourceLanguage ||
        favoriteTargetLanguage != deckTargetLanguage) {
      debugPrint('Skipping non-matching language pair: $favoriteSourceLanguage - $favoriteTargetLanguage');
      return LanguageChunk([], languagePairIndex + 1);
    }

    debugPrint('Processing language pair: $favoriteSourceLanguage - $favoriteTargetLanguage');

    List<FavoriteModel> favorites = [];
    int currentIndex = languagePairIndex + 1;

    // Process flashcards until we hit an empty row or the end of the file
    while (currentIndex < csvList.length) {
      var row = csvList[currentIndex];
      if (row.isEmpty || (row.length == 1 && row[0].toString().trim().isEmpty)) {
        // Empty row, end of this chunk
        break;
      }
      if (row.length >= 2) {
        favorites.add(FavoriteModel(
          id: Uuid().v4(),
          userId: 'user1', // Replace with actual user ID
          sourceText: row[0].toString(),
          translatedText: row[1].toString(),
           sourceLanguage: sourceLanguage,
          targetLanguage: targetLanguage,
        ));
      }
      
      currentIndex++;
    }

      debugPrint('favorites: $favorites');  

    return LanguageChunk(favorites, currentIndex + 1); // Skip the empty row
  } 

  LanguageChunk? _getNextLanguageChunk(List<List<dynamic>> csvList, int startIndex, DeckModel deck) {
    if (startIndex >= csvList.length) return null;

    // Find the language pair row
    int languagePairIndex = startIndex;
    while (languagePairIndex < csvList.length) {
      var row = csvList[languagePairIndex];
      if (row.length >= 2 && 
          row[0].toString().length == 2 && 
          row[1].toString().length == 2) {
        break;
      }
      languagePairIndex++;
    }

    if (languagePairIndex >= csvList.length) return null;

    String sourceLanguage = csvList[languagePairIndex][0].toString().toLowerCase();
    String targetLanguage = csvList[languagePairIndex][1].toString().toLowerCase();

    debugPrint(sourceLanguage);
    debugPrint(targetLanguage);
    debugPrint('deck lagnuages: ${deck.sourceLanguage} - ${deck.targetLanguage}');
    // Check if languages match the deck
    if (sourceLanguage != deck.sourceLanguage.toLowerCase().replaceFirst('lang_', '') ||
        targetLanguage != deck.targetLanguage.toLowerCase().replaceFirst('lang_', '')) {
      debugPrint('Skipping non-matching language pair: $sourceLanguage - $targetLanguage');
      return LanguageChunk([], languagePairIndex + 1);
    }

    debugPrint('Processing language pair: $sourceLanguage - $targetLanguage');

    List<FavoriteModel> favorites = [];
    int currentIndex = languagePairIndex + 1;

    // Process flashcards until we hit an empty row or the end of the file
    while (currentIndex < csvList.length) {
      var row = csvList[currentIndex];
      if (row.isEmpty || (row.length == 1 && row[0].toString().trim().isEmpty)) {
        // Empty row, end of this chunk
        break;
      }
      if (row.length >= 2) {
        favorites.add(FavoriteModel(
          id: Uuid().v4(),
          userId: 'user1', // Replace with actual user ID
          sourceText: row[0].toString(),
          translatedText: row[1].toString(),
          sourceLanguage: deck.sourceLanguage,
          targetLanguage: deck.targetLanguage,
        ));
      }
      currentIndex++;
    }
  

    return LanguageChunk(favorites, currentIndex + 1); // Skip the empty row
  }


  



}

class LanguageChunk {
  final List<FavoriteModel> favorites;
  final int nextIndex;

  LanguageChunk(this.favorites, this.nextIndex);
}
