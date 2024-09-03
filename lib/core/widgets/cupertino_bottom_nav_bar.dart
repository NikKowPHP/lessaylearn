
import 'package:flutter/cupertino.dart';
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
        switch (index) {
          case 0:
            return const HomeScreen();
          case 1:
            return const CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(middle: Text('Calls')),
              child: Center(child: Text('Calls Screen')),
            );
          case 2:
            return const CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(middle: Text('Camera')),
              child: Center(child: Text('Camera Screen')),
            );
          case 3:
            return const CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(middle: Text('Settings')),
              child: Center(child: Text('Settings Screen')),
            );
          default:
            return const HomeScreen();
        }
      },
    );
  }
}
