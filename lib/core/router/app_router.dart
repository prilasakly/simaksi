// lib/core/router/app_router.dart
// ============================================================
// SIMAKSI - App Router
// Semua navigasi/route ada di sini
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simaksi/features/brs/model/brs_model.dart';
import 'package:simaksi/features/brs/screen/brs_detail_screen.dart';
import 'package:simaksi/features/brs/screen/brs_screen.dart';
import 'package:simaksi/features/sdgs/screen/sdgs_screen.dart' show SdgsScreen;
import '../../features/splash/splash_screen.dart';
import '../../features/beranda/screen/beranda_screen.dart';
import '../../features/publikasi/screen/publikasi_screen.dart';
import '../../features/publikasi/screen/publikasi_detail_screen.dart';
import '../../features/publikasi/model/publikasi_model.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String beranda = '/beranda';
  static const String publikasi = '/publikasi';
  static const String brs = '/brs';
  static const String infografis = '/infografis';
  static const String mediaSosial = '/media-sosial';
  static const String indikator = '/indikator';
  static const String metadata = '/metadata';
  static const String skd = '/skd';
  static const String standarPelayanan = '/standar-pelayanan';
  static const String berita = '/berita';
  static const String sdgs = '/sdgs';

  // Detail routes
  static const String publikasiDetail = '/publikasi/:id';
  static const String brsDetail = '/brs/:id';
  static const String beritaDetail = '/berita/:id';
  static const String infografisDetail = '/infografis/:id';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: false,
  routes: [
    // ── Splash ─────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    // ── Beranda ────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.beranda,
      builder: (context, state) => const BerandaScreen(),
    ),

    // ── SDGs ───────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.sdgs,
      builder: (context, state) => const SdgsScreen(),
    ),

    // ======================================================
    // 🔥 DETAIL ROUTES (WAJIB DI ATAS)
    // ======================================================

    // ── Publikasi Detail ───────────────────────────────────
    GoRoute(
      path: AppRoutes.publikasiDetail, // /publikasi/:id
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        final extra = state.extra;
        final preloaded = extra is PublikasiModel ? extra : null;
        return PublikasiDetailScreen(id: id, preloadedData: preloaded);
      },
    ),

    // ── BRS Detail ─────────────────────────────────────────
    GoRoute(
      path: AppRoutes.brsDetail, // /brs/:id
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        final extra = state.extra;
        final preloaded = extra is BrsModel ? extra : null;
        return BrsDetailScreen(id: id, preloadedData: preloaded);
      },
    ),

    // ======================================================
    // 📄 LIST ROUTES (SETELAH DETAIL)
    // ======================================================

    // ── Publikasi List ─────────────────────────────────────
    GoRoute(
      path: AppRoutes.publikasi, // /publikasi
      builder: (context, state) => const PublikasiScreen(),
    ),

    // ── BRS List ───────────────────────────────────────────
    GoRoute(
      path: AppRoutes.brs, // /brs
      builder: (context, state) => const BrsScreen(),
    ),

    // ======================================================
    // 📦 LAINNYA
    // ======================================================
    GoRoute(
      path: AppRoutes.infografis,
      builder: (context, state) => _PlaceholderScreen(
        title: 'Infografis',
        icon: Icons.bar_chart_rounded,
      ),
    ),
    GoRoute(
      path: AppRoutes.mediaSosial,
      builder: (context, state) =>
          _PlaceholderScreen(title: 'Media Sosial', icon: Icons.share_rounded),
    ),
    GoRoute(
      path: AppRoutes.indikator,
      builder: (context, state) => _PlaceholderScreen(
        title: 'Indikator',
        icon: Icons.trending_up_rounded,
      ),
    ),
    GoRoute(
      path: AppRoutes.metadata,
      builder: (context, state) => _PlaceholderScreen(
        title: 'Metadata',
        icon: Icons.data_object_rounded,
      ),
    ),
    GoRoute(
      path: AppRoutes.skd,
      builder: (context, state) => _PlaceholderScreen(
        title: 'SKD - Survei Kepuasan Data',
        icon: Icons.star_rounded,
      ),
    ),
    GoRoute(
      path: AppRoutes.standarPelayanan,
      builder: (context, state) => _PlaceholderScreen(
        title: 'Standar Pelayanan',
        icon: Icons.verified_rounded,
      ),
    ),
    GoRoute(
      path: AppRoutes.berita,
      builder: (context, state) =>
          _PlaceholderScreen(title: 'Berita', icon: Icons.newspaper_rounded),
    ),
  ],
);

// ── Temporary placeholder for unimplemented screens ──────
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderScreen({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.grey.shade400),
            ),
            const SizedBox(height: 8),
            Text(
              'Halaman dalam pengembangan',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }
}
