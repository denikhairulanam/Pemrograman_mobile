import 'package:flutter/material.dart';
import '../models/feedback_model.dart';

class FeedbackCard extends StatelessWidget {
  final FeedbackModel feedback;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const FeedbackCard({
    super.key,
    required this.feedback,
    required this.onTap,
    this.onDelete,
  });

  Color _getRatingColor(int rating) {
    switch (rating) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getRatingColor(feedback.rating),
          child: Text(
            feedback.rating.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          feedback.studentName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${feedback.facilityType} - ${feedback.studentId}'),
            const SizedBox(height: 4),
            Text(
              feedback.comments.length > 50
                  ? '${feedback.comments.substring(0, 50)}...'
                  : feedback.comments,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              _formatDate(feedback.date),
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onDelete != null) ...[
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                onPressed: onDelete,
              ),
              const SizedBox(width: 8),
            ],
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
