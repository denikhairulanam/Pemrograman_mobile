// data/data_dosen.dart
import '../models/model_dosen.dart';

class DosenData {
  static List<Dosen> _listDosen = [
    Dosen(
      nidn: '19710415 200012 1 001',
      nama: 'Hery Afriadi, SE, S.Kom, M.Si',
      jurusan: 'Sistem Informasi',
      email: 'hery.afriadi@university.ac.id',
      foto: 'assets/images/dosen1.jpg',
      feedbacks: [
        
      ],
    ),
    Dosen(
      nidn: '19880722 202203 1 001',
      nama: 'Ahmad Nasukha, S.Hum, M.Si',
      jurusan: 'Sistem Informasi',
      email: 'ahmad.nasukha@university.ac.id',
      foto: 'assets/images/dosen2.jpg',
      feedbacks: [
        
      ],
    ),
    Dosen(
      nidn: '1571082309960021',
      nama: 'Wahyu Anggoro, M.Kom',
      jurusan: 'Sistem Informasi',
      email: 'wahyu.anggoro@university.ac.id',
      foto: 'assets/images/dosen3.jpg',
      feedbacks: [],
    ),
  ];

  static List<Dosen> getDosenList() {
    return _listDosen;
  }

  static void addFeedback(String nidn, FeedbackDosen feedback) {
    final index = _listDosen.indexWhere((dosen) => dosen.nidn == nidn);
    if (index != -1) {
      final updatedFeedbacks = List<FeedbackDosen>.from(
        _listDosen[index].feedbacks,
      )..add(feedback);
      _listDosen[index] = _listDosen[index].copyWith(
        feedbacks: updatedFeedbacks,
      );
    }
  }

  static double getAverageRating(Dosen dosen) {
    if (dosen.feedbacks.isEmpty) return 0.0;
    final totalRating = dosen.feedbacks
        .map((f) => f.rating)
        .reduce((a, b) => a + b);
    return totalRating / dosen.feedbacks.length;
  }

  static Dosen? getDosenByNidn(String nidn) {
    try {
      return _listDosen.firstWhere((dosen) => dosen.nidn == nidn);
    } catch (e) {
      return null;
    }
  }
}
