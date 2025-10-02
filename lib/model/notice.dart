class Notice {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final bool isImportant;

  Notice({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.isImportant = false,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isImportant: json['is_important'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'is_important': isImportant,
    };
  }
}