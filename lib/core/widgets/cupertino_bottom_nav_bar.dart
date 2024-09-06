import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:lessay_learn/features/chat/widgets/settings_screen.dart';
import 'package:lessay_learn/features/home/presentation/home_screen.dart';

class CupertinoBottomNavBar extends StatelessWidget {
  const CupertinoBottomNavBar({Key? key}) : super(key: key);

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
            icon: Icon(CupertinoIcons.phone),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Settings',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        // Use IndexedStack to efficiently switch between screens
        return CupertinoTabView(
          builder: (context) {
            switch (index) {
              case 0:
                return const HomeScreen(); // Replace with your Chats screen
              case 1:
                return const HomeScreen(); // Replace with your Calls screen
              case 2:
                return const HomeScreen(); // Replace with your Camera screen
              case 3:
                return const SettingsScreen(); // Replace with your Settings screen
              default:
                return const HomeScreen();
            }
          },
        );
      },
    );
  }
}