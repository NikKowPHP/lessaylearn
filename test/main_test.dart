import 'package:flutter_test/flutter_test.dart';
import 'package:lessay_learn/app.dart';
import 'package:lessay_learn/core/widgets/cupertino_bottom_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:lessay_learn/core/dependency_injection.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPathProviderPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockPathProvider = MockPathProviderPlatform();
  PathProviderPlatform.instance = mockPathProvider;

  when(() => mockPathProvider.getApplicationDocumentsPath())
      .thenAnswer((_) async => '/tmp/test');

  await Hive.initFlutter('/tmp/test');
  await configureDependencies();

  test('App initialization runs without errors', () {
    expect(() {
      WidgetsFlutterBinding.ensureInitialized();
      Hive.initFlutter('/tmp/test');
      configureDependencies();
    }, returnsNormally);
  });

  testWidgets('MyApp widget test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.byType(CupertinoApp), findsOneWidget);
    expect(find.byType(CupertinoBottomNavBar), findsOneWidget);
  });

 
  testWidgets('MyApp has correct theme', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    final CupertinoApp app =
        tester.widget<CupertinoApp>(find.byType(CupertinoApp));
    expect(app.theme!.primaryColor, CupertinoColors.activeBlue);
  });


   tearDownAll(() async {
    await Hive.close();
  });
}
