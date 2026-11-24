class Option {
  final String id;
  bool isActive;
  final String title;
  final String explanation;

  Option({
    required this.id,
    required this.isActive,
    required this.title,
    required this.explanation,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'isActive': isActive,
    'title': title,
    'explanation': explanation,
  };

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    id: json['id'] ?? '',
    isActive: json['isActive'] ?? false,
    title: json['title'] ?? '',
    explanation: json['explanation'] ?? '',
  );
}
