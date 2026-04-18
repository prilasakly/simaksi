class PublikasiModel {
  final String id;
  final String judul;
  final String tahun;
  final String? cover;
  final String? abstrak;
  final String? file;
  final String? issn;
  final String? ukuran;

  const PublikasiModel({
    required this.id,
    required this.judul,
    required this.tahun,
    this.cover,
    this.abstrak,
    this.file,
    this.issn,
    this.ukuran,
  });

  factory PublikasiModel.fromJson(Map<String, dynamic> json) {
    final date = json['rl_date'] ?? '';

    return PublikasiModel(
      id: json['pub_id']?.toString() ?? '',
      judul: json['title'] ?? '',
      tahun: date.toString().isNotEmpty ? date.toString().substring(0, 4) : '',
      cover: json['cover'] ?? json['img'],
      abstrak: json['abstract'] ?? json['abstraksi'],
      file: json['pdf'] ?? json['file'],
      issn: json['issn'],
      ukuran: json['size'],
    );
  }
}
