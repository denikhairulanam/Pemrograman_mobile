import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImagePickerUtils {
  static final ImagePicker _picker = ImagePicker();

  // Pilih gambar dari gallery
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Error picking image from gallery: $e');
      return null;
    }
  }

  // Ambil gambar dari kamera
  static Future<File?> takePhotoWithCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Error taking photo with camera: $e');
      return null;
    }
  }

  // Simpan gambar ke local storage
  static Future<String?> saveImageToLocal(
      File imageFile, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final String dirPath = directory.path;
      final String newPath = path.join(dirPath, fileName);

      // Copy file ke lokasi baru
      await imageFile.copy(newPath);
      return newPath;
    } catch (e) {
      print('Error saving image to local: $e');
      return null;
    }
  }

  // Hapus gambar dari local storage
  static Future<void> deleteImage(String? imagePath) async {
    if (imagePath != null) {
      try {
        final file = File(imagePath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        print('Error deleting image: $e');
      }
    }
  }

  // Cek apakah gambar ada
  static Future<bool> imageExists(String? imagePath) async {
    if (imagePath == null) return false;
    try {
      final file = File(imagePath);
      return await file.exists();
    } catch (e) {
      print('Error checking image existence: $e');
      return false;
    }
  }
}
