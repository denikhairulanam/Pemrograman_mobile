import '../models/model_dosen.dart';

class DosenData {
  static List<Dosen> getDosenList() {
    return [
      Dosen(
        nidn: '19710415 200012 1 001',
        nama: 'Hery Afriadi, SE, S.Kom, M.Si',
        jurusan: 'Sistem Informasi',
        email: 'sultan tahasaifuddin jambi@university.ac.id',
        foto: 'assets/images/dosen1.jpg',
        pendidikan: 'S3 Computer Science, Universitas Indonesia',
        bidangKeahlian: 'Artificial Intelligence, Data Mining',
      ),
      Dosen(
        nidn: '19880722 202203 1 001',
        nama: 'Ahmad Nasukha, S.Hum, M.Si',
        jurusan: 'Sistem Informasi',
        email: 'sultan tahasaifuddin jambi@university.ac.id',
        foto: 'assets/images/dosen2.jpg',
        pendidikan: 'S3 Computer Science, Universitas Indonesia',
        bidangKeahlian: 'Artificial Intelligence, Data Mining',
      ),
      Dosen(
        nidn: '1571082309960021',
        nama: 'Wahyu Anggoro, M.Kom',
        jurusan: 'Sistem Informasi',
        email: 'sultan tahasaifuddin jambi@university.ac.id',
        foto: 'assets/images/dosen3.jpg',
        pendidikan: 'S3 Computer Science, Universitas Indonesia',
        bidangKeahlian: 'Artificial Intelligence, Data Mining',
      ),

    ];
  }
}