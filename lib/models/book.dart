class Book {
  final String? id;
  final String title;
  final List<String> authorIds;

  Book({this.id, required this.title, required this.authorIds});

  factory Book.fromMap(String id, Map<String, dynamic> data) {
    return Book(
      id: id,
      title: data['title'],
      authorIds: List<String>.from(data['authorIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'authorIds': authorIds,
    };
  }
}
