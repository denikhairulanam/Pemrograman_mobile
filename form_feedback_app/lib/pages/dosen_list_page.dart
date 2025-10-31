// pages/dosen_list_page.dart
import 'package:flutter/material.dart';
import '../models/model_dosen.dart';
import '../data/data_dosen.dart';
import '../widgets/rating_widget.dart';
import 'dosen_detail_page.dart';
import 'feedback_form.dart';

class DosenListPage extends StatelessWidget {
  const DosenListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Dosen> listDosen = DosenData.getDosenList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Dosen',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.feedback),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FeedbackFormPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: listDosen.length,
          itemBuilder: (context, index) {
            final dosen = listDosen[index];
            final averageRating = DosenData.getAverageRating(dosen);
            final feedbackCount = dosen.feedbacks.length;

            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        dosen.nama.substring(0, 1),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dosen.nama,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dosen.jurusan,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          if (feedbackCount > 0)
                            Row(
                              children: [
                                RatingWidget(rating: averageRating, size: 14),
                                const SizedBox(width: 8),
                                Text(
                                  '($feedbackCount review)',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            )
                          else
                            const Text(
                              'Belum ada rating',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.feedback_outlined),
                          color: Colors.blue,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FeedbackFormPage(dosenNidn: dosen.nidn),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.visibility),
                          color: Colors.green,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DosenDetailPage(dosen: dosen),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FeedbackFormPage()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.feedback, color: Colors.white),
      ),
    );
  }
}
