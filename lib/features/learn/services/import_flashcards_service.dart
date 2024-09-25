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

  ImportFlashcardsService(
      this._deckService, this._favoriteService, this._userService);

  Future<void> importFlashcards(String deckId) async {
    try {
      final user = await _userService.getCurrentUser();
      // Fetch the current deck
      DeckModel? deck = await _deckService.getDeckById(deckId);
      if (deck == null) {
        debugPrint('Error: Deck not found');
        return;
      }

      // Open file picker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        String csvString;
        if (kIsWeb) {
          final fileBytes = result.files.first.bytes;
          if (fileBytes == null) {
            debugPrint('Error: File bytes are null');
            return;
          }
          csvString = String.fromCharCodes(fileBytes);
        } else {
          final filePath = result.files.first.path;
          if (filePath == null) {
            debugPrint('Error: File path is null');
            return;
          }
          final file = File(filePath);
          csvString = await file.readAsString();
        }

        // Parse CSV
        List<List<dynamic>> csvList = CsvToListConverter().convert(csvString);
        if (csvList.isEmpty) {
          debugPrint('Error: CSV file is empty');
          return;
        }

        // Remove empty rows
        csvList = csvList
            .where(
                (row) => row.any((cell) => cell.toString().trim().isNotEmpty))
            .toList();

        debugPrint('Filtered CSV Content: $csvList');

   // Check if there are enough rows to process
        if (csvList.isEmpty) {
          debugPrint('Error: CSV format is incorrect or not enough data');
          return;
        }
       // Find source and target languages in the first non-empty row
        String? sourceLanguage;
        String? targetLanguage;

        for (var cell in csvList[0]) {
          String cellValue = cell.toString().toLowerCase();
          if (cellValue == deck.sourceLanguage.toLowerCase().replaceFirst('lang_', '')) {
            sourceLanguage = cellValue;
            break; // Stop searching once we find the source language
          }
        }

        if (sourceLanguage != null) {
          // Find the index of the source language
          int sourceIndex = csvList[0].indexOf(sourceLanguage);
          // The target language is the next element in the row
          if (sourceIndex + 1 < csvList[0].length) {
            targetLanguage = csvList[0][sourceIndex + 1].toString().toLowerCase();
          }
        }

        // Verify if the languages match the deck's languages
        if (sourceLanguage == null || targetLanguage == null ||
            sourceLanguage != deck.sourceLanguage.toLowerCase().replaceFirst('lang_', '') ||
            targetLanguage != deck.targetLanguage.toLowerCase().replaceFirst('lang_', '')) {
          debugPrint('Error: CSV languages do not match deck languages');
          return;
        }

        debugPrint('Source Language: $sourceLanguage');
        debugPrint('Target Language: $targetLanguage');

        // Create favorites from the remaining rows
       // Create favorites from the remaining rows
        List<FavoriteModel> favorites = [];
        for (int i = 1; i < csvList.length; i++) { // Start from the second row
          if (csvList[i].length >= 2) {
            favorites.add(FavoriteModel(
              id: Uuid().v4(),
              userId: user.id,
              sourceText: csvList[i][0].toString(),
              translatedText: csvList[i][1].toString(),
              sourceLanguage: deck.sourceLanguage,
              targetLanguage: deck.targetLanguage,
              isFlashcard: true,
              addedToFlashcardsDate: DateTime.now(),
            ));
          }
        }

        // Add favorites
        for (var favorite in favorites) {
          await _favoriteService.addFavorite(favorite);
        }
        debugPrint('Successfully imported ${favorites.length} favorites');
      } else {
        debugPrint('No file selected');
      }
    } catch (e) {
      debugPrint('Error importing flashcards: $e');
    }
  }
}
