import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/feedback_service.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  Color _getRatingColor(double rating) {
    if (rating >= 4) return Colors.green;
    if (rating >= 3) return Colors.blue;
    if (rating >= 2) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedbackService>(
      builder: (context, feedbackService, child) {
        final facilityStats = feedbackService.getFacilityStats();
        final ratingDistribution = feedbackService.getRatingDistribution();
        final totalFeedbacks = feedbackService.feedbacks.length;
        final averageRating = feedbackService.averageRating;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.analytics, size: 50, color: Colors.blue),
                      const SizedBox(height: 10),
                      const Text(
                        'Statistik Feedback Kampus',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatCard(
                            'Total Feedback',
                            totalFeedbacks.toString(),
                            Icons.feedback,
                            Colors.green,
                          ),
                          _buildStatCard(
                            'Rata-rata Rating',
                            averageRating.toStringAsFixed(1),
                            Icons.star,
                            Colors.amber,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rating per Fasilitas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (facilityStats.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Text(
                            'Belum ada data statistik',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      else
                        ...facilityStats.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: Text(entry.key)),
                                Expanded(
                                  flex: 3,
                                  child: LinearProgressIndicator(
                                    value: entry.value / 5,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      _getRatingColor(entry.value),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '${entry.value}',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _getRatingColor(entry.value),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Distribusi Rating',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (totalFeedbacks == 0)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Text(
                            'Belum ada data distribusi',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      else
                        ...ratingDistribution.entries.map((entry) {
                          final percentage =
                              (entry.value / totalFeedbacks) * 100;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    ...List.generate(entry.key, (index) {
                                      return const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      );
                                    }),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: entry.value / totalFeedbacks,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      _getRatingColor(entry.key.toDouble()),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '${entry.value} (${percentage.toStringAsFixed(1)}%)',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, size: 30, color: color),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
