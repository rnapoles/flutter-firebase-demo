import 'package:flutter/material.dart';
import 'package:firebase_demo/models/author.dart';
import 'package:firebase_demo/services/firestore_service.dart';

class AddEditAuthorDialog extends StatefulWidget {
  final Author? author;
  const AddEditAuthorDialog({super.key, this.author});

  @override
  State<AddEditAuthorDialog> createState() => _AddEditAuthorDialogState();
}

class _AddEditAuthorDialogState extends State<AddEditAuthorDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _name = widget.author?.name ?? '';
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.author == null) {
        _firestoreService.addAuthor(Author(name: _name));
      } else {
        _firestoreService.updateAuthor(Author(id: widget.author!.id, name: _name));
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.author == null ? 'Add Author' : 'Edit Author'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          initialValue: _name,
          decoration: const InputDecoration(labelText: 'Name'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a name';
            }
            return null;
          },
          onSaved: (value) => _name = value!,
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
