import 'package:flutter/material.dart';
import 'package:z_notes/db/helper.dart';
import 'package:z_notes/views/notebook_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late List<Map<String, String>> notebooks;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotebooksFromDatabase();
  }

  Future<void> _loadNotebooksFromDatabase() async {
    List<Map<String, dynamic>> queryResults =
        await DatabaseHelper.instance.queryAllNotebooks();

    setState(() {
      notebooks = queryResults.map((e) {
        return {
          'title': e[DatabaseHelper.notebookTitle] as String,
          'description': e[DatabaseHelper.notebookDescription] as String,
        };
      }).toList();
    });
  }

  void _addNotebook() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new notebook'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
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
                  notebooks.add({
                    'title': _titleController.text,
                    'description': _descriptionController.text,
                  });
                });
                _titleController.clear();
                _descriptionController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notebook Dashboard'),
      ),
      body: ListView.builder(
        itemCount: notebooks.length,
        itemBuilder: (context, index) {
          return ListTile(
              title: Text(notebooks[index]['title']!),
              subtitle: Text(notebooks[index]['description']!),
              leading: const Icon(Icons.book),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NotebookPage(
                    title: notebooks[index]['title']!,
                    description: notebooks[index]['description']!,
                  ),
                ));
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNotebook,
        tooltip: 'Add New Notebook',
        child: const Icon(Icons.add),
      ),
    );
  }
}
