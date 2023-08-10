import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  List<Map<String, String>> notes = [
    {'text': 'First note', 'imageUrl': 'https://via.placeholder.com/150'},
    {'text': 'Second note', 'imageUrl': 'https://via.placeholder.com/150'},
  ];

  void _addNote() {
    // Logic to add a new note with photo.
    final picker = ImagePicker();

    picker.pickImage(source: ImageSource.camera).then((pickedImage) {
      if (pickedImage != null) {
        final imageFile = File(pickedImage.path);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Add a new note'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.file(imageFile),
                  const TextField(
                    decoration: InputDecoration(labelText: 'Note'),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    setState(() {
                      notes.add({
                        'text': 'New note',
                        'imageUrl': imageFile.path,
                      });
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        print('No image was picked.');
      }
    });
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
          return ListTile(
            leading: Image.network(notes[index]['imageUrl']!),
            title: Text(notes[index]['text']!),
            onTap: () {
              // Logic for when a note is tapped.
              // This could open the note in a detailed view.
            },
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
