import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/shopping_item.dart';
import '../widgets/add_item_dialog.dart';
import '../widgets/category_chip.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({Key? key}) : super(key: key);

  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<ShoppingItem> _items = [];
  String _selectedCategory = 'Semua';
  final List<String> _categories = [
    'Semua',
    'Makanan',
    'Minuman',
    'Elektronik',
    'Pakaian',
    'Rumah Tangga',
    'Kesehatan',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final itemsString = prefs.getString('shopping_items');

      if (itemsString != null) {
        final List<dynamic> itemsJson = jsonDecode(itemsString);
        setState(() {
          _items = itemsJson
              .map((json) => ShoppingItem.fromJson(json))
              .toList();
        });
      }
    } catch (e) {
      print('Error loading items: $e');
      _showErrorSnackBar('Gagal memuat daftar belanja');
    }
  }

  Future<void> _saveItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'shopping_items',
        jsonEncode(_items.map((item) => item.toJson()).toList()),
      );
    } catch (e) {
      print('Error saving items: $e');
      _showErrorSnackBar('Gagal menyimpan daftar belanja');
    }
  }

  void _addItem(String name, int quantity, String category) {
    final newItem = ShoppingItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      quantity: quantity,
      category: category,
      isPurchased: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    setState(() {
      _items.add(newItem);
    });
    _saveItems();
    _showSuccessSnackBar('Item berhasil ditambahkan');
  }

  void _updateItem(int index, String name, int quantity, String category) {
    if (index >= 0 && index < _items.length) {
      setState(() {
        _items[index] = _items[index].copyWith(
          name: name,
          quantity: quantity,
          category: category,
          updatedAt: DateTime.now(),
        );
      });
      _saveItems();
      _showSuccessSnackBar('Item berhasil diperbarui');
    }
  }

  void _togglePurchaseStatus(int index) {
    if (index >= 0 && index < _items.length) {
      setState(() {
        _items[index] = _items[index].copyWith(
          isPurchased: !_items[index].isPurchased,
          updatedAt: DateTime.now(),
        );
      });
      _saveItems();
    }
  }

  void _deleteItem(int index) {
    if (index >= 0 && index < _items.length) {
      final itemName = _items[index].name;
      setState(() {
        _items.removeAt(index);
      });
      _saveItems();
      _showSuccessSnackBar('$itemName berhasil dihapus');
    }
  }

  void _showDeleteDialog(int index) {
    if (index < 0 || index >= _items.length) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Item'),
        content: Text('Yakin ingin menghapus "${_items[index].name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              _deleteItem(index);
              Navigator.pop(context);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog({int? index}) {
    final isEdit = index != null;

    showDialog(
      context: context,
      builder: (context) => AddItemDialog(
        onSave: (name, quantity, category) {
          if (isEdit) {
            _updateItem(index!, name, quantity, category);
          } else {
            _addItem(name, quantity, category);
          }
        },
        initialName: isEdit ? _items[index!].name : null,
        initialQuantity: isEdit ? _items[index!].quantity : null,
        initialCategory: isEdit ? _items[index!].category : null,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  List<ShoppingItem> get _filteredItems {
    if (_selectedCategory == 'Semua') {
      return _items;
    }
    return _items.where((item) => item.category == _selectedCategory).toList();
  }

  int get _purchasedCount {
    return _items.where((item) => item.isPurchased).length;
  }

  int get _notPurchasedCount {
    return _items.where((item) => !item.isPurchased).length;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _filteredItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Belanja'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Statistik'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Item: ${_items.length}'),
                      Text('Sudah Dibeli: $_purchasedCount'),
                      Text('Belum Dibeli: $_notPurchasedCount'),
                      const SizedBox(height: 16),
                      if (_items.isNotEmpty)
                        Text(
                          'Progress: ${((_purchasedCount / _items.length) * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tutup'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Kategori:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CategoryChip(
                          category: category,
                          isSelected: _selectedCategory == category,
                          onTap: () {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Statistics
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      'Total',
                      _filteredItems.length.toString(),
                      Colors.blue,
                    ),
                    _buildStatItem(
                      'Sudah',
                      _filteredItems
                          .where((item) => item.isPurchased)
                          .length
                          .toString(),
                      Colors.green,
                    ),
                    _buildStatItem(
                      'Belum',
                      _filteredItems
                          .where((item) => !item.isPurchased)
                          .length
                          .toString(),
                      Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Items List
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _selectedCategory == 'Semua'
                              ? 'Belum ada item belanja'
                              : 'Tidak ada item dalam kategori $_selectedCategory',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tekan + untuk menambahkan item',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];

                      return Card(
                        key: ValueKey(item.id),
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        color: item.isPurchased ? Colors.green.shade50 : null,
                        child: ListTile(
                          leading: Checkbox(
                            value: item.isPurchased,
                            onChanged: (_) => _togglePurchaseStatus(
                              _items.indexWhere((i) => i.id == item.id),
                            ),
                          ),
                          title: Text(
                            item.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: item.isPurchased
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: item.isPurchased
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Jumlah: ${item.quantity}'),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getCategoryColor(
                                        item.category,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      item.category,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _getCategoryColor(item.category),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    _formatDate(item.updatedAt),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _showDeleteDialog(
                              _items.indexWhere((i) => i.id == item.id),
                            ),
                          ),
                          onTap: () => _showAddItemDialog(
                            index: _items.indexWhere((i) => i.id == item.id),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Color _getCategoryColor(String category) {
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
}
