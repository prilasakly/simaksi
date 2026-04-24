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
class _BerandaAppBar extends StatefulWidget {
  final bool innerBoxIsScrolled;
  const _BerandaAppBar({required this.innerBoxIsScrolled});

  @override
  State<_BerandaAppBar> createState() => _BerandaAppBarState();
}

class _BerandaAppBarState extends State<_BerandaAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SliverAppBar(
          pinned: true,
          floating: false,
          expandedHeight: 0,
          elevation: widget.innerBoxIsScrolled ? 4 : 0,
          shadowColor: AppColors.cardShadow,
          backgroundColor: Colors.transparent,

          // 🎨 BACKGROUND CUSTOM (GRADIENT + ANIMATED BUBBLES)
          flexibleSpace: Stack(
            fit: StackFit.expand,
            children: [
              // Gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              // Animated bubble pattern
              CustomPaint(
                painter: HeaderPatternPainter(animValue: _controller.value),
              ),
            ],
          ),

          // ── TITLE ─────────────────────────────────────
          title: child,

          // ── ACTIONS ───────────────────────────────────
          actions: [
            IconButton(
              icon: const Icon(Icons.search_rounded, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
        );
      },

      // Title dipisah sebagai child agar tidak rebuild tiap frame animasi
      child: Row(
        children: [
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
    );
  }
}
