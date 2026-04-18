class BrsModel {
  final String id;
  final String judul;
  final String tanggal;
  final String? abstrak;
  final String? file;
  final String? slide;
  final String? thumbnail;
  final String? kategori;

  const BrsModel({
    required this.id,
    required this.judul,
    required this.tanggal,
    this.abstrak,
    this.file,
    this.slide,
    this.thumbnail,
    this.kategori,
  });

  factory BrsModel.fromJson(Map<String, dynamic> json) {
    return BrsModel(
      id: json['brs_id']?.toString() ?? '',
      judul: json['title'] ?? '',
      tanggal: json['rl_date'] ?? '',
      abstrak: json['abstract'],
      file: json['pdf'],
      slide: json['slide'],
      thumbnail: json['thumbnail'],
      kategori: json['subcsa'], // kategori BRS
    );
  }
}
