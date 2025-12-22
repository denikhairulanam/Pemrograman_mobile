import 'package:flutter/material.dart';
import 'package:student_notes_app/models/note.dart';
import 'package:student_notes_app/note_form_page.dart';
import 'package:student_notes_app/services/local_storage_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  String _selectedCategory = 'Semua';
  bool _isDarkMode = false;

  // Daftar kategori
  final List<String> _categories = [
    'Semua',
    'Kuliah',
    'Organisasi',
    'Pribadi',
    'Lain-lain',
  ];

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _loadThemePreference();
  }

  // Muat catatan dari SharedPreferences
  Future<void> _loadNotes() async {
    final loadedNotes = await LocalStorageService.loadNotes();
    setState(() {
      _notes = loadedNotes;
      _filteredNotes = _notes;
    });
  }

  // Muat preferensi tema
  Future<void> _loadThemePreference() async {
    final isDarkMode = await LocalStorageService.loadDarkModePreference();
    setState(() {
      _isDarkMode = isDarkMode;
    });
  }

  // Simpan catatan ke SharedPreferences
  Future<void> _saveNotes() async {
    await LocalStorageService.saveNotes(_notes);
  }

  // Tambah catatan baru
  Future<void> _addNote() async {
    final result = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (context) => const NoteFormPage()),
    );

    if (result != null) {
      setState(() {
        _notes.add(result);
        _applyFilter();
        _saveNotes();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan berhasil ditambahkan'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Edit catatan
  Future<void> _editNote(int index) async {
    final current = _filteredNotes[index];
    final originalIndex = _notes.indexWhere((note) => note.id == current.id);

    final result = await Navigator.push<Note>(
      context,
      MaterialPageRoute(
        builder: (context) => NoteFormPage(existingNote: current),
      ),
    );

    if (result != null) {
      setState(() {
        _notes[originalIndex] = result;
        _applyFilter();
        _saveNotes();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan berhasil diperbarui'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Hapus catatan
  void _deleteNote(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Yakin ingin menghapus catatan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              final noteToDelete = _filteredNotes[index];
              final originalIndex = _notes.indexWhere(
                (note) => note.id == noteToDelete.id,
              );

              setState(() {
                _notes.removeAt(originalIndex);
                _applyFilter();
                _saveNotes();
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Catatan berhasil dihapus'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Filter berdasarkan kategori
  void _applyFilter() {
    setState(() {
      if (_selectedCategory == 'Semua') {
        _filteredNotes = _notes;
      } else {
        _filteredNotes = _notes
            .where((note) => note.category == _selectedCategory)
            .toList();
      }

      // Urutkan berdasarkan tanggal update terbaru
      _filteredNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    });
  }

  // Toggle dark mode
  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
      LocalStorageService.saveDarkModePreference(_isDarkMode);

      // Untuk demo, kita akan reload halaman dengan tema baru
      // Dalam aplikasi nyata, gunakan Provider atau Riverpod untuk manajemen state tema
    });
  }

  // Dapatkan ikon berdasarkan kategori
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Kuliah':
        return Icons.school;
      case 'Organisasi':
        return Icons.group;
      case 'Pribadi':
        return Icons.person;
      case 'Lain-lain':
        return Icons.more_horiz;
      default:
        return Icons.note;
    }
  }

  // Format tanggal
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'Baru saja';
      }
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Student Notes'),
          actions: [
            // Dropdown filter kategori
            DropdownButton<String>(
              value: _selectedCategory,
              icon: const Icon(Icons.filter_list),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCategory = newValue;
                    _applyFilter();
                  });
                }
              },
              items: _categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            // Tombol toggle dark mode
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: _toggleDarkMode,
            ),
          ],
        ),
        body: _filteredNotes.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.note_add, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    const Text(
                      'Belum ada catatan.\nTekan tombol + untuk menambah.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: _filteredNotes.length,
                itemBuilder: (context, index) {
                  final note = _filteredNotes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: Icon(
                        _getCategoryIcon(note.category),
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(
                        note.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                              Icon(
                                Icons.category,
                                size: 12,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                note.category,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.access_time,
                                size: 12,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatDate(note.updatedAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () => _editNote(index),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteNote(index),
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _addNote,
          icon: const Icon(Icons.add),
          label: const Text('Tambah Catatan'),
        ),
      ),
    );
  }
}
