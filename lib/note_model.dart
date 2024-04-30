// note_model.dart

class Note {
  final int id;
  final String content;

  Note({required this.id, required this.content});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
    };
  }
}
