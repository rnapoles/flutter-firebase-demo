import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_demo/models/author.dart';
import 'package:firebase_demo/models/book.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Author CRUD
  Stream<List<Author>> getAuthors() {
    return _db.collection('authors').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Author.fromMap(doc.id, doc.data())).toList());
  }

  Future<void> addAuthor(Author author) {
    return _db.collection('authors').add(author.toMap());
  }

  Future<void> updateAuthor(Author author) {
    return _db.collection('authors').doc(author.id).update(author.toMap());
  }

  Future<void> deleteAuthor(String authorId) {
    return _db.collection('authors').doc(authorId).delete();
  }

  // Book CRUD
  Stream<List<Book>> getBooks() {
    return _db.collection('books').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Book.fromMap(doc.id, doc.data())).toList());
  }

  Future<void> addBook(Book book) {
    return _db.collection('books').add(book.toMap());
  }

  Future<void> updateBook(Book book) {
    return _db.collection('books').doc(book.id).update(book.toMap());
  }

  Future<void> deleteBook(String bookId) {
    return _db.collection('books').doc(bookId).delete();
  }

  Future<List<Author>> getAuthorsForBook(List<String> authorIds) async {
    if (authorIds.isEmpty) return [];
    final authors = <Author>[];
    final querySnapshot = await _db.collection('authors').where(FieldPath.documentId, whereIn: authorIds).get();
    for (var doc in querySnapshot.docs) {
      authors.add(Author.fromMap(doc.id, doc.data()));
    }
    return authors;
  }
}
