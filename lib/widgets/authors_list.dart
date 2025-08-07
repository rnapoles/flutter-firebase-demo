import 'package:flutter/material.dart';
import 'package:firebase_demo/services/firestore_service.dart';
import 'package:firebase_demo/models/author.dart';
import 'package:firebase_demo/widgets/add_edit_author_dialog.dart';
import 'package:firebase_demo/utils/logger.dart';

class AuthorsList extends StatelessWidget {
  const AuthorsList({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();
    return StreamBuilder<List<Author>>(
      stream: firestoreService.getAuthors(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          Logger.error(
            'Error fetching authors stream',
            error: snapshot.error,
            stackTrace: snapshot.stackTrace,
          );
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No authors found. Add one!'));
        }

        final authors = snapshot.data!;
        return ListView.builder(
          itemCount: authors.length,
          itemBuilder: (context, index) {
            final author = authors[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.blueAccent),
                title: Text(author.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AddEditAuthorDialog(author: author),
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
                              title: const Text('Delete Author'),
                              content: Text('Are you sure you want to delete ${author.name}?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    firestoreService.deleteAuthor(author.id!);
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
