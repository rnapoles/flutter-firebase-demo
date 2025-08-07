import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_demo/models/author.dart';
import 'package:firebase_demo/models/book.dart';
import 'package:firebase_demo/utils/logger.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Author CRUD
  Stream<List<Author>> getAuthors() {
    return _db.collection('authors').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Author.fromMap(doc.id, doc.data())).toList());
  }

  Future<void> addAuthor(Author author) async {
    try {
      await _db.collection('authors').add(author.toMap());
    } catch (e, s) {
      Logger.error('Failed to add author', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> updateAuthor(Author author) async {
    try {
      await _db.collection('authors').doc(author.id).update(author.toMap());
    } catch (e, s) {
      Logger.error('Failed to update author ${author.id}', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> deleteAuthor(String authorId) async {
    try {
      await _db.collection('authors').doc(authorId).delete();
    } catch (e, s) {
      Logger.error('Failed to delete author $authorId', error: e, stackTrace: s);
      rethrow;
    }
  }

  // Book CRUD
  Stream<List<Book>> getBooks() {
    return _db.collection('books').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Book.fromMap(doc.id, doc.data())).toList());
  }

  Future<void> addBook(Book book) async {
    try {
      await _db.collection('books').add(book.toMap());
    } catch (e, s) {
      Logger.error('Failed to add book', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> updateBook(Book book) async {
    try {
      await _db.collection('books').doc(book.id).update(book.toMap());
    } catch (e, s) {
      Logger.error('Failed to update book ${book.id}', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<void> deleteBook(String bookId) async {
    try {
      await _db.collection('books').doc(bookId).delete();
    } catch (e, s) {
      Logger.error('Failed to delete book $bookId', error: e, stackTrace: s);
      rethrow;
    }
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
