import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../models/user.dart';
import '../utils/validators.dart';
import '../utils/image_picker_utils.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/loading_button.dart';
import 'survey_screen.dart';
import 'survey_summary_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();

  String _email = '';
  DateTime _birthDate = DateTime.now().subtract(const Duration(days: 365 * 20));
  String _gender = 'Laki-laki';
  bool _isLoading = false;
  File? _profileImage;
  String? _profileImagePath;

  final List<String> _genders = ['Laki-laki', 'Perempuan'];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('user_email') ?? 'user@example.com';
      final userData = prefs.getString('user_data');

      setState(() {
        _email = userEmail;
      });

      if (userData != null) {
        final userMap = json.decode(userData);
        final user = User.fromJson(userMap);

        setState(() {
          _nameController.text = user.name;
          _phoneController.text = user.phone;
          _bioController.text = user.bio;
          _birthDate = user.birthDate;
          _gender = user.gender;
          _profileImagePath = user.profileImagePath;
        });

        // Load profile image jika ada
        if (_profileImagePath != null) {
          final imageFile = File(_profileImagePath!);
          if (await imageFile.exists()) {
            setState(() {
              _profileImage = imageFile;
            });
          }
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  // Method untuk memilih foto profil
  Future<void> _pickProfileImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Pilih dari Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  await _getImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Ambil Foto'),
                onTap: () async {
                  Navigator.pop(context);
                  await _getImageFromCamera();
                },
              ),
              if (_profileImage != null)
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title:
                      Text('Hapus Foto', style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    Navigator.pop(context);
                    await _removeProfileImage();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getImageFromGallery() async {
    try {
      final File? imageFile = await ImagePickerUtils.pickImageFromGallery();
      if (imageFile != null) {
        // Hapus foto lama jika ada
        if (_profileImagePath != null) {
          await ImagePickerUtils.deleteImage(_profileImagePath);
        }

        // Simpan foto baru
        final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedPath =
            await ImagePickerUtils.saveImageToLocal(imageFile, fileName);

        if (savedPath != null) {
          setState(() {
            _profileImage = File(savedPath);
            _profileImagePath = savedPath;
          });
        }
      }
    } catch (e) {
      _showErrorSnackBar('Gagal memilih gambar: $e');
    }
  }

  Future<void> _getImageFromCamera() async {
    try {
      final File? imageFile = await ImagePickerUtils.takePhotoWithCamera();
      if (imageFile != null) {
        // Hapus foto lama jika ada
        if (_profileImagePath != null) {
          await ImagePickerUtils.deleteImage(_profileImagePath);
        }

        // Simpan foto baru
        final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedPath =
            await ImagePickerUtils.saveImageToLocal(imageFile, fileName);

        if (savedPath != null) {
          setState(() {
            _profileImage = File(savedPath);
            _profileImagePath = savedPath;
          });
        }
      }
    } catch (e) {
      _showErrorSnackBar('Gagal mengambil foto: $e');
    }
  }

  Future<void> _removeProfileImage() async {
    if (_profileImagePath != null) {
      await ImagePickerUtils.deleteImage(_profileImagePath);
    }

    setState(() {
      _profileImage = null;
      _profileImagePath = null;
    });

    _showSuccessSnackBar('Foto profil berhasil dihapus');
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    try {
      final user = User(
        name: _nameController.text,
        email: _email,
        phone: _phoneController.text,
        bio: _bioController.text,
        birthDate: _birthDate,
        gender: _gender,
        password: '', // Password disimpan terpisah
        profileImagePath: _profileImagePath,
      );

      final prefs = await SharedPreferences.getInstance();
      // Simpan data user yang diupdate
      final userData = {
        'name': user.name,
        'email': user.email,
        'phone': user.phone,
        'bio': user.bio,
        'birthDate': user.birthDate.toIso8601String(),
        'gender': user.gender,
        'password': prefs.getString('user_password') ?? '',
        'profileImagePath': user.profileImagePath,
      };

      await prefs.setString('user_data', json.encode(userData));

      if (!mounted) return;

      _showSuccessSnackBar('Profile berhasil disimpan!');
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar('Gagal menyimpan profile: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Saya'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'survey':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SurveyScreen()),
                  );
                  break;
                case 'summary':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SurveySummaryScreen()),
                  );
                  break;
                case 'logout':
                  _logout();
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'survey',
                  child: const Row(
                    children: [
                      Icon(Icons.assignment, size: 20),
                      SizedBox(width: 8),
                      Text('Isi Survey'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'summary',
                  child: const Row(
                    children: [
                      Icon(Icons.analytics, size: 20),
                      SizedBox(width: 8),
                      Text('Ringkasan Survey'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: const Row(
                    children: [
                      Icon(Icons.logout, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Logout', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Photo dengan fitur upload
              Stack(
                children: [
                  GestureDetector(
                    onTap: _pickProfileImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      child: _profileImage == null
                          ? Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey.shade600,
                            )
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickProfileImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Tap foto untuk mengubah',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),

              // Quick Actions
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SurveyScreen()),
                        );
                      },
                      icon: const Icon(Icons.assignment),
                      label: const Text('Isi Survey'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SurveySummaryScreen()),
                        );
                      },
                      icon: const Icon(Icons.analytics),
                      label: const Text('Lihat Ringkasan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              CustomTextField(
                controller: _nameController,
                label: 'Nama Lengkap',
                validator: Validators.validateName,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: TextEditingController(text: _email),
                label: 'Email',
                enabled: false,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _phoneController,
                label: 'Nomor Telepon',
                keyboardType: TextInputType.phone,
                validator: Validators.validatePhone,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _bioController,
                label: 'Bio',
                maxLines: 3,
                validator: (value) => Validators.validateRequired(value, 'Bio'),
              ),
              const SizedBox(height: 16),

              // Birth Date
              GestureDetector(
                onTap: _selectDate,
                child: AbsorbPointer(
                  child: CustomTextField(
                    controller: TextEditingController(
                      text: DateFormat('dd/MM/yyyy').format(_birthDate),
                    ),
                    label: 'Tanggal Lahir',
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Gender Dropdown
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: InputDecoration(
                  labelText: 'Jenis Kelamin',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: _genders.map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _gender = newValue!;
                  });
                },
                validator: (value) =>
                    value == null ? 'Pilih jenis kelamin' : null,
              ),
              const SizedBox(height: 32),

              LoadingButton(
                onPressed: _saveProfile,
                text: 'Simpan Profile',
                isLoading: _isLoading,
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
