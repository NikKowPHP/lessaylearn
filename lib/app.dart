import 'package:flutter/cupertino.dart';
import 'package:lessay_learn/core/app_config.dart';
import 'package:lessay_learn/core/dependency_injection.dart';


class MyApp extends StatelessWidget {
 const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
      final appConfig = getIt<IAppConfig>(); 
    return CupertinoApp.router(
      title: appConfig.title,
      theme: appConfig.theme,
      routerConfig: appConfig.router,
    );
  }
}