import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/feedback_model.dart';
import '../services/feedback_service.dart';
import '../widgets/rating_widget.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();

  String _studentName = '';
  String _studentId = '';
  String _selectedFacility = 'Perpustakaan';
  int _rating = 3;
  String _comments = '';

  final List<String> _facilityTypes = [
    'Perpustakaan',
    'Laboratorium',
    'Ruang Kelas',
    'Kantin',
    'Parkiran',
    'Olahraga',
    'Administrasi',
    'Wi-Fi Kampus',
  ];

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newFeedback = FeedbackModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        studentName: _studentName,
        studentId: _studentId,
        facilityType: _selectedFacility,
        rating: _rating,
        comments: _comments,
        date: DateTime.now(),
      );

      // Tambahkan feedback ke service
      final feedbackService = Provider.of<FeedbackService>(
        context,
        listen: false,
      );
      feedbackService.addFeedback(newFeedback);

      _showSuccessDialog();
      _resetForm();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terima Kasih!'),
        content: const Text('Feedback Anda telah berhasil dikirim.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _rating = 3;
      _selectedFacility = 'Perpustakaan';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Form Feedback Mahasiswa',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nama Mahasiswa',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap masukkan nama';
                        }
                        return null;
                      },
                      onSaved: (value) => _studentName = value!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'NIM',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.badge),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap masukkan NIM';
                        }
                        return null;
                      },
                      onSaved: (value) => _studentId = value!,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedFacility,
                      decoration: const InputDecoration(
                        labelText: 'Jenis Fasilitas',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_city),
                      ),
                      items: _facilityTypes.map((facility) {
                        return DropdownMenuItem(
                          value: facility,
                          child: Text(facility),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedFacility = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Rating Kepuasan:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RatingWidget(
                      initialRating: _rating,
                      onRatingChanged: (rating) {
                        setState(() {
                          _rating = rating;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Komentar dan Saran',
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
                      onSaved: (value) => _comments = value!,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitFeedback,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Kirim Feedback',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Consumer<FeedbackService>(
              builder: (context, feedbackService, child) {
                final latestFeedbacks = feedbackService.feedbacks
                    .take(3)
                    .toList();
                if (latestFeedbacks.isEmpty) {
                  return const SizedBox();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Feedback Terbaru:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...latestFeedbacks
                        .map(
                          (feedback) => Card(
                            color: Colors.blue[50],
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: const Icon(
                                Icons.feedback,
                                color: Colors.blue,
                              ),
                              title: Text(feedback.studentName),
                              subtitle: Text(feedback.facilityType),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  Text('${feedback.rating}'),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
