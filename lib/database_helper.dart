// database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'note_model.dart';

class DatabaseHelper {
  static Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'notes_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY, content TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<List<Note>> getNotes() async {
    final Database db = await initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('notes');

    // Convert the List<Map<String, dynamic>> into a List<Note>
    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'],
        content: maps[i]['content'],
      );
    });
  }

  static Future<void> insertNote(Note note) async {
    final Database db = await initDatabase();
    await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteNote(int id) async {
    final db = await initDatabase();
    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
