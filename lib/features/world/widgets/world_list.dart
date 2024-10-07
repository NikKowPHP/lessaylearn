import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/features/profile/widgets/avatar_widget.dart';
import 'package:lessay_learn/features/world/services/world_service.dart';
import 'package:lessay_learn/core/providers/language_provider.dart';
import 'package:lessay_learn/core/models/user_language_model.dart';
import 'package:go_router/go_router.dart';

class WorldList extends ConsumerWidget {
  final ICommunityService communityService;
  final int segment;

  const WorldList({
    Key? key,
    required this.communityService,
    required this.segment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<UserModel>>(
      future: communityService.getUsers(segment),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No users available'));
        }

        final users = snapshot.data!;
        return CustomScrollView(
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                // Implement refresh logic here
              },
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildUserListItem(context, ref, users[index]),
                childCount: users.length,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserListItem(BuildContext context, WidgetRef ref, UserModel user) {
    return CupertinoListTile(
      leading: AvatarWidget(
         imageUrl: user.avatarUrl,
         isNetworkImage: false,
      ),
      title: Text(user.name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${user.age} • ${user.location}'),
          SizedBox(height: 4),
          Row(
            children: [
              _buildTag(user.languageLevel, CupertinoColors.activeBlue),
              SizedBox(width: 8),
              _buildLanguageTags(ref, user),
            ],
          ),
        ],
      ),
      trailing: Icon(CupertinoIcons.chevron_right, size: 16, color: CupertinoColors.systemGrey),
      onTap: () {
        context.push('/profile/${user.id}');
      },
    );
  }

  Widget _buildLanguageTags(WidgetRef ref, UserModel user) {
    return FutureBuilder<List<UserLanguage?>>(
      future: Future.wait(user.sourceLanguageIds.map((id) => 
        ref.read(userLanguageByIdProvider(id).future))),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CupertinoActivityIndicator();
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Text('Error loading languages');
        }
        final languages = snapshot.data!.whereType<UserLanguage>().toList();
        if (languages.isEmpty) {
          return Text('No languages');
        }
        return Row(
          children: languages.map((lang) => 
            _buildTag('${lang.shortcut} → ${user.targetLanguageIds.first}', CupertinoColors.activeGreen)
          ).toList(),
        );
      },
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12),
      ),
    );
  }
}