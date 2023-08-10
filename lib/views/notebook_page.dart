import 'package:flutter/material.dart';

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
    // This could open a new page or a modal to let the user input note text
    // and select/capture a photo.
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
