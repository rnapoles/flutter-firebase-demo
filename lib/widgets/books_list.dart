import 'package:flutter/material.dart';
import 'package:firebase_demo/services/firestore_service.dart';
import 'package:firebase_demo/models/book.dart';
import 'package:firebase_demo/models/author.dart';
import 'package:firebase_demo/widgets/add_edit_book_dialog.dart';
import 'package:firebase_demo/utils/logger.dart';

class BooksList extends StatelessWidget {
  const BooksList({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return StreamBuilder<List<Book>>(
      stream: firestoreService.getBooks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          Logger.error(
            'Error fetching books stream',
            error: snapshot.error,
            stackTrace: snapshot.stackTrace,
          );
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No books found. Add one!'));
        }

        final books = snapshot.data!;
        return ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: ListTile(
                leading: const Icon(Icons.book, color: Colors.purpleAccent),
                title: Text(book.title),
                subtitle: FutureBuilder<List<Author>>(
                  future: firestoreService.getAuthorsForBook(book.authorIds),
                  builder: (context, authorSnapshot) {
                    if (authorSnapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Loading authors...');
                    }
                    if (!authorSnapshot.hasData || authorSnapshot.data!.isEmpty) {
                      return const Text('No authors');
                    }
                    final authorNames = authorSnapshot.data!.map((a) => a.name).join(', ');
                    return Text(authorNames);
                  },
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AddEditBookDialog(book: book),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Delete Book'),
                              content: Text('Are you sure you want to delete ${book.title}?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    firestoreService.deleteBook(book.id!);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
