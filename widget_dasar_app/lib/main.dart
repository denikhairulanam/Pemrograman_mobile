import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ProfileScreen(),
    );
  }
}
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(115, 127, 214, 1), 
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header dengan gradient
              Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF6A11CB), // Ungu tua
                      Color(0xFF2575FC), // Biru muda
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text(
                    'My Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Card Profil
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Image Profile
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFF6A11CB),
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/deni.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person,
                                size: 60,
                                color: Color(0xFF6A11CB),
                              );
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      // Text Nama
                      Text(
                        'Deni Khairul Anam',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),

                      SizedBox(height: 8),

                      // Text Pekerjaan
                      Text(
                        'NIM: 701230058',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF666666),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Column untuk detail profil
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(
                            Icons.email,
                            'denikhairulanam@gmail.com',
                          ),
                          SizedBox(height: 12),
                          _buildDetailRow(Icons.phone, '+62 852-1274-8146'),
                          SizedBox(height: 12),
                          _buildDetailRow(
                            Icons.location_on,
                            'Sri Agung, Kec.Batang Asam, Kab. Tanjabbar',
                          ),
                        ],
                      ),

                      SizedBox(height: 25),

                      // Row untuk Button
                      Row(
                        children: [
                          Expanded(
                            child: _buildButton(
                              'Edit Profile',
                              Icons.edit,
                              Color(0xFF6A11CB),
                              Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Additional Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Color(0xFFE3F2FD), // Biru sangat muda
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About Me',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Saya adalah seorang mahasiswa sistem informasi yang masih belajar dalam membuat aplikasi mobile yang dapat mempermudah penggunanya dalam pengoprasian aplikasiyang saya buat.',
                        style: TextStyle(color: Color(0xFF424242)),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk membuat baris detail
  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF6A11CB), size: 20),
        SizedBox(width: 12),
        Text(text, style: TextStyle(color: Color(0xFF333333))),
      ],
    );
  }

  // Widget untuk membuat button
  Widget _buildButton(
    String text,
    IconData icon,
    Color backgroundColor,
    Color textColor,
  ) {
    return ElevatedButton(
      onPressed: () {
        // Aksi ketika button ditekan
        print('$text button pressed');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(icon, size: 18), SizedBox(width: 8), Text(text)],
      ),
    );
  }
}
