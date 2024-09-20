├── lib
│   ├── app.dart
│   ├── core
│   │   ├── models
│   │   │   ├── user_model.dart
│   │   │   ├── chat_model.dart
│   │   │   ├── message_model.dart
│   │   │   ├── known_word_model.dart
│   │   │   ├── favorite_model.dart
│   │   │   └── language_model.dart
│   │   └── interfaces
│   │       └── storage_interface.dart
│   ├── data
│   │   ├── repositories
│   │   │   ├── user_repository.dart
│   │   │   ├── chat_repository.dart
│   │   │   ├── message_repository.dart
│   │   │   ├── known_word_repository.dart
│   │   │   ├── favorite_repository.dart
│   │   │   └── language_repository.dart
│   │   └── data_sources
│   │       └── storage
│   │           ├── hive_storage.dart
│   │           └── firebase_storage.dart
│   ├── services
│   │   ├── storage_service.dart
│   │   └── database_service.dart
│   └── features
│   │   ├── chat
│   │   │   ├── models
│   │   │   │   ├── chat_model.dart
│   │   │   │   ├── message_model.dart
│   │   │   │   └── user_model.dart
│   │   │   ├── services
│   │   │   │   └── chat_service.dart
│   │   │   └── widgets
│   │   │       ├── chat_list.dart
│   │   │       ├── chat_screen.dart
│   │   │       ├── create_chat_view.dart
│   │   │       └── settings_screen.dart
│   │   ├── home
│   │   │   ├── presentation
│   │   │   │   └── home_screen.dart
│   │   │   └── providers
│   │   │       └── current_user_provider.dart
│   │   ├── learn
│   │   │   ├── models
│   │   │   │   ├── deck_model.dart
│   │   │   │   └── flashcard_model.dart
│   │   │   ├── presentation
│   │   │   │   ├── add_deck_screen.dart
│   │   │   │   ├── deck_detail_screen.dart
│   │   │   │   ├── learn_screen.dart
│   │   │   │   ├── study_session_screen.dart
│   │   │   │   └── widgets
│   │   │   │       ├── deck_list_item.dart
│   │   │   │       └── flashcard_list_item.dart
│   │   │   ├── providers
│   │   │   │   ├── flashcard_provider.dart
│   │   │   │   └── flashcard_service_provider.dart
│   │   │   ├── repositories
│   │   │   │   └── flashcard_repository.dart
│   │   │   └── services
│   │   │       ├── flashcard_service.dart
│   │   │       └── i_flashcard_service.dart
│   │   ├── profile
│   │   │   ├── models
│   │   │   │   └── profile_picture_model.dart
│   │   │   ├── presentation
│   │   │   │   ├── profile_screen.dart
│   │   │   │   └── user_gallery_screen.dart
│   │   │   ├── providers
│   │   │   │   └── profile_provider.dart
│   │   │   └── widgets
│   │   │       └── avatar_widget.dart
│   │   ├── statistics
│   │   │   ├── models
│   │   │   │   └── chart_model.dart
│   │   │   ├── presentation
│   │   │   │   └── statistics_screen.dart
│   │   │   ├── providers
│   │   │   │   └── chart_provider.dart
│   │   │   └── services
│   │   │       └── chart_service.dart
│   │   ├── voicer
│   │   │   ├── models
│   │   │   │   └── recording_model.dart
│   │   │   ├── presentation
│   │   │   │   ├── recording_screen.dart
│   │   │   │   └── widgets
│   │   │   │       ├── recording_history_widget.dart
│   │   │   │       └── speech_analizer_widget.dart
│   │   │   ├── providers
│   │   │   │   └── recording_provider.dart
│   │   │   └── services
│   │   │       └── recording_service.dart
│   │   └── world
│   │       ├── presentation
│   │       │   └── world_screen.dart
│   │       ├── services
│   │       │   └── world_service.dart
│   │       └── widgets
│   │           └── world_list.dart
│   ├── main.dart
│   └── services
│       ├── api_service.dart
│       ├── database_service.dart
│       ├── i_chat_service.dart
│       ├── i_language_service.dart
│       ├── i_local_storage_service.dart
│       ├── i_user_service.dart
│       ├── language_service.dart
│       ├── local_storage_service.dart
│       ├── mock_storage_service.dart
│       └── user_service.dart
├── project_tree.md
├── pubspec.lock
├── pubspec.yaml
├── README.md
├── test
│   ├── chat_service_test.dart
│   ├── chat_widgets_test.dart
│   └── main_test.dart
└── web
    ├── favicon.png
    ├── icons
    │   ├── Icon-192.png
    │   ├── Icon-512.png
    │   ├── Icon-maskable-192.png
    │   └── Icon-maskable-512.png
    ├── index.html
    └── manifest.json
