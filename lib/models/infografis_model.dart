class InfografisModel {
  final String id;
  final String judul;
  final String? gambar;
  final String? deskripsi;
  final String? file;
  final int? kategori;

  const InfografisModel({
    required this.id,
    required this.judul,
    this.gambar,
    this.deskripsi,
    this.file,
    this.kategori,
  });

  factory InfografisModel.fromJson(Map<String, dynamic> json) {
    return InfografisModel(
      id: json['inf_id']?.toString() ?? '',
      judul: json['title'] ?? '',
      gambar: json['img'],
      deskripsi: json['desc'],
      file: json['dl'],
      kategori: json['category'],
    );
  }
}
