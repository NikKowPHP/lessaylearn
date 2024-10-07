class Language {
  final String id;
  final String name;
  final String shortcut;

  Language({
    required this.id,
    required this.name,
    required this.shortcut,
  });

  @override
  String toString() {
    return '''Language(
      id: $id,
      name: $name,
      shortcut: $shortcut
    )''';
  }

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      shortcut: json['shortcut'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shortcut': shortcut,
    };
  }

  Language copyWith({
    String? id,
    String? name,
    String? shortcut,
  }) {
    return Language(
      id: id ?? this.id,
      name: name ?? this.name,
      shortcut: shortcut ?? this.shortcut,
    );
  }
}