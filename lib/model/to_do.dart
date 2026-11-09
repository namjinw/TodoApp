class ToDo {
  int id;
  String content;
  List<String> tag;
  String title;
  DateTime date;
  DateTime createAt;

  ToDo({
    required this.id,
    required this.title,
    required this.content,
    required this.tag,
    required this.date,
    required this.createAt,
  });

  Map<String, String> toJson(ToDo t) => {
    'id' : '${t.id}',
    'title' : t.title,
    'content' : t.content,
    'tag' : '${t.tag}',
    'date' : t.date.toIso8601String(),
    'createAt ' : t.createAt.toIso8601String() ,
  };

  factory fromJson(Map<String, dynamic> json) => ToDo(
    id: int.parse(json['id'] ?? DateTime.now().microsecondsSinceEpoch),
    title: json['title'] ?? '',
    content: json['content'] ?? '',
    tag: List<String>.from(json['tag'] ?? []),
    date: DateTime.tryParse(json['date']) ?? DateTime.now(),
    createAt: DateTime.tryParse(json['createAt']) ?? DateTime.now(),
  );
}
