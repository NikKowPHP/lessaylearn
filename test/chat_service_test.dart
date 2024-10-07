// import 'package:flutter_test/flutter_test.dart';
// import 'package:lessay_learn/features/chat/models/chat_model.dart';
// import 'package:lessay_learn/features/chat/services/chat_service.dart';

// import 'package:mocktail/mocktail.dart';

// class MockChatService extends Mock implements IChatService {}

// void main() {
//   group('ChatModel Tests', () {
//     test('ChatModel creation and toJson', () {
//       final chat = ChatModel(
//         id: '1',
//         name: 'Test Chat',
//         lastMessage: 'Hello',
//         time: '10:00',
//         avatarUrl: 'https://example.com/avatar.jpg',
//         date: DateTime(2023, 5, 1),
//         chatTopic: 'General',
//         languageLevel: 'Intermediate',
//         sourceLanguageId: 'English',
//         targetLanguageId: 'Spanish',
//       );

//       expect(chat.id, '1');
//       expect(chat.name, 'Test Chat');
//       expect(chat.lastMessage, 'Hello');

//       final json = chat.toJson();
//       expect(json['id'], '1');
//       expect(json['name'], 'Test Chat');
//       expect(json['lastMessage'], 'Hello');
//     });

//     test('ChatModel fromJson', () {
//       final json = {
//         'id': '2',
//         'name': 'Another Chat',
//         'lastMessage': 'Hi there',
//         'time': '11:00',
//         'avatarUrl': 'https://example.com/avatar2.jpg',
//         'date': '2023-05-02T00:00:00.000',
//         'chatTopic': 'Travel',
//         'languageLevel': 'Advanced',
//         'sourceLanguage': 'French',
//         'targetLanguage': 'German',
//       };

//       final chat = ChatModel.fromJson(json);

//       expect(chat.id, '2');
//       expect(chat.name, 'Another Chat');
//       expect(chat.lastMessage, 'Hi there');
//       expect(chat.date, DateTime(2023, 5, 2));
//     });

//      test('ChatModel correctly handles null values in fromJson', () {
//       final json = {
//         'id': '1',
//         'name': null,
//         'lastMessage': '',
//         'time': '10:00',
//         'avatarUrl': null,
//         'date': '2023-05-01T00:00:00.000',
//         'chatTopic': 'General',
//         'languageLevel': 'Intermediate',
//         'sourceLanguage': 'English',
//         'targetLanguage': 'Spanish',
//       };

//       final chat = ChatModel.fromJson(json);

//       expect(chat.id, '1');
//       expect(chat.name, '');
//       expect(chat.lastMessage, '');
//       expect(chat.avatarUrl, '');
//     });

//     test('ChatModel toJson handles special characters', () {
//       final chat = ChatModel(
//         id: '1',
//         name: 'Test "Chat"',
//         lastMessage: "It's a test",
//         time: '10:00',
//         avatarUrl: 'https://example.com/avatar.jpg?param=value&another=true',
//         date: DateTime(2023, 5, 1),
//         chatTopic: 'General',
//         languageLevel: 'Intermediate',
//         sourceLanguageId: 'English',
//         targetLanguageId: 'Spanish',
//       );

//       final json = chat.toJson();
//       expect(json['name'], 'Test "Chat"');
//       expect(json['lastMessage'], "It's a test");
//       expect(json['avatarUrl'], 'https://example.com/avatar.jpg?param=value&another=true');
//     });

//     test('ChatModel equality', () {
//       final chat1 = ChatModel(
//         id: '1',
//         name: 'Test Chat',
//         lastMessage: 'Hello',
//         time: '10:00',
//         avatarUrl: 'https://example.com/avatar.jpg',
//         date: DateTime(2023, 5, 1),
//         chatTopic: 'General',
//         languageLevel: 'Intermediate',
//         sourceLanguageId: 'English',
//         targetLanguageId: 'Spanish',
//       );

//       final chat2 = ChatModel(
//         id: '1',
//         name: 'Test Chat',
//         lastMessage: 'Hello',
//         time: '10:00',
//         avatarUrl: 'https://example.com/avatar.jpg',
//         date: DateTime(2023, 5, 1),
//         chatTopic: 'General',
//         languageLevel: 'Intermediate',
//         sourceLanguageId: 'English',
//         targetLanguageId: 'Spanish',
//       );

