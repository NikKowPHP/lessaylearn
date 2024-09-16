import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/providers/chat_provider.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';
import 'package:lessay_learn/features/profile/widgets/avatar_widget.dart';
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
   
 final chatService = ref.watch(chatServiceProvider);

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
        child: FutureBuilder<UserModel?>(
          future: chatService.getUserById(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CupertinoActivityIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading profile'));
            } else if (snapshot.data == null) {
              return Center(child: Text('User not found'));
            } else {
              return _buildProfileContent(context, snapshot.data!);
            }
          },
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserModel user) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        SizedBox(height: 20),
        AvatarWidget(
          imageUrl: user.avatarUrl,
          size: 100,
          isNetworkImage: false,
        ),
        SizedBox(height: 20),
        Text(
          user.name,
          style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          '${user.age} years old, ${user.location}',
          style: CupertinoTheme.of(context).textTheme.textStyle,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
       if (user.bio != null) _buildInfoTile('Bio', user.bio!),
        _buildInfoTile('Native Languages', user.sourceLanguages.join(', ')),
        _buildInfoTile('Learning', user.targetLanguages.join(', ')),
        _buildInfoTile('Spoken Languages', user.spokenLanguages.join(', ')),
        _buildInfoTile('Level', user.languageLevel),
        if (user.occupation != null) _buildInfoTile('Occupation', user.occupation!),
        if (user.education != null) _buildInfoTile('Education', user.education!),
        SizedBox(height: 20),
        Text(
          'Interests',
          style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: user.interests.map((interest) => _buildInterestChip(interest)).toList(),
        ),
      ],
    );
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
          Text(value),
        ],
      ),
    );
  }
}