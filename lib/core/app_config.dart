import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:lessay_learn/core/router/router.dart'; // Assuming this provides an IAppRouter interface



// Define an interface for the app configuration
abstract class IAppConfig {
  String get title;
  CupertinoThemeData get theme;
  GoRouter get router; 
}

// Implement the app configuration using the interface
class AppConfig implements IAppConfig {
  @override
  String get title => 'Lessay Learn';

  @override
  CupertinoThemeData get theme => const CupertinoThemeData(
        primaryColor: CupertinoColors.systemGrey,
      );

  @override
  GoRouter get router => createAppRouter(); 
}