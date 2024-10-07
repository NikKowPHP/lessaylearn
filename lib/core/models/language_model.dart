class Language {
  final String id;
  final String name;
  final String shortcut;
  final String emoji; // New field for emoji
   final String asciiShortcut;

  Language({
    required this.id,
    required this.name,
    required this.shortcut,
    required this.emoji, // Include emoji in the constructor
     required this.asciiShortcut,
  });

  @override
  String toString() {
    return '''Language(
      id: $id,
      name: $name,
      shortcut: $shortcut,
      emoji: $emoji,
      asciiShortcut: $asciiShortcut
    )''';
  }

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      shortcut: json['shortcut'] ?? '',
      emoji: json['emoji'] ?? '', // Handle emoji
       asciiShortcut: json['asciiShortcut'] ?? '', 

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shortcut': shortcut,
      'emoji': emoji, // Include emoji in the JSON representation
        'asciiShortcut': asciiShortcut,
    };
  }

  Language copyWith({
    String? id,
    String? name,
    String? shortcut,
    String? emoji,
    String? asciiShortcut,
  }) {
    return Language(
      id: id ?? this.id,
      name: name ?? this.name,
      shortcut: shortcut ?? this.shortcut,
      emoji: emoji ?? this.emoji,
      asciiShortcut: asciiShortcut ?? this.asciiShortcut,
    );
  }
}