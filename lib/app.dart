import 'package:flutter/cupertino.dart';
import 'package:lessay_learn/core/widgets/cupertino_bottom_nav_bar.dart';


class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Lessay Learn',
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.activeBlue,
      ),
      home: const CupertinoBottomNavBar(),
    );
  }
}