import 'dart:ui';

class ToDo {
  int id;
  String content;
  List<String> tag;
  String title;
  DateTime date;
  Color color;
  DateTime createdAt;

  ToDo({
    required this.id,
    required this.title,
    required this.content,
    required this.tag,
    required this.date,
    required this.color,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id' : id,
    'title' : title,
    'content' : content,
    'tag' : tag,
    'color' : color.toARGB32(),
    'date' : date.toIso8601String(),
    'createdAt' : createdAt.toIso8601String(),
  };

  factory ToDo.fromJson(Map<String, dynamic> json) => ToDo(
    id: json['id'] ?? DateTime.now().microsecondsSinceEpoch,
    title: json['title'] ?? '',
    content: json['content'] ?? '',
    tag: List<String>.from(json['tag'] ?? []),
    color: Color(json['color'] ?? 0xffffffff),
    date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
  );
}
