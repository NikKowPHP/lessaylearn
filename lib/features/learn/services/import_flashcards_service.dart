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

        // Find the correct column indices for source and target languages
        int sourceIndex = -1;
        int targetIndex = -1;
        for (int i = 0; i < csvList[0].length; i++) {
          String columnHeader = csvList[0][i].toString().toLowerCase();
          if (columnHeader == deck.sourceLanguage.toLowerCase()) {
            sourceIndex = i;
          } else if (columnHeader == deck.targetLanguage.toLowerCase()) {
            targetIndex = i;
          }
        }

        if (sourceIndex == -1 || targetIndex == -1) {
          debugPrint('Error: Could not find matching language columns');
          return;
        }

        debugPrint('Source Language Column: ${csvList[0][sourceIndex]}');
        debugPrint('Target Language Column: ${csvList[0][targetIndex]}');

        // Remove the header row
        csvList.removeAt(0);

        // Create favorites from the remaining rows
        List<FavoriteModel> favorites = csvList.map((row) {
          return FavoriteModel(
            id: Uuid().v4(),
            userId: user.id,
            sourceText: row[sourceIndex].toString(),
            translatedText: row[targetIndex].toString(),
            sourceLanguage: deck.sourceLanguage,
            targetLanguage: deck.targetLanguage,
            isFlashcard: true,
            addedToFlashcardsDate: DateTime.now(),
          );
        }).toList();

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