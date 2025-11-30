import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    Key? key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Makanan':
        return Colors.green;
      case 'Minuman':
        return Colors.blue;
      case 'Elektronik':
        return Colors.orange;
      case 'Pakaian':
        return Colors.purple;
      case 'Rumah Tangga':
        return Colors.brown;
      case 'Kesehatan':
        return Colors.red;
      case 'Lainnya':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(category),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: getCategoryColor(category).withOpacity(0.1),
      selectedColor: getCategoryColor(category).withOpacity(0.3),
      labelStyle: TextStyle(
        color: isSelected ? getCategoryColor(category) : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      checkmarkColor: getCategoryColor(category),
    );
  }
}
