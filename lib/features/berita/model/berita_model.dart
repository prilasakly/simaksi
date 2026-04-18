class BeritaModel {
  final String id;
  final String judul;
  final String tanggal;
  final String? gambar;
  final String? isi;
  final String? kategori;

  const BeritaModel({
    required this.id,
    required this.judul,
    required this.tanggal,
    this.gambar,
    this.isi,
    this.kategori,
  });

  factory BeritaModel.fromJson(Map<String, dynamic> json) {
    return BeritaModel(
      id: json['news_id']?.toString() ?? '',
      judul: json['title'] ?? '',
      tanggal: json['rl_date'] ?? '',
      gambar: json['picture'],
      isi: json['news'],
      kategori: json['newscat_name'],
    );
  }
}
