import 'package:flutter/material.dart';

class NoteDialog extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final bool isEdit;
  final VoidCallback onSave;

  const NoteDialog({
    Key? key,
    required this.titleController,
    required this.contentController,
    required this.isEdit,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEdit ? 'Edit Catatan' : 'Tambah Catatan'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
              autofocus: !isEdit,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(
                labelText: 'Konten',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              minLines: 3,
              textInputAction: TextInputAction.newline,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: onSave,
          child: Text(isEdit ? 'Update' : 'Simpan'),
        ),
      ],
    );
  }
}
