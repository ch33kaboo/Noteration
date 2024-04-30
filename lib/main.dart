import 'package:flutter/material.dart';
import 'note_detail_page.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
  List<String> notes = [];
  String selectedNote = '';
  int indexo = 0;

  // Function to toggle selectedNote
  void toggleSelectedNote() {
    setState(() {
      selectedNote = ''; // Clear selectedNote
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes App'),
        backgroundColor:
            Colors.deepPurple[50], // Light purple color for app bar
        actions: [
          if (selectedNote.isNotEmpty)
            IconButton(
              icon: Icon(Icons.close), // Icon for hiding note details
              onPressed:
                  toggleSelectedNote, // Call function to clear selectedNote
            ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddNoteDialog(context);
            },
          ),
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (notes.isEmpty) {
            // Display a message and image when there are no notes
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No notes found.',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20), // Adjust spacing as needed
                  SizedBox(
                    width: 120, // Specify desired width
                    height: 120, // Specify desired height
                    child: Image.asset('assets/images/no-data-icon.png'),
                  ),
                ],
              ),
            );
          } else if (orientation == Orientation.landscape) {
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8), // Add margin
                        decoration: BoxDecoration(
                          color: Colors
                              .purple[50], // Light purple background color
                          borderRadius:
                              BorderRadius.circular(10), // Rounded borders
                        ),
                        child: ListTile(
                          title: Text(
                            _truncateText(notes[index], orientation),
                          ),
                          onTap: () {
                            setState(() {
                              selectedNote = notes[index];
                            });
                          },
                          onLongPress: () {
                            _showDeleteDialog(context, index);
                          },
                        ),
                      );
                    },
                  ),
                ),
                if (selectedNote.isNotEmpty)
                  Container(
                    width: 1,
                    color: Colors.grey,
                    height: double.infinity,
                  ),
                Expanded(
                  flex: selectedNote.isNotEmpty
                      ? 2
                      : 0, // Conditionally render based on selectedNote
                  child: selectedNote.isNotEmpty
                      ? NoteDetailPage(
                          note: selectedNote,
                          timestamp: DateTime.now(),
                        )
                      : Container(), // Use Container() as the default value
                ),
              ],
            );
          } else {
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8), // Add margin
                      decoration: BoxDecoration(
                        color:
                            Colors.purple[50], // Light purple background color
                        borderRadius:
                            BorderRadius.circular(10), // Rounded borders
                      ),
                      child: ListTile(
                        title: Text(
                          _truncateText(notes[index], orientation),
                        ),
                        onTap: () {
                          _showNoteDetailPage(
                              context, notes[index], DateTime.now());
                        },
                        onLongPress: () {
                          _showDeleteDialog(context, index);
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddNoteDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  String _truncateText(String text, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      if (text.split(' ').length > 16) {
        return '${text.split(' ').take(16).join(' ')} ...';
      } else {
        return text;
      }
    } else {
      return text;
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
              onPressed: () {
                setState(() {
                  notes.add(noteController.text);
                });
                DatabaseHelper.insertNote(
                    Note(id: indexo, content: noteController.text));
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
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
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  notes.removeAt(index);
                  if (selectedNote == notes[index]) {
                    selectedNote = '';
                  }
                  DatabaseHelper.deleteNote(indexo);
                });
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showNoteDetailPage(
      BuildContext context, String note, DateTime timestamp) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetailPage(note: note, timestamp: timestamp),
      ),
    );
  }
}
