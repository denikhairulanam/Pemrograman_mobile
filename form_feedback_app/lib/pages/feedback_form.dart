// pages/feedback_form.dart
import 'package:flutter/material.dart';
import '../models/model_dosen.dart';
import '../data/data_dosen.dart';
import 'dosen_list_page.dart';

class FeedbackFormPage extends StatefulWidget {
  final String? dosenNidn;

  const FeedbackFormPage({super.key, this.dosenNidn});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _komentarController = TextEditingController();
  double _rating = 5.0;
  Dosen? _selectedDosen;
  List<Dosen> _listDosen = [];

  @override
  void initState() {
    super.initState();
    _listDosen = DosenData.getDosenList();

    // Jika ada dosenNidn, cari dosen yang sesuai dari _listDosen
    if (widget.dosenNidn != null) {
      _selectedDosen = _findDosenByNidn(widget.dosenNidn!);
    }
  }

  // Method untuk mencari dosen dari _listDosen berdasarkan NIDN
  Dosen? _findDosenByNidn(String nidn) {
    try {
      return _listDosen.firstWhere((dosen) => dosen.nidn == nidn);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Feedback Dosen'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pilih Dosen
              const Text(
                'Pilih Dosen:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<Dosen>(
                  value: _selectedDosen,
                  isExpanded: true,
                  underline: const SizedBox(),
                  hint: const Text('Pilih dosen...'),
                  items: _listDosen.map((dosen) {
                    return DropdownMenuItem<Dosen>(
                      value: dosen,
                      child: Text(dosen.nama, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: (Dosen? newValue) {
                    setState(() {
                      _selectedDosen = newValue;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Form Nama
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Anda',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan nama Anda';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Rating
              const Text(
                'Rating:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    _rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Slider(
                      value: _rating,
                      min: 1.0,
                      max: 5.0,
                      divisions: 8,
                      label: _rating.toStringAsFixed(1),
                      onChanged: (value) {
                        setState(() {
                          _rating = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  return Icon(
                    index < _rating.round() ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 30,
                  );
                }),
              ),
              const SizedBox(height: 16),

              // Komentar
              TextFormField(
                controller: _komentarController,
                decoration: const InputDecoration(
                  labelText: 'Komentar',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan komentar';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Kirim Feedback',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              // Tombol Lihat Daftar Dosen
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DosenListPage(),
                      ),
                    );
                  },
                  child: const Text('Lihat Daftar Dosen'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDosen == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harap pilih dosen terlebih dahulu'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final feedback = FeedbackDosen(
        nama: _namaController.text,
        komentar: _komentarController.text,
        rating: _rating,
        tanggal: DateTime.now(),
      );

      // Gunakan NIDN untuk menambahkan feedback
      DosenData.addFeedback(_selectedDosen!.nidn, feedback);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Feedback berhasil dikirim untuk ${_selectedDosen!.nama}',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      // Reset form
      _resetForm();
    }
  }

  void _resetForm() {
    _namaController.clear();
    _komentarController.clear();
    setState(() {
      _rating = 5.0;
      // Hanya reset _selectedDosen jika tidak berasal dari halaman detail
      if (widget.dosenNidn == null) {
        _selectedDosen = null;
      } else {
        // Jika berasal dari halaman detail, pastikan _selectedDosen tetap merujuk ke objek yang sama
        _selectedDosen = _findDosenByNidn(widget.dosenNidn!);
      }
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _komentarController.dispose();
    super.dispose();
  }
}
