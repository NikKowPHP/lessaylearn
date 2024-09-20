import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/favorite_model.dart';
import 'package:lessay_learn/features/learn/services/deck_service.dart';

class FavoriteListScreen extends ConsumerStatefulWidget {
  final String sourceLanguageId;
  final String targetLanguageId;

  const FavoriteListScreen({
    Key? key,
    required this.sourceLanguageId,
    required this.targetLanguageId,
  }) : super(key: key);

  @override
  _FavoriteListScreenState createState() => _FavoriteListScreenState();
}

class _FavoriteListScreenState extends ConsumerState<FavoriteListScreen> {
  Set<String> selectedFavorites = {};
  bool selectAll = false;

  @override
  Widget build(BuildContext context) {
    final deckService = ref.watch(deckServiceProvider);
    final favoritesFuture = deckService.getFavoritesByLanguages(
      widget.sourceLanguageId,
      widget.targetLanguageId,
    );

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Select Favorites'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(selectAll ? 'Deselect All' : 'Select All'),
          onPressed: () {
            setState(() {
              selectAll = !selectAll;
              // Implementation in FutureBuilder
            });
          },
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text('Submit'),
          onPressed: selectedFavorites.isNotEmpty
              ? () {
                  // Handle submission
                  print('Selected favorites: $selectedFavorites');
                  Navigator.pop(context, selectedFavorites.toList());
                }
              : null,
        ),
      ),
      child: SafeArea(
        child: FutureBuilder<List<FavoriteModel>>(
          future: favoritesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CupertinoActivityIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No favorites found for these languages'));
            } else {
              final favorites = snapshot.data!;
              if (selectAll) {
                selectedFavorites = Set.from(favorites.map((f) => f.id));
              }
              return ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final favorite = favorites[index];
                  final isSelected = selectedFavorites.contains(favorite.id);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedFavorites.remove(favorite.id);
                        } else {
                          selectedFavorites.add(favorite.id);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: isSelected
                            ? Border.all(color: CupertinoColors.activeBlue, width: 2)
                            : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      child: CupertinoListTile(
                        title: Text(favorite.sourceText),
                        subtitle: Text(favorite.translatedText),
                        trailing: CupertinoCheckbox(
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedFavorites.add(favorite.id);
                              } else {
                                selectedFavorites.remove(favorite.id);
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
