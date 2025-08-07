import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_demo/models/author.dart';
import 'package:firebase_demo/models/book.dart';
import 'package:flutter/material.dart';

class DatabaseSeeder {
  static Future<void> seedDatabase(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final authorsSnapshot = await FirebaseFirestore.instance.collection('authors').limit(1).get();
      if (authorsSnapshot.docs.isNotEmpty) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Database already contains data. Seeding skipped.')),
        );
        return;
      }

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Seeding database...')),
      );

      final batch = FirebaseFirestore.instance.batch();

      // --- Create Authors ---
      final author1Ref = FirebaseFirestore.instance.collection('authors').doc();
      final author2Ref = FirebaseFirestore.instance.collection('authors').doc();
      final author3Ref = FirebaseFirestore.instance.collection('authors').doc();

      batch.set(author1Ref, Author(name: 'J.R.R. Tolkien').toMap());
      batch.set(author2Ref, Author(name: 'George Orwell').toMap());
      batch.set(author3Ref, Author(name: 'Frank Herbert').toMap());

      // --- Create Books ---
      final book1Ref = FirebaseFirestore.instance.collection('books').doc();
      final book2Ref = FirebaseFirestore.instance.collection('books').doc();
      final book3Ref = FirebaseFirestore.instance.collection('books').doc();
      final book4Ref = FirebaseFirestore.instance.collection('books').doc();

      batch.set(book1Ref, Book(title: 'The Hobbit', authorIds: [author1Ref.id]).toMap());
      batch.set(book2Ref, Book(title: 'The Lord of the Rings', authorIds: [author1Ref.id]).toMap());
      batch.set(book3Ref, Book(title: '1984', authorIds: [author2Ref.id]).toMap());
      batch.set(book4Ref, Book(title: 'Dune', authorIds: [author3Ref.id]).toMap());

      await batch.commit();

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Database seeded successfully!')),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error seeding database: $e')),
      );
    }
  }
}
