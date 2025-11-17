import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/feedback_model.dart';
import '../services/feedback_service.dart';
import '../widgets/feedback_card.dart';

class FeedbackList extends StatefulWidget {
  const FeedbackList({super.key});

  @override
  State<FeedbackList> createState() => _FeedbackListState();
}

class _FeedbackListState extends State<FeedbackList> {
  String _filterFacility = 'Semua';

  List<String> _getFacilityTypes(FeedbackService feedbackService) {
    final types = feedbackService.feedbacks
        .map((f) => f.facilityType)
        .toSet()
        .toList();
    types.insert(0, 'Semua');
    return types;
  }

  void _showFeedbackDetails(FeedbackModel feedback, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detail Feedback - ${feedback.facilityType}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nama: ${feedback.studentName}'),
              Text('NIM: ${feedback.studentId}'),
              Text('Fasilitas: ${feedback.facilityType}'),
              Row(
                children: [
                  const Text('Rating: '),
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  Text('${feedback.rating}/5'),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Komentar:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(feedback.comments),
              const SizedBox(height: 10),
              Text(
                'Tanggal: ${_formatDate(feedback.date)}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedbackService>(
      builder: (context, feedbackService, child) {
        final facilityTypes = _getFacilityTypes(feedbackService);
        final filteredFeedbacks = _filterFacility == 'Semua'
            ? feedbackService.feedbacks
            : feedbackService.feedbacks
                  .where((feedback) => feedback.facilityType == _filterFacility)
                  .toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Filter Berdasarkan Fasilitas:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButton<String>(
                        value: _filterFacility,
                        isExpanded: true,
                        items: facilityTypes.map((facility) {
                          return DropdownMenuItem(
                            value: facility,
                            child: Text(facility),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _filterFacility = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Total Feedback: ${filteredFeedbacks.length}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: filteredFeedbacks.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.feedback_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Belum ada feedback',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          Text(
                            'Silakan berikan feedback di halaman "Beri Feedback"',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: filteredFeedbacks.length,
                      itemBuilder: (context, index) {
                        final feedback = filteredFeedbacks[index];
                        return FeedbackCard(
                          feedback: feedback,
                          onTap: () => _showFeedbackDetails(feedback, context),
                          onDelete: () {
                            feedbackService.removeFeedback(feedback.id);
                          },
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
