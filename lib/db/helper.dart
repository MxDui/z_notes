import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "NotesAppDatabase.db";
  static const _databaseVersion = 1;

  // Table for notebooks
  static const notebookTable = 'notebooks';
  static const notebookId = 'id';
  static const notebookTitle = 'title';
  static const notebookDescription = 'description';

  // Table for notes
  static const noteTable = 'notes';
  static const noteId = 'id';
  static const noteText = 'text';
  static const noteImageUrl = 'imageUrl';
  static const noteNotebookId =
      'notebookId'; // Foreign key to link to the notebook

  // Singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $notebookTable (
            $notebookId INTEGER PRIMARY KEY,
            $notebookTitle TEXT NOT NULL,
            $notebookDescription TEXT NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE $noteTable (
            $noteId INTEGER PRIMARY KEY,
            $noteText TEXT NOT NULL,
            $noteImageUrl TEXT NOT NULL,
            $noteNotebookId INTEGER,
            FOREIGN KEY($noteNotebookId) REFERENCES $notebookTable($notebookId)
          )
          ''');
  }

  Future<int> insertNotebook(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(notebookTable, row);
  }

  Future<List<Map<String, dynamic>>> queryAllNotebooks() async {
    Database db = await instance.database;
    return await db.query(notebookTable);
  }

  Future<int> insertNote(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(noteTable, row);
  }

  Future<List<Map<String, dynamic>>> queryAllNotes() async {
    Database db = await instance.database;
    return await db.query(noteTable);
  }

  Future<List<Map<String, dynamic>>> queryNotesByNotebookName(
      String notebookName) async {
    Database db = await instance.database;
    return await db.rawQuery('''
    SELECT $noteTable.* 
    FROM $noteTable
    JOIN $notebookTable ON $noteTable.$noteNotebookId = $notebookTable.$notebookId
    WHERE $notebookTable.$notebookTitle = ?
  ''', [notebookName]);
  }
}
