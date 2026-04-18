// lib/api/api_endpoints.dart
// ============================================================
// SIMAKSI - BPS API Endpoints
// Semua URL API BPS ada di sini. Ganti baseUrl sesuai domain.
// Dokumentasi API BPS: https://webapi.bps.go.id/documentation/
// ============================================================

class ApiEndpoints {
  ApiEndpoints._();

  // ── Base Configuration ────────────────────────────────────
  /// Base URL API BPS (ganti dengan domain kabupaten)
  static const String baseUrl = 'https://webapi.bps.go.id/v1';

  /// Domain BPS Kabupaten Sukabumi
  static const String localBaseUrl = 'https://sukabumikab.bps.go.id/api';

  /// API Key BPS (isi dengan key yang didapat dari webapi.bps.go.id)
  static const String apiKey = '36e80d5b1dc35c8127b134a3c6739b2a';

  /// Kode wilayah BPS Kabupaten Sukabumi
  static const String wilayahKode = '3202';

  // ── Berita / News ─────────────────────────────────────────
  static const String berita = '/api/list';
  static const String beritaDetail = '/api/view';

  // ── Publikasi ─────────────────────────────────────────────
  static const String publikasi = '/api/list';
  static const String publikasiDetail = '/api/view';

  // ── BRS (Berita Resmi Statistik) ──────────────────────────
  static const String brs = '/api/list';
  static const String brsDetail = '/api/view';

  // ── Infografis ────────────────────────────────────────────
  static const String infografis = '/api/list/';

  // ──── SDGs ────────────────────────────────────────────────
  static const String sdgs = '/api/list/';

  // ── Indikator / Statistik ─────────────────────────────────
  static const String indikator = '/api/list/model/statictable/lang/ind';
  static const String subjek = '/api/list/model/subject/lang/ind';

  // ── Metadata ──────────────────────────────────────────────
  static const String metadata = '/api/list/model/kbki/lang/ind';
  static const String variabel = '/api/list/model/var/lang/ind';

  // ── Standar Pelayanan ─────────────────────────────────────
  /// Endpoint lokal (jika tersedia di server BPS Kab)
  static const String standarPelayanan = '/standar-pelayanan';

  // ── SKD (Survei Kepuasan Data) ────────────────────────────
  static const String skd = '/skd';

  // ── Helper: Build full URL with API key ───────────────────
  static String withKey(String path, {Map<String, dynamic>? extra}) {
    final params = StringBuffer('?key=$apiKey&domain=$wilayahKode');
    if (extra != null) {
      extra.forEach((k, v) => params.write('&$k=$v'));
    }
    return '$baseUrl$path$params';
  }
}

// ── API Response Keys ────────────────────────────────────────
class ApiKeys {
  ApiKeys._();

  static const String status = 'status';
  static const String dataAvailability = 'data-availability';
  static const String data = 'data';
  static const String id = 'berita_id';
  static const String title = 'judul';
  static const String date = 'tanggal';
  static const String image = 'gambar';
  static const String abstract = 'abstraksi';
  static const String file = 'pdf';
  static const String category = 'kategori';
}
