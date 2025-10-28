class Quote {
  Quote({
    required this.id,
    required this.author,
    required this.text,
    required this.category,
    required this.background,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'] as String,
      author: json['author'] as String,
      text: json['text'] as String,
      category: json['category'] as String,
      background: json['background'] as String? ?? 'aurora',
    );
  }

  final String id;
  final String author;
  final String text;
  final String category;
  final String background;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'author': author,
      'text': text,
      'category': category,
      'background': background,
    };
  }
}
