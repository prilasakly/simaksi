// lib/core/router/app_router.dart
// ============================================================
// SIMAKSI - App Router
// Semua navigasi/route ada di sini
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/beranda/beranda_screen.dart';

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
    // ── Splash / Loading ────────────────────────────────────
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    // ── Beranda ─────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.beranda,
      builder: (context, state) => const BerandaScreen(),
    ),

    // ── Placeholder routes (implementasi nanti) ─────────────
    GoRoute(
      path: AppRoutes.publikasi,
      builder: (context, state) =>
          _PlaceholderScreen(title: 'Publikasi', icon: Icons.menu_book_rounded),
    ),
    GoRoute(
      path: AppRoutes.brs,
      builder: (context, state) => _PlaceholderScreen(
        title: 'Berita Resmi Statistik',
        icon: Icons.article_rounded,
      ),
    ),
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
    GoRoute(
      path: AppRoutes.sdgs,
      builder: (context, state) =>
          _PlaceholderScreen(title: 'SDGs', icon: Icons.public_rounded),
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
