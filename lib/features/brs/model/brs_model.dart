class BrsModel {
  final String id;
  final String judul;
  final String tanggal;
  final String? abstrak;
  final String? file;
  final String? slide;
  final String? thumbnail;
  final String? kategori;
  final String? size;
  final List<BrsRelated> related;
  final List<BrsInfographic> infographics;

  const BrsModel({
    required this.id,
    required this.judul,
    required this.tanggal,
    this.abstrak,
    this.file,
    this.slide,
    this.thumbnail,
    this.kategori,
    this.size,
    this.related = const [],
    this.infographics = const [],
  });

  factory BrsModel.fromJson(Map<String, dynamic> json) {
    final relatedRaw = json['related'] as List? ?? [];
    final infographicsRaw = json['infographics'] as List? ?? [];
    return BrsModel(
      id: json['brs_id']?.toString() ?? '',
      judul: json['title'] ?? '',
      tanggal: json['rl_date'] ?? '',
      abstrak: json['abstract'],
      file: json['pdf'],
      slide: json['slide'],
      thumbnail: json['thumbnail'],
      kategori: json['subcsa'],
      size: json['size'],
      related: relatedRaw.map((e) => BrsRelated.fromJson(e)).toList(),
      infographics: infographicsRaw
          .map((e) => BrsInfographic.fromJson(e))
          .toList(),
    );
  }
}

class BrsRelated {
  final String id;
  final String judul;
  final String? tanggal;
  final String? thumbnail;
  final String? url;

  const BrsRelated({
    required this.id,
    required this.judul,
    this.tanggal,
    this.thumbnail,
    this.url,
  });

  factory BrsRelated.fromJson(Map<String, dynamic> json) {
    return BrsRelated(
      id: json['brs_id']?.toString() ?? '',
      judul: json['title'] ?? '',
      tanggal: json['rl_date'],
      thumbnail: json['thumbnail'],
      url: json['url'],
    );
  }
}

class BrsInfographic {
  final String judul;
  final String? image;

  const BrsInfographic({required this.judul, this.image});

  factory BrsInfographic.fromJson(Map<String, dynamic> json) {
    return BrsInfographic(judul: json['title'] ?? '', image: json['image']);
  }
}
