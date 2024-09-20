import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/favorite_model.dart';
import 'package:lessay_learn/features/learn/services/deck_service.dart';

class FavoriteListScreen extends ConsumerWidget {
  final String sourceLanguageId;
  final String targetLanguageId;

  const FavoriteListScreen({
    Key? key,
    required this.sourceLanguageId,
    required this.targetLanguageId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deckService = ref.watch(deckServiceProvider);
    final favoritesFuture = deckService.getFavoritesByLanguages(sourceLanguageId, targetLanguageId);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Select Favorites'),
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
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final favorite = snapshot.data![index];
                  return CupertinoListTile(
                    title: Text(favorite.sourceText),
                    subtitle: Text(favorite.translatedText),
                    trailing: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Icon(CupertinoIcons.add_circled),
                      onPressed: () {
                        // Handle favorite selection
                      },
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
