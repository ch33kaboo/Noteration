class Note {
  int? id; // Primary key for the database
  String note;
  DateTime timestamp;

  Note({
    this.id,
    required this.note,
    required this.timestamp,
  });

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'note': note,
      'timestamp':
          timestamp.toIso8601String(), // Store timestamp as ISO 8601 string
    };
  }

  // Convert a Map object into a Note object
  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      note: map['note'],
      timestamp: DateTime.parse(
          map['timestamp']), // Parse ISO 8601 string back to DateTime
    );
  }
}
