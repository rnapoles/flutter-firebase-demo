class Author {
  final String? id;
  final String name;

  Author({this.id, required this.name});

  factory Author.fromMap(String id, Map<String, dynamic> data) {
    return Author(
      id: id,
      name: data['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
