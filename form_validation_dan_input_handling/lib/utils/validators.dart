class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }

    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }

    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }

    if (value != password) {
      return 'Konfirmasi password tidak sama';
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }

    if (value.length < 2) {
      return 'Nama minimal 2 karakter';
    }

    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }

    final phoneRegex = RegExp(r'^[0-9+\-\s]{10,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Format nomor telepon tidak valid';
    }

    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }

    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Umur tidak boleh kosong';
    }

    final age = int.tryParse(value);
    if (age == null) {
      return 'Umur harus berupa angka';
    }

    if (age < 1 || age > 120) {
      return 'Umur harus antara 1-120 tahun';
    }

    return null;
  }
}
