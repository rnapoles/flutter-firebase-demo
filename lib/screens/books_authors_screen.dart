import 'package:flutter/material.dart';
import 'package:firebase_demo/widgets/app_drawer.dart';
import 'package:firebase_demo/widgets/authors_list.dart';
import 'package:firebase_demo/widgets/books_list.dart';
import 'package:firebase_demo/widgets/add_edit_author_dialog.dart';
import 'package:firebase_demo/widgets/add_edit_book_dialog.dart';

class BooksAuthorsScreen extends StatefulWidget {
  const BooksAuthorsScreen({super.key});

  @override
  State<BooksAuthorsScreen> createState() => _BooksAuthorsScreenState();
}

class _BooksAuthorsScreenState extends State<BooksAuthorsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild to update FAB
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books & Authors'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.book), text: 'Books'),
            Tab(icon: Icon(Icons.person), text: 'Authors'),
          ],
        ),
      ),
      drawer: const AppDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: const [
          BooksList(),
          AuthorsList(),
        ],
      ),
      floatingActionButton: _buildFab(context),
    );
  }

  Widget? _buildFab(BuildContext context) {
    if (_tabController.index == 0) { // Books tab
      return FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddEditBookDialog(),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Book',
      );
    } else if (_tabController.index == 1) { // Authors tab
      return FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddEditAuthorDialog(),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Author',
      );
    }
    return null;
  }
}
