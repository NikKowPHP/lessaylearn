import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/providers/chat_provider.dart';
import 'package:lessay_learn/features/chat/models/user_model.dart';

import 'package:lessay_learn/features/profile/widgets/avatar_widget.dart';

class ProfileScreen extends ConsumerWidget {
  final String userId;

  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   
 final chatService = ref.watch(chatServiceProvider);

     return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Profile'),
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
      children: [
        SizedBox(height: 20),
        AvatarWidget(
          imageUrl: user.avatarUrl,
          size: 100,
          isNetworkImage: true,
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
        _buildInfoTile('Native Language', user.sourceLanguage),
        _buildInfoTile('Learning', user.targetLanguage),
        _buildInfoTile('Level', user.languageLevel),
      ],
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