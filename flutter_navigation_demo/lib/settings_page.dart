import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Tema'),
            subtitle: const Text('Ubah tema aplikasi'),
            onTap: () {
              // Aksi untuk mengubah tema
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Bahasa'),
            subtitle: const Text('Ubah bahasa aplikasi'),
            onTap: () {
              // Aksi untuk mengubah bahasa
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifikasi'),
            subtitle: const Text('Kelola pengaturan notifikasi'),
            onTap: () {
              // Aksi untuk notifikasi
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Privasi'),
            subtitle: const Text('Pengaturan privasi dan keamanan'),
            onTap: () {
              // Aksi untuk privasi
            },
          ),
        ],
      ),
    );
  }
}
