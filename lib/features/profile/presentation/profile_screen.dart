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
                    width: 200,
                    height: 200,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLanguageCategory('Source Languages', user.sourceLanguageIds, ref),
        SizedBox(height: 10),
        _buildLanguageCategory('Spoken Languages', user.spokenLanguageIds, ref),
        SizedBox(height: 10),
        _buildLearningLanguages('Learning Languages', user.targetLanguageIds, ref),
      ],
    );
  }

  Widget _buildLanguageCategory(String title, List<String> languageIds, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Wrap(
          spacing: 8,
          children: languageIds.map((id) => _buildLanguageChip(id, ref)).toList(),
        ),
      ],
    );
  }

  Widget _buildLanguageChip(String languageId, WidgetRef ref) {
    return FutureBuilder<LanguageModel?>(
      future: ref.read(languageByIdProvider(languageId).future),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CupertinoActivityIndicator();
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return SizedBox.shrink();
        }
        final language = snapshot.data!;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey5,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(language.name),
        );
      },
    );
  }

  Widget _buildLearningLanguages(String title, List<String> languageIds, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        ...languageIds.map((id) => _buildLearningLanguageChart(id, ref)),
      ],
    );
  }

 Widget _buildLearningLanguageChart(String languageId, WidgetRef ref) {
  return FutureBuilder<LanguageModel?>(
    future: ref.read(languageByIdProvider(languageId).future),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CupertinoActivityIndicator();
      }
      if (snapshot.hasError || !snapshot.hasData) {
        return SizedBox.shrink();
      }
      final language = snapshot.data!;
      final level = ref.watch(calculateLanguageLevelProvider(language.score));
      final levelAsInt = _getLevelAsInt(level);
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            SizedBox(width: 80, child: Text(language.name)),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey5,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: levelAsInt / 6,
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: CupertinoColors.activeBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Text('$level (${language.score})'),
          ],
        ),
      );
    },
  );
}

  int _getLevelAsInt(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return 1;
      case 'elementary':
        return 2;
      case 'intermediate':
        return 3;
      case 'upper intermediate':
        return 4;
      case 'advanced':
        return 5;
      case 'proficient':
        return 6;
      default:
        return 1;
    }
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
