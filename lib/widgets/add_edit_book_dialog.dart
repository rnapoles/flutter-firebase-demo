import 'package:flutter/material.dart';
import 'package:firebase_demo/models/book.dart';
import 'package:firebase_demo/models/author.dart';
import 'package:firebase_demo/services/firestore_service.dart';

class AddEditBookDialog extends StatefulWidget {
  final Book? book;
  const AddEditBookDialog({super.key, this.book});

  @override
  State<AddEditBookDialog> createState() => _AddEditBookDialogState();
}

class _AddEditBookDialogState extends State<AddEditBookDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late List<String> _selectedAuthorIds;
  final FirestoreService _firestoreService = FirestoreService();
  List<Author>? _allAuthors;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _title = widget.book?.title ?? '';
    _selectedAuthorIds = widget.book?.authorIds ?? [];
    _loadAuthors();
  }

  Future<void> _loadAuthors() async {
    final authors = await _firestoreService.getAuthors().first;
    setState(() {
      _allAuthors = authors;
      _isLoading = false;
    });
  }

  void _showAuthorSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Select Authors'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _allAuthors!.length,
                  itemBuilder: (context, index) {
                    final author = _allAuthors![index];
                    return CheckboxListTile(
                      title: Text(author.name),
                      value: _selectedAuthorIds.contains(author.id),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedAuthorIds.add(author.id!);
                          } else {
                            _selectedAuthorIds.remove(author.id);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    this.setState(() {});
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final book = Book(
        id: widget.book?.id,
        title: _title,
        authorIds: _selectedAuthorIds,
      );
      if (widget.book == null) {
        _firestoreService.addBook(book);
      } else {
        _firestoreService.updateBook(book);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.book == null ? 'Add Book' : 'Edit Book'),
      content: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: _title,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    onSaved: (value) => _title = value!,
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    title: const Text('Authors'),
                    subtitle: Text('${_selectedAuthorIds.length} selected'),
                    trailing: const Icon(Icons.arrow_drop_down),
                    onTap: _showAuthorSelectionDialog,
                  ),
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
