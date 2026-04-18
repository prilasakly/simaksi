class PublikasiModel {
  final String id;
  final String judul;
  final String? abstrak;
  final String? cover;
  final String? pdf;
  final String? issn;
  final String? rlDate;
  final String? schDate;
  final String? size;
  final List<RelatedPublikasi> related;

  const PublikasiModel({
    required this.id,
    required this.judul,
    this.abstrak,
    this.cover,
    this.pdf,
    this.issn,
    this.rlDate,
    this.schDate,
    this.size,
    this.related = const [],
  });

  /// Tahun dari rl_date (misal: "2026-04-06" → "2026")
  String get tahun {
    if (rlDate == null || rlDate!.isEmpty) return '';
    return rlDate!.split('-').first;
  }

  factory PublikasiModel.fromJson(Map<String, dynamic> json) {
    final relatedRaw = json['related'];
    final related = relatedRaw is List
        ? relatedRaw.map((e) => RelatedPublikasi.fromJson(e)).toList()
        : <RelatedPublikasi>[];

    return PublikasiModel(
      id: json['pub_id']?.toString() ?? '',
      judul: json['title'] ?? '',
      abstrak: json['abstract'],
      cover: json['cover'],
      pdf: json['pdf'],
      issn: json['issn'],
      rlDate: json['rl_date'],
      schDate: json['sch_date'],
      size: json['size'],
      related: related,
    );
  }
}

class RelatedPublikasi {
  final String id;
  final String judul;
  final String? rlDate;
  final String? url;
  final String? cover;

  const RelatedPublikasi({
    required this.id,
    required this.judul,
    this.rlDate,
    this.url,
    this.cover,
  });

  factory RelatedPublikasi.fromJson(Map<String, dynamic> json) {
    return RelatedPublikasi(
      id: json['pub_id']?.toString() ?? '',
      judul: json['title'] ?? '',
      rlDate: json['rl_date'],
      url: json['url'],
      cover: json['cover'],
    );
  }
}
