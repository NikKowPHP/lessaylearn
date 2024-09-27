import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lessay_learn/features/chat/widgets/settings_screen.dart';
import 'package:lessay_learn/features/home/presentation/home_screen.dart';
import 'package:lessay_learn/features/learn/presentation/screens/learn_screen.dart';
import 'package:lessay_learn/features/voicer/presentation/recording_screen.dart';
import 'package:lessay_learn/features/world/presentation/world_screen.dart';
import 'package:lessay_learn/features/statistics/presentation/statistics_screen.dart';

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
          // BottomNavigationBarItem(
          //   icon: Icon(CupertinoIcons.chat_bubble_2),
          //   label: 'Chats',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(CupertinoIcons.globe),
          //   label: 'World',
          // ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book),
            label: 'Learn',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(CupertinoIcons.graph_square),
          //   label: 'Statistics',
          // ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Settings',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(CupertinoIcons.mic),
          //   label: 'Recording', // New tab label
          // ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (context) {
            switch (index) {
              case 0:
                return Consumer(
                  builder: (context, ref, child) {
                    // return HomeScreen();
                     return LearnScreen();
                  },
                );
              // case 1:
              //   return const CommunityScreen();
              // case 2:
              //   return const LearnScreen();
              // case 3:
              //   return const StatisticsScreen();
              case 1:
                return const SettingsScreen();
              // case 5: // New case for RecordingScreen
              //   return const RecordingScreen();
              default:
                return Consumer(
                  builder: (context, ref, child) {
                    // return HomeScreen();
                     return LearnScreen();
                  },
                );
            }
          },
        );
      },
    );
  }
}
