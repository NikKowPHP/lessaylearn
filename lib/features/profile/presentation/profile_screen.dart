import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/models/user_language_model.dart';
import 'package:lessay_learn/core/providers/language_provider.dart';
import 'package:lessay_learn/core/providers/user_provider.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:go_router/go_router.dart';
import 'package:lessay_learn/features/profile/widgets/avatar_widget.dart';

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
    final profilePicturesAsync = ref.watch(userProfilePicturesProvider(userId));

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
                  GestureDetector(
                    onTap: () => context.push('/user-gallery/$userId'),
                    child: Container(
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
                  _buildLanguagesSection(context, ref, user),
                  SizedBox(height: 20),
                  // Interests
                  _buildInterestsSection(context, user.interests),
                  SizedBox(height: 20),
                  // Occupation
                  if (user.occupation != null)
                    _buildInfoTile('Occupation', user.occupation!),
                  // Education
                  if (user.education != null)
                    _buildInfoTile('Education', user.education!),
                  SizedBox(height: 30),
                  SizedBox(height: 20),
                  _buildGalleryPreview(context, ref, user),
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

  Widget _buildGalleryPreview(BuildContext context, WidgetRef ref, UserModel user) {
    final profilePicturesAsync = ref.watch(userProfilePicturesProvider(user.id));

    return profilePicturesAsync.when(
      data: (pictures) {
        if (pictures.isEmpty) {
          return SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gallery',
              style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
            ),
            SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: pictures.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => context.push('/user-gallery/${user.id}'),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        
                        child: AvatarWidget(imageUrl: pictures[index].imageUrl, isNetworkImage: false,size: 150,)
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => CupertinoActivityIndicator(),
      error: (_, __) => Text('Failed to load gallery'),
    );
  }

  Widget _buildLanguagesSection(BuildContext context, WidgetRef ref, UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Languages',
          style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
        ),
        SizedBox(height: 16),
        _buildLanguageCategory('Native', user.sourceLanguageIds, ref),
        SizedBox(height: 12),
        _buildLanguageCategory('Fluent', user.spokenLanguageIds, ref),
        SizedBox(height: 12),
        _buildLearningLanguages('Learning', user.targetLanguageIds, ref),
      ],
    );
  }

  Widget _buildLanguageCategory(String title, List<String> languageIds, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: languageIds.map((id) => _buildLanguageBubble(id, ref)).toList(),
        ),
      ],
    );
  }

  Widget _buildLanguageBubble(String languageId, WidgetRef ref) {
    return FutureBuilder<UserLanguage?>(
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
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            language.name,
            style: TextStyle(
              color: CupertinoColors.label,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLearningLanguages(String title, List<String> languageIds, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        SizedBox(height: 12),
        ...languageIds.map((id) => _buildLearningLanguageChart(id, ref)),
      ],
    );
  }

  Widget _buildLearningLanguageChart(String languageId, WidgetRef ref) {
    return FutureBuilder<UserLanguage?>(
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
        final progress = language.score / 1000; // Assuming max score is 1000
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(language.name, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                  Text(
                    level,
                    style: TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Stack(
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey5,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: CupertinoColors.activeBlue,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInterestsSection(BuildContext context, List<String> interests) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Interests',
          style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: interests.map(_buildInterestBubble).toList(),
        ),
      ],
    );
  }

  Widget _buildInterestBubble(String interest) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        interest,
        style: TextStyle(
          color: CupertinoColors.label,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
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
