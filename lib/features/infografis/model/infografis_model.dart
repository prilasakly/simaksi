import 'package:simaksi/core/utils/clean_html.dart';

class InfografisModel {
  final int id;
  final String judul;
  final String? gambar;
  final String? deskripsi;
  final String? fileUrl;
  final String? tanggal;
  final InfografisKategori kategori;

  const InfografisModel({
    required this.id,
    required this.judul,
    this.gambar,
    this.deskripsi,
    this.fileUrl,
    this.tanggal,
    this.kategori = InfografisKategori.umum,
  });

  // ── Factory ───────────────────────────────────────────────
  factory InfografisModel.fromJson(Map<String, dynamic> json) {
    return InfografisModel(
      id: json['inf_id'] is int
          ? json['inf_id']
          : int.tryParse(json['inf_id']?.toString() ?? '0') ?? 0,
      judul: json['title'] ?? '',
      gambar: json['img'],
      deskripsi: json['desc'],
      fileUrl: json['dl'],
      tanggal: json['date'],
      kategori: InfografisKategori.fromCode(json['category']),
    );
  }

  // ── Helpers ───────────────────────────────────────────────

  /// Tahun dari tanggal (misal: "2026-04-01" → "2026")
  String get tahun {
    if (tanggal == null || tanggal!.isEmpty) return '';
    return tanggal!.split('-').first;
  }

  /// Format tanggal ke "01 Apr 2026"
  String get tanggalFormatted {
    if (tanggal == null || tanggal!.isEmpty) return '';
    try {
      final parts = tanggal!.split('-');
      if (parts.length < 3) return tanggal!;
      final bulan = _bulanSingkat[int.parse(parts[1])] ?? parts[1];
      return '${parts[2]} $bulan ${parts[0]}';
    } catch (_) {
      return tanggal!;
    }
  }

  /// Apakah ada file untuk diunduh
  bool get bisaDiunduh => fileUrl != null && fileUrl!.isNotEmpty;

  /// Apakah ada gambar
  bool get adaGambar => gambar != null && gambar!.isNotEmpty;

  /// Deskripsi bersih (tanpa markdown * dan spasi berlebih)
  String get deskripsiFormatted {
    return deskripsi.cleanHtml();
  }

  static const _bulanSingkat = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'Mei',
    6: 'Jun',
    7: 'Jul',
    8: 'Agu',
    9: 'Sep',
    10: 'Okt',
    11: 'Nov',
    12: 'Des',
  };
}

// ── Kategori Enum ─────────────────────────────────────────────
enum InfografisKategori {
  umum(0, 'Umum'),
  sosial(1, 'Sosial'),
  ekonomi(2, 'Ekonomi'),
  lingkungan(3, 'Lingkungan'),
  lainnya(-1, 'Lainnya');

  const InfografisKategori(this.code, this.label);

  final int code;
  final String label;

  factory InfografisKategori.fromCode(dynamic code) {
    final c = code is int ? code : int.tryParse(code?.toString() ?? '') ?? -1;
    return InfografisKategori.values.firstWhere(
      (e) => e.code == c,
      orElse: () => InfografisKategori.lainnya,
    );
  }
}
