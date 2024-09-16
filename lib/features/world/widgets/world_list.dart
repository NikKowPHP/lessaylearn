import 'package:flutter/cupertino.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/features/world/services/world_service.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
class CommunityList extends StatelessWidget {
  final ICommunityService communityService;
  final int segment;

  const CommunityList({
    Key? key,
    required this.communityService,
    required this.segment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                (context, index) => _buildUserListItem(context, users[index]),
                childCount: users.length,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserListItem(BuildContext context, UserModel user) {
    return CupertinoListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(user.avatarUrl),
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
            _buildTag('${user.sourceLanguages.first} → ${user.targetLanguages.first}', CupertinoColors.activeGreen),
          ], 
          ),
        ],
      ),
      trailing: Icon(CupertinoIcons.chevron_right, size: 16, color: CupertinoColors.systemGrey),
      onTap: () {
        context.go('/profile/${user.id}', extra: user);
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