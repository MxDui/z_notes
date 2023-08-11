import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:z_notes/db/helper.dart';
import 'package:z_notes/utils/file_operations.dart';

class NotebookPage extends StatefulWidget {
  final String title;
  final String description;

  const NotebookPage({Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  _NotebookPageState createState() => _NotebookPageState();
}

class _NotebookPageState extends State<NotebookPage> {
  // Mock data representing notes in the notebook
  List<Map<String, dynamic>> notes = [];
  @override
  void initState() {
    super.initState();
    _loadNotesFromDatabase();
  }

  Future<void> _loadNotesFromDatabase() async {
    var dbNotes = await DatabaseHelper.instance.queryAllRows();
    setState(() {
      notes = dbNotes;
    });
  }

  void _addNote() async {
    final picker = ImagePicker();
    final _noteController = TextEditingController();

    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      final imagePath =
          await FileOperations.saveImagePermanently(pickedImage.path);

      // Temporary variable to store the decision of the user (whether to save or cancel)
      bool? shouldSave = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add a new note'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 150.0,
                  child: Image.file(File(imagePath), fit: BoxFit.cover),
                ),
                TextField(
                  controller: _noteController,
                  decoration: const InputDecoration(labelText: 'Note'),
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: const Text('Save'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );

      if (shouldSave == true) {
        await DatabaseHelper.instance.insert({
          'text': _noteController.text,
          'imageUrl': imagePath,
        });
        await _loadNotesFromDatabase();
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('No image picked'),
            content: const Text('Please try again'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          Widget imageWidget;
          if (notes[index]['imageUrl']!.startsWith('http')) {
            imageWidget = Image.network(notes[index]['imageUrl']!);
          } else {
            imageWidget = Image.file(File(notes[index]['imageUrl']!));
          }

          return ListTile(
            leading: imageWidget,
            title: Text(notes[index]['text']!),
            onTap: () {},
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: Icon(Icons.add),
        tooltip: 'Add New Note',
      ),
    );
  }
}
