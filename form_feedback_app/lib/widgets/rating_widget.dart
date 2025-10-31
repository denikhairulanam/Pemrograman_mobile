// widgets/rating_widget.dart
import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final double size;
  final bool showLabel;

  const RatingWidget({
    super.key,
    required this.rating,
    this.size = 16.0,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, color: Colors.amber, size: size),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(fontSize: size - 2, fontWeight: FontWeight.bold),
        ),
        if (showLabel) ...[
          const SizedBox(width: 4),
          Text(
            '(${rating.toStringAsFixed(1)})',
            style: TextStyle(fontSize: size - 4, color: Colors.grey),
          ),
        ],
      ],
    );
  }
}
