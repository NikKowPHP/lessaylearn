import 'package:flutter/cupertino.dart';
// Assuming this provides an IAppRouter interface



// Define an interface for the app configuration
abstract class IAppConfig {
  String get title;
  CupertinoThemeData get theme;
}

// Implement the app configuration using the interface
class AppConfig implements IAppConfig {
  @override
  String get title => 'Lessay Learn';

  @override
  CupertinoThemeData get theme => const CupertinoThemeData(
        primaryColor: CupertinoColors.systemGrey,
      );

}