//       expect(chat1, equals(chat2));
//     });
//   });

//   group('IChatService Tests', () {
//     late MockChatService mockChatService;

//     setUp(() {
//       mockChatService = MockChatService();
//     });

//         test('getChats returns an empty list when no chats are available', () async {
//       when(() => mockChatService.getChats()).thenAnswer((_) async => []);

//       final result = await mockChatService.getChats();

//       expect(result, isA<List<ChatModel>>());
//       expect(result, isEmpty);
//     });

//     test('saveChats handles an empty list', () async {
//       when(() => mockChatService.saveChats([])).thenAnswer((_) async {});

//       await mockChatService.saveChats([]);

//       verify(() => mockChatService.saveChats([])).called(1);
//     });

//     test('getChats handles and returns chats with various language levels', () async {
//       final mockChats = [
//         ChatModel(
//           id: '1',
//           name: 'Beginner Chat',
//           lastMessage: 'Hello',
//           time: '10:00',
//           avatarUrl: 'https://example.com/avatar1.jpg',
//           date: DateTime(2023, 5, 1),
//           chatTopic: 'General',
//           languageLevel: 'Beginner',
//           sourceLanguageId: 'English',
//           targetLanguageId: 'French',
//         ),
//         ChatModel(
//           id: '2',
//           name: 'Advanced Chat',
//           lastMessage: 'Bonjour',
//           time: '11:00',
//           avatarUrl: 'https://example.com/avatar2.jpg',
//           date: DateTime(2023, 5, 2),
//           chatTopic: 'Travel',
//           languageLevel: 'Advanced',
//           sourceLanguageId: 'French',
//           targetLanguageId: 'English',
//         ),
//       ];

//       when(() => mockChatService.getChats()).thenAnswer((_) async => mockChats);

//       final result = await mockChatService.getChats();

//       expect(result.length, 2);
//       expect(result[0].languageLevel, 'Beginner');
//       expect(result[1].languageLevel, 'Advanced');
//     });

//     test('getChats returns a list of ChatModel', () async {
//       final mockChats = [
//         ChatModel(
//           id: '1',
//           name: 'Chat 1',
//           lastMessage: 'Hello',
//           time: '10:00',
//           avatarUrl: 'https://example.com/avatar1.jpg',
//           date: DateTime(2023, 5, 1),
//           chatTopic: 'General',
//           languageLevel: 'Beginner',
//           sourceLanguageId: 'English',
//           targetLanguageId: 'French',
//         ),
//         ChatModel(
//           id: '2',
//           name: 'Chat 2',
//           lastMessage: 'Bonjour',
//           time: '11:00',
//           avatarUrl: 'https://example.com/avatar2.jpg',
//           date: DateTime(2023, 5, 2),
//           chatTopic: 'Travel',
//           languageLevel: 'Intermediate',
//           sourceLanguageId: 'French',
//           targetLanguageId: 'English',
//         ),
//       ];

//       when(() => mockChatService.getChats()).thenAnswer((_) async => mockChats);

//       final result = await mockChatService.getChats();

//       expect(result, isA<List<ChatModel>>());
//       expect(result.length, 2);
//       expect(result[0].id, '1');
//       expect(result[1].id, '2');
//     });

//     test('saveChats calls the method with correct parameters', () async {
//       final chatsToSave = [
//         ChatModel(
//           id: '3',
//           name: 'Chat 3',
//           lastMessage: 'Hola',
//           time: '12:00',
//           avatarUrl: 'https://example.com/avatar3.jpg',
//           date: DateTime(2023, 5, 3),
//           chatTopic: 'Food',
//           languageLevel: 'Advanced',
//           sourceLanguageId: 'Spanish',
//           targetLanguageId: 'Italian',
//         ),
//       ];

//       when(() => mockChatService.saveChats(chatsToSave)).thenAnswer((_) async {});

//       await mockChatService.saveChats(chatsToSave);

//       verify(() => mockChatService.saveChats(chatsToSave)).called(1);
//     });
//   });
// }
