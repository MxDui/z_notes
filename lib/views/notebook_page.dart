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
    final _noteController = TextEditingController();

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
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    setState(() {
                      notes.add({
                        'text': _noteController.text,
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
        // alert user that no image was picked

        AlertDialog(
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
