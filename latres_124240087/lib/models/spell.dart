class Spell {
  final String spell;
  final String use;
  final int index;

  Spell({
    required this.spell,
    required this.use,
    required this.index,
  });

  factory Spell.fromJson(Map<dynamic, dynamic> jsonData) {
    return Spell(
      spell: jsonData['spell'] ?? '',
      use: jsonData['use'] ?? '',
      index: jsonData['index'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'spell': spell,
      'use': use,
      'index': index,
    };
  }
}
