import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/core/providers/chat_provider.dart';

import 'package:lessay_learn/features/chat/widgets/settings_screen.dart';
import 'package:lessay_learn/features/home/presentation/home_screen.dart';
import 'package:lessay_learn/features/world/presentation/world_screen.dart';

// Placeholder screens for Calls and Camera (you'll replace these)
class CallsScreen extends StatelessWidget {
  const CallsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Calls')),
      child: Center(child: Text('Calls Screen')),
    );
  }
}

class CameraScreen extends StatelessWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Camera')),
      child: Center(child: Text('Camera Screen')),
    );
  }
}

class CupertinoBottomNavBar extends StatefulWidget {
  const CupertinoBottomNavBar({Key? key}) : super(key: key);

  @override
  State<CupertinoBottomNavBar> createState() => _CupertinoBottomNavBarState();
}

class _CupertinoBottomNavBarState extends State<CupertinoBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_2),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.globe),
            label: 'World',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Settings',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (context) {
            switch (index) {
              case 0:
                return Consumer(
                  builder: (context, ref, child) {
           
                    return HomeScreen();
                  },
                );
              case 1:
                return const CommunityScreen(); // Use your Calls screen here
              case 2:
                return const CameraScreen(); // Use your Camera screen here
              case 3:
                return const SettingsScreen();
              default:
                return Consumer(
                  builder: (context, ref, child) {
        
                    return HomeScreen();
                  },
                );
            }
          },
        );
      },
    );
  }
}