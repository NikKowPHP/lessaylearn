import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/language_model.dart';
import 'package:lessay_learn/core/providers/language_service_provider.dart';
import 'package:lessay_learn/core/providers/user_provider.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  final String userId;
  final bool showBackButton;

  const ProfileScreen({
    Key? key,
    required this.userId,
    this.showBackButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userByIdProvider(userId));

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Profile'),
        leading: showBackButton
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(CupertinoIcons.back),
                onPressed: () => context.pop(),
              )
            : null,
      ),
      child: SafeArea(
        child: userAsync.when(
          data: (user) {
            if (user == null) {
              return Center(child: Text('User not found'));
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  // Avatar
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(user.avatarUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // User Name
                  Text(
                    user.name,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .navLargeTitleTextStyle,
                  ),
                  SizedBox(height: 10),
                  // Age and Location
                  Text(
                    '${user.age} years old, ${user.location}',
                    style: CupertinoTheme.of(context).textTheme.textStyle,
                  ),
                  SizedBox(height: 20),
                  // Bio
                  if (user.bio != null) _buildInfoTile('Bio', user.bio!),
                  SizedBox(height: 20),
                  // Languages
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Languages',
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .navTitleTextStyle,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildLanguagesSection(context, ref, user),
                  SizedBox(height: 20),
                  // Interests
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Interests',
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .navTitleTextStyle,
                    ),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: user.interests
                        .map((interest) => _buildInterestChip(interest))
                        .toList(),
                  ),
                  SizedBox(height: 20),
                  // Occupation
                  if (user.occupation != null)
                    _buildInfoTile('Occupation', user.occupation!),
                  // Education
                  if (user.education != null)
                    _buildInfoTile('Education', user.education!),
                  SizedBox(height: 30),
                ],
              ),
            );
          },
          loading: () => Center(child: CupertinoActivityIndicator()),
          error: (error, stack) => Center(child: Text('Error loading profile')),
        ),
      ),
    );
  }

  Widget _buildLanguagesSection(
      BuildContext context, WidgetRef ref, UserModel user) {
    // Combine all language IDs
    final allLanguageIds = [
      ...user.sourceLanguageIds,
      ...user.targetLanguageIds,
      ...user.spokenLanguageIds,
    ];

    // Remove duplicates
    final uniqueLanguageIds = allLanguageIds.toSet().toList();

    return FutureBuilder<List<LanguageModel>>(
      future: _fetchLanguages(ref, uniqueLanguageIds),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CupertinoActivityIndicator();
        } else if (snapshot.hasError) {
          return Text('Error loading languages');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No languages found');
        } else {
          final languages = snapshot.data!;
          return ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: languages.length,
            separatorBuilder: (context, index) => Container(
              height: 1,
              color: CupertinoColors.systemGrey,
            ),
            itemBuilder: (context, index) {
              final language = languages[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(language.name),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Level: ${language.level}'),
                        Text('Score: ${language.score}'),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<List<LanguageModel>> _fetchLanguages(
      WidgetRef ref, List<String> languageIds) async {
    final languageService = ref.read(languageServiceProvider);
    List<LanguageModel> languages = [];

    for (var id in languageIds) {
      final language = await languageService.fetchLanguageById(id);
      if (language != null) {
        languages.add(language);
      }
    }

    return languages;
  }

  Widget _buildInterestChip(String interest) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey5,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        interest,
        style: TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(color: CupertinoColors.systemGrey),
            ),
          ),
        ],
      ),
    );
  }
}
