import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:brewmate_coffee/theme/app_theme.dart';

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  bool _isLoading = false;

  Future<void> _requestLocationPermission() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Request permission
      final status = await Permission.location.request();

      print('📍 Permission status: $status');

      if (status.isGranted || status.isLimited) {
        // Permission granted, navigate to main
        print('✅ Location permission granted');
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/main');
        }
      } else if (status.isPermanentlyDenied) {
        // Show dialog to open settings
        _showSettingsDialog();
      } else {
        // Permission denied, but still navigate to main (app will work with fallback)
        print('⚠️ Location permission denied, proceeding anyway');
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/main');
        }
      }
    } catch (e) {
      print('❌ Permission error: $e');
      // Navigate anyway
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/main');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Izin Lokasi Diperlukan'),
        content: const Text(
          'Izin lokasi diperlukan untuk mendapatkan informasi cuaca yang akurat. '
          'Silakan aktifkan izin lokasi di pengaturan perangkat Anda.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate without permission
              Navigator.pushReplacementNamed(context, '/main');
            },
            child: const Text('Lewati'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Buka Pengaturan'),
          ),
        ],
      ),
    );
  }

  void _skipLocationPermission() {
    Navigator.pushReplacementNamed(context, '/main');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightPrimary,
              AppTheme.lightSecondary,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 40),

                // Title
                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [Colors.white, Colors.white70],
                    ).createShader(bounds);
                  },
                  child: const Text(
                    'Izin Lokasi',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 16),

                // Subtitle
                Text(
                  'Dapatkan rekomendasi kopi berdasarkan cuaca di lokasi Anda',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w300,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                if (_isLoading) ...[
                  const SizedBox(height: 30),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Mengatur izin lokasi...',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],

                const SizedBox(height: 60),

                // Features
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildFeatureItem(
                        icon: Icons.wb_sunny_rounded,
                        text: 'Rekomendasi kopi berdasarkan cuaca',
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureItem(
                        icon: Icons.thermostat_rounded,
                        text: 'Informasi suhu dan kelembaban',
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureItem(
                        icon: Icons.location_city_rounded,
                        text: 'Kopi lokal sesuai kondisi sekitar',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // Allow Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _requestLocationPermission,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.lightPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Izinkan Lokasi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Skip Button
                TextButton(
                  onPressed: _isLoading ? null : _skipLocationPermission,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white.withOpacity(0.8),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                  ),
                  child: const Text(
                    'Lewati untuk sekarang',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.2),
          ),
          child: Icon(
            icon,
            size: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
