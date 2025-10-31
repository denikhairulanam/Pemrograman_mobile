// models/model_dosen.dart
class Dosen {
  final String nidn;
  final String nama;
  final String jurusan;
  final String email;
  final String foto;
  
  final List<FeedbackDosen> feedbacks;

  Dosen({
    required this.nidn,
    required this.nama,
    required this.jurusan,
    required this.email,
    required this.foto,
   
    this.feedbacks = const [],
  });

  Dosen copyWith({List<FeedbackDosen>? feedbacks}) {
    return Dosen(
      nidn: nidn,
      nama: nama,
      jurusan: jurusan,
      email: email,
      foto: foto,
      
      feedbacks: feedbacks ?? this.feedbacks,
    );
  }
}

class FeedbackDosen {
  final String nama;
  final String komentar;
  final double rating;
  final DateTime tanggal;

  FeedbackDosen({
    required this.nama,
    required this.komentar,
    required this.rating,
    required this.tanggal,
  });
}
