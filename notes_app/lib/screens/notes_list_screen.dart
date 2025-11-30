import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/note.dart';
import '../widgets/note_dialog.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({Key? key}) : super(key: key);

  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesString = prefs.getString('notes');

      if (notesString != null) {
        final List<dynamic> notesJson = jsonDecode(notesString);
        setState(() {
          notes = notesJson.map((json) => Note.fromJson(json)).toList();
          _sortNotes();
        });
      }
    } catch (e) {
      print('Error loading notes: $e');
      _showErrorSnackBar('Gagal memuat catatan');
    }
  }

  Future<void> _saveNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'notes',
        jsonEncode(notes.map((note) => note.toJson()).toList()),
      );
    } catch (e) {
      print('Error saving notes: $e');
      _showErrorSnackBar('Gagal menyimpan catatan');
    }
  }

  void _sortNotes() {
    notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  void _addNote(String title, String content) {
    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    setState(() {
      notes.add(newNote);
      _sortNotes();
    });
    _saveNotes();
  }

  void _deleteNote(int index) {
    if (index >= 0 && index < notes.length) {
      setState(() {
        notes.removeAt(index);
      });
      _saveNotes();
    }
  }

  void _updateNote(int index, String title, String content) {
    if (index >= 0 && index < notes.length) {
      setState(() {
        notes[index] = notes[index].copyWith(
          title: title,
          content: content,
          updatedAt: DateTime.now(),
        );
        _sortNotes();
      });
      _saveNotes();
    }
  }

  void _showDeleteDialog(int index) {
    if (index < 0 || index >= notes.length) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Catatan'),
        content: Text('Yakin ingin menghapus "${notes[index].title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              _deleteNote(index);
              Navigator.pop(context);
              _showSuccessSnackBar('Catatan berhasil dihapus');
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showNoteDialog({int? index}) {
    final isEdit = index != null;

    final titleController = TextEditingController(
      text: isEdit ? notes[index!].title : '',
    );
    final contentController = TextEditingController(
      text: isEdit ? notes[index!].content : '',
    );

    showDialog(
      context: context,
      builder: (context) => NoteDialog(
        titleController: titleController,
        contentController: contentController,
        isEdit: isEdit,
        onSave: () {
          final title = titleController.text.trim();
          final content = contentController.text.trim();

          if (title.isEmpty || content.isEmpty) {
            _showErrorSnackBar('Judul dan konten tidak boleh kosong');
            return;
          }

          if (isEdit) {
            _updateNote(index!, title, content);
            _showSuccessSnackBar('Catatan berhasil diperbarui');
          } else {
            _addNote(title, content);
            _showSuccessSnackBar('Catatan berhasil ditambahkan');
          }

          Navigator.pop(context);
        },
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Total: ${notes.length} catatan'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_add, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada catatan',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tekan + untuk menambahkan catatan',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];

                return Card(
                  key: ValueKey(note.id),
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text(
                      note.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              _formatDate(note.updatedAt),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            if (note.updatedAt != note.createdAt) ...[
                              const SizedBox(width: 4),
                              Text(
                                '(diedit)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ]
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _showDeleteDialog(index),
                    ),
                    onTap: () => _showNoteDialog(index: index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
