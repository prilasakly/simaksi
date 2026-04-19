// lib/features/beranda/beranda_screen.dart
// ============================================================
// SIMAKSI - Beranda Screen
// Halaman utama. Semua section dibuat modular.
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/banner_slider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/config/app_config.dart';
import '../../../core/router/app_router.dart';

import '../widgets/brs_section.dart';
import '../widgets/infografis_section.dart';
import '../widgets/publikasi_section.dart';
import '../../../core/widgets/sub_menu_grid.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _BerandaAppBar(innerBoxIsScrolled: innerBoxIsScrolled),
        ],
        body: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            // Trigger refresh semua section
            setState(() {});
            await Future.delayed(const Duration(milliseconds: 1000));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 1. Banner Berita Slider ──────────────────
                const BannerSlider(),

                const SizedBox(height: 8),

                // ── 2. Sub-menu Grid ─────────────────────────
                const SubMenuGrid(),

                const SizedBox(height: 8),

                // ── 3. Publikasi Section ─────────────────────
                PublikasiSection(
                  onLihatSemua: () {
                    context.push(AppRoutes.publikasi);
                  },
                ),

                const SizedBox(height: 8),

                // ── 4. BRS Section ───────────────────────────
                BrsSection(
                  onLihatSemua: () =>
                      context.push(AppRoutes.brs),
                ),

                const SizedBox(height: 8),

                // ── 5. Infografis Section ────────────────────
                InfografisSection(
                  onLihatSemua: () =>
                      context.push(AppRoutes.infografis),
                ),

                const SizedBox(height: 8),

                // ── 6. Footer ────────────────────────────────
                // const FooterSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── AppBar ───────────────────────────────────────────────────
class _BerandaAppBar extends StatelessWidget {
  final bool innerBoxIsScrolled;
  const _BerandaAppBar({required this.innerBoxIsScrolled});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      expandedHeight: 0,
      elevation: innerBoxIsScrolled ? 2 : 0,
      shadowColor: AppColors.cardShadow,
      backgroundColor: AppColors.primary,
      title: Row(
        children: [
          // Mini BPS logo
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'BPS',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppConfig.appName,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 2,
                  height: 1.1,
                ),
              ),
              Text(
                AppConfig.organizationShort,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontPrimary,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.75),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, color: Colors.white),
          onPressed: () {
            // TODO: Implementasi search
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {
            // TODO: Implementasi notifikasi
          },
        ),
      ],
    );
  }
}
