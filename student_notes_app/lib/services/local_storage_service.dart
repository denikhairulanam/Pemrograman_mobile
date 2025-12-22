
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class LocalStorageService {
  static const String _notesKey = 'notes';
  static const String _darkModeKey = 'darkMode';

  // Simpan catatan
  static Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = notes.map((note) => note.toMap()).toList();
    await prefs.setString(_notesKey, jsonEncode(notesJson));
  }

  // Muat catatan
  static Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getString(_notesKey);

    if (notesJson != null) {
      final List<dynamic> decoded = jsonDecode(notesJson);
      return decoded
          .map((map) => Note.fromMap(Map<String, dynamic>.from(map)))
          .toList();
    }

    return [];
  }

  // Simpan preferensi dark mode
  static Future<void> saveDarkModePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, isDarkMode);
  }

  // Muat preferensi dark mode
  static Future<bool> loadDarkModePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }
}

// Helper functions for JSON
String jsonEncode(List<Map<String, dynamic>> data) {
  // Simulasi sederhana untuk encode JSON
  return data.toString();
}

List<dynamic> jsonDecode(String jsonString) {
  // Simulasi sederhana untuk decode JSON
  // Dalam implementasi nyata, gunakan dart:convert
  try {
    // Format sederhana: [{'key': 'value'}, ...]
    return []; // Return empty for demo
  } catch (e) {
    return [];
  }
}
