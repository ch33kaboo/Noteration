import 'package:flutter/material.dart';
import 'note_detail_page.dart';
import 'database_helper.dart';
import 'note_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notes = []; // Update notes list to hold Note objects
  String selectedNote = '';

  @override
  void initState() {
    super.initState();
    _fetchNotesFromDatabase();
  }

  Future<void> _fetchNotesFromDatabase() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    List<Note> fetchedNotes = await databaseHelper.getAllNotes();
    setState(() {
      notes = fetchedNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes App'),
        backgroundColor: Colors.deepPurple[50],
        actions: [
          if (selectedNote.isNotEmpty)
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  selectedNote = '';
                });
              },
            ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddNoteDialog(context);
            },
          ),
        ],
      ),
      body: _buildNoteList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddNoteDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildNoteList() {
    if (notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No notes found.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 120,
              height: 120,
              child: Image.asset('assets/images/no-data-icon.png'),
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notes[index].note),
            onTap: () {
              setState(() {
                selectedNote = notes[index].note;
              });
            },
            onLongPress: () {
              _showDeleteDialog(context, notes[index]);
            },
          );
        },
      );
    }
  }

  void _showAddNoteDialog(BuildContext context) {
    TextEditingController noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Note'),
          content: TextField(
            controller: noteController,
            decoration: InputDecoration(labelText: 'Enter your note'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                DatabaseHelper databaseHelper = DatabaseHelper();
                Note newNote = Note(
                  note: noteController.text,
                  timestamp: DateTime.now(),
                );
                await databaseHelper.insert(newNote);
                _fetchNotesFromDatabase();
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Note'),
          content: Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                DatabaseHelper databaseHelper = DatabaseHelper();
                await databaseHelper
                    .delete(note.id!); // Delete note from database
                _fetchNotesFromDatabase();
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
