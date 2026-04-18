// lib/config/app_config.dart
// ============================================================
// SIMAKSI - App Configuration
// Semua konfigurasi global app ada di sini
// ============================================================

class AppConfig {
  AppConfig._();

  // ── App Info ──────────────────────────────────────────────
  static const String appName = 'SIMAKSI';
  static const String appFullName = 'Sistem Informasi BPS Kabupaten Sukabumi';
  static const String organizationName = 'BPS Kabupaten Sukabumi';
  static const String organizationShort = 'BPS Kab. Sukabumi';
  static const String appVersion = '1.0.0';

  // ── Contact & Address ─────────────────────────────────────
  static const String websiteUrl = 'https://sukabumikab.bps.go.id';
  static const String email = 'bps3202@bps.go.id';
  static const String phone = '(0266) 221-xxx';
  static const String address =
      'Jl. Bhayangkara No. 40, Sukabumi, Jawa Barat 43131';
  static const String googleMapsUrl =
      'https://maps.google.com/?q=BPS+Kabupaten+Sukabumi';

  // ── Social Media ──────────────────────────────────────────
  static const String instagramUrl =
      'https://www.instagram.com/bpskabsukabumi/';
  static const String twitterUrl = 'https://twitter.com/BPS_Sukabumi';
  static const String youtubeUrl = 'https://www.youtube.com/@bpskabsukabumi';

  // ── Asset Patching / Dynamic Delivery ────────────────────
  // URL endpoint untuk cek versi konten dan download asset baru
  static const String assetPatchBaseUrl =
      'https://sukabumikab.bps.go.id/asset-patch/v1';
  static const String assetPatchVersionKey = 'asset_patch_version';
  static const int assetPatchCheckIntervalHours = 24;

  // ── Cache Settings ────────────────────────────────────────
  static const Duration imageCacheDuration = Duration(days: 7);
  static const Duration apiCacheDuration = Duration(hours: 1);
  static const int maxCacheSize = 100; // MB

  // ── UI Settings ───────────────────────────────────────────
  static const Duration splashDuration = Duration(milliseconds: 3200);
  static const Duration bannerAutoPlayInterval = Duration(seconds: 4);
  static const int bannerFallbackCount = 3; // jika api kosong

  // ── Pagination ────────────────────────────────────────────
  static const int defaultPageSize = 10;
  static const int homePublikasiCount = 6;
  static const int homeBrsCount = 5;
  static const int homeInfografisCount = 8;
}
