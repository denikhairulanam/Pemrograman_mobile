import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brewmate_coffee/services/mock_auth_service.dart';
import 'package:brewmate_coffee/screens/home_screen.dart';
import 'package:brewmate_coffee/screens/favorites_screen.dart';
import 'package:brewmate_coffee/screens/history_screen.dart';
import 'package:brewmate_coffee/screens/coffee_selection_screen.dart';
import 'package:brewmate_coffee/screens/settings_screen.dart';
import 'package:brewmate_coffee/theme/app_theme.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;

  const MainNavigation({super.key, this.initialIndex = 0});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // List of screens for bottom navigation
  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const FavoritesScreen(),
    const HistoryScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout(BuildContext context) async {
    // Temporarily just navigate to login without Firebase sign out
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _navigateToAddRecipe(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CoffeeSelectionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDarkMode
                    ? [
                        const Color(0xFF121212),
                        const Color(0xFF1E1E1E),
                      ]
                    : [
                        const Color(0xFF667EEA),
                        const Color(0xFF764BA2),
                      ],
              ),
            ),
          ),
          // Content
          Column(
            children: [
              // App Bar Custom
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDarkMode
                        ? [
                            AppTheme.darkSurface,
                            AppTheme.darkBackground,
                          ]
                        : [
                            AppTheme.lightPrimary,
                            AppTheme.lightSecondary,
                          ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode ? Colors.black : Colors.black12,
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: SafeArea(
                  bottom: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              _getNavIcon(_selectedIndex),
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) {
                                  return const LinearGradient(
                                    colors: [Colors.white, Colors.white70],
                                  ).createShader(bounds);
                                },
                                child: Text(
                                  _getNavTitle(_selectedIndex),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'Montserrat',
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              Text(
                                _getNavSubtitle(_selectedIndex),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (_selectedIndex != 3)
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.logout_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () => _showLogoutConfirmation(context),
                            tooltip: 'Logout',
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Screen Content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppTheme.darkSurface
                        : AppTheme.lightSurface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: _widgetOptions.elementAt(_selectedIndex),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _buildCustomBottomNavigationBar(context),
    );
  }

  Widget _buildCustomBottomNavigationBar(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return Container(
      height: kBottomNavigationBarHeight + 10,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.1),
            blurRadius: 15,
            spreadRadius: 5,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Home
          _buildNavItem(
            index: 0,
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: 'Home',
            isDarkMode: isDarkMode,
          ),

          // Favorites
          _buildNavItem(
            index: 1,
            icon: Icons.favorite_border_rounded,
            activeIcon: Icons.favorite_rounded,
            label: 'Favorit',
            isDarkMode: isDarkMode,
          ),

          // Tambah Resep (Center Button)
          Expanded(
            child: GestureDetector(
              onTap: () => _navigateToAddRecipe(context),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDarkMode
                        ? [
                            AppTheme.darkPrimary,
                            AppTheme.darkSecondary,
                          ]
                        : [
                            AppTheme.lightPrimary,
                            AppTheme.lightSecondary,
                          ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: (isDarkMode
                              ? const Color(0xFFBB86FC)
                              : const Color(0xFF667EEA))
                          .withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 3,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Buat',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // History
          _buildNavItem(
            index: 2,
            icon: Icons.history_outlined,
            activeIcon: Icons.history_rounded,
            label: 'Riwayat',
            isDarkMode: isDarkMode,
          ),

          // Settings
          _buildNavItem(
            index: 3,
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings_rounded,
            label: 'Settings',
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isDarkMode,
  }) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onItemTapped(index),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? (isDarkMode
                            ? AppTheme.darkPrimary
                            : AppTheme.lightPrimary)
                        : Colors.transparent,
                  ),
                  child: Icon(
                    isSelected ? activeIcon : icon,
                    color: isSelected
                        ? Colors.white
                        : (isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade600),
                    size: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: isSelected
                        ? (isDarkMode
                            ? const Color(0xFFBB86FC)
                            : const Color(0xFF667EEA))
                        : (isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade600),
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getNavIcon(int index) {
    switch (index) {
      case 0:
        return Icons.home_rounded;
      case 1:
        return Icons.favorite_rounded;
      case 2:
        return Icons.history_rounded;
      case 3:
        return Icons.settings_rounded;
      default:
        return Icons.home_rounded;
    }
  }

  String _getNavTitle(int index) {
    switch (index) {
      case 0:
        return 'BREWMATE';
      case 1:
        return 'FAVORIT';
      case 2:
        return 'RIWAYAT';
      case 3:
        return 'PENGATURAN';
      default:
        return 'BREWMATE';
    }
  }

  String _getNavSubtitle(int index) {
    switch (index) {
      case 0:
        return 'Your coffee companion';
      case 1:
        return 'Resep favorit Anda';
      case 2:
        return 'Catatan pembuatan kopi';
      case 3:
        return 'Atur preferensi Anda';
      default:
        return 'Your coffee companion';
    }
  }

  void _showLogoutConfirmation(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Colors.red,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Konfirmasi Keluar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Apakah Anda yakin ingin keluar dari akun ini?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                            isDarkMode ? Colors.white : Colors.black,
                        side: BorderSide(
                          color: isDarkMode
                              ? Colors.grey.shade600
                              : Colors.grey.shade300,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _logout(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Keluar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
