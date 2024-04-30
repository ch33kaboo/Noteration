import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class NoteDetailPage extends StatefulWidget {
  final String note;
  final DateTime timestamp;

  NoteDetailPage({
    Key? key,
    required this.note,
    required this.timestamp,
  }) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  void dispose() {
    // Stop speaking when the page is disposed
    flutterTts.stop();
    super.dispose();
  }

  // Function to format the date and time to display only hours and minutes
  String formatDateTime(DateTime dateTime) {
    // Extract hours and minutes from the DateTime object
    String date = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    String hours = dateTime.hour.toString().padLeft(2, '0');
    String minutes = dateTime.minute.toString().padLeft(2, '0');

    // Construct the formatted string
    return '$date  |  $hours:$minutes';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes Detail'),
        backgroundColor:
            Colors.deepPurple[50], // Light purple color for app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Note:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(widget.note),
            SizedBox(height: 16.0),
            Text(
              'Timestamp:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(formatDateTime(widget.timestamp)),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _speakNote();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Read Aloud'),
                  SizedBox(width: 15), // Adjust spacing between text and icon
                  SizedBox(
                    width: 24, // Adjust the width as needed
                    height: 24, // Adjust the height as needed
                    child: Opacity(
                      opacity: 0.7, // Set opacity to 70%
                      child: Image.asset('assets/images/marketing.png'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _speakNote() async {
    await flutterTts.speak(widget.note);
  }
}
