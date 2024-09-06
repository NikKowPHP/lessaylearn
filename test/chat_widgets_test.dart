import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/app.dart';
import 'package:lessay_learn/core/dependency_injection.dart';
import 'package:lessay_learn/features/chat/widgets/chat_list.dart';
import 'package:lessay_learn/features/home/presentation/home_screen.dart';
import 'package:lessay_learn/core/widgets/cupertino_bottom_nav_bar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lessay_learn/services/api_service.dart';
import 'package:lessay_learn/services/i_chat_service.dart';
import 'package:lessay_learn/services/i_local_storage_service.dart';
import 'package:lessay_learn/services/local_storage_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lessay_learn/features/chat/widgets/chat_list.dart';
import 'package:lessay_learn/features/chat/models/chat_model.dart';
import 'package:lessay_learn/services/local_storage_service.dart';
import 'package:lessay_learn/features/chat/services/chat_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MockApiService extends Mock implements ApiService {}

class MockNetworkImage extends Mock implements NetworkImage {}

final chatServiceProvider =
    Provider<ChatService>((ref) => ChatService(LocalStorageService()));

class MockChatService extends Mock implements ChatService {}

class MockLocalStorageService extends Mock implements ILocalStorageService {}

class MockPathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return '.';
  }
}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  MockChatService mockChatService = MockChatService();
  MockLocalStorageService mockLocalStorageService = MockLocalStorageService();
  setUpAll(() async {
    PathProviderPlatform.instance = MockPathProviderPlatform();
    await Hive.initFlutter();
  
  });


















  group('Widget Tests', () {
    testWidgets('MyApp widget test', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      expect(find.byType(CupertinoApp), findsOneWidget);
      expect(find.byType(CupertinoBottomNavBar), findsOneWidget);
    });

    testWidgets('HomeScreen widget test', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: CupertinoApp(
            home: HomeScreen(),
          ),
        ),
      );
      await tester
          .pump(Duration(seconds: 2)); // Allow time for async operations

      expect(find.byType(CupertinoPageScaffold), findsOneWidget);
      expect(find.byType(CupertinoNavigationBar), findsOneWidget);
      expect(find.text('Chats'), findsOneWidget);
      expect(find.byType(SafeArea), findsAtLeastNWidgets(1));
      expect(find.byType(ChatList), findsOneWidget);
    });
  });












  group('ChatList Widget Tests', () {
    late MockChatService mockChatService;
    late MockLocalStorageService mockLocalStorageService;

    setUp(() async {
      mockChatService = MockChatService();
      mockLocalStorageService = MockLocalStorageService();
   
 getIt.reset();
  configureDependencies();
      when(() => mockLocalStorageService.getChats())
          .thenAnswer((_) async => []);
    });
    testWidgets(
        'ChatList displays loading indicator when future is not resolved',
        (WidgetTester tester) async {
      when(() => mockChatService.getChats()).thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            chatServiceProvider.overrideWithValue(mockChatService),
          ],
          child: CupertinoApp(home: ChatList(chatService: mockChatService,)),
        ),
      );

      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
    });

    testWidgets('ChatList displays error message widget',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        CupertinoApp(home: buildErrorWidget('Test error')),
      );

      expect(find.text('Error: Test error'), findsOneWidget);
    });
    
   testWidgets('ChatList displays a list of chats when data is available',
        (WidgetTester tester) async {
      final mockChats = [
        ChatModel(
          id: '1',
          name: 'John Doe',
          lastMessage: 'Hello!',
          time: '10:00 AM',
          avatarUrl: 'assets/blank.png',
          date: DateTime.now(),
          chatTopic: 'Greetings',
          languageLevel: 'Beginner',
          sourceLanguage: 'English',
          targetLanguage: 'Spanish',
        ),
        ChatModel(
          id: '2',
          name: 'Jane Smith',
          lastMessage: 'How are you?',
          time: '11:00 AM',
          avatarUrl: 'assets/blank.png',
          date: DateTime.now().subtract(Duration(days: 1)),
          chatTopic: 'Weather',
          languageLevel: 'Intermediate',
          sourceLanguage: 'French',
          targetLanguage: 'German',
        ),
      ];

      when(() => mockChatService.getChats()).thenAnswer((_) async => mockChats);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            chatServiceProvider.overrideWithValue(mockChatService),
          ],
          child: CupertinoApp(home: ChatList(chatService: mockChatService)),
        ),
      );

      // Wait for the data to load
      await tester.pumpAndSettle();

      // Check if the chat items are rendered
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Jane Smith'), findsOneWidget);

      // Check if the date headers are rendered
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Yesterday'), findsOneWidget);
    });
  });
}
