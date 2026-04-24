// lib/features/media_sosial/screen/media_sosial_screen.dart
// ============================================================
// SIMAKSI - Media Sosial Screen
// Halaman media sosial & kontak BPS Kabupaten Sukabumi
// ============================================================

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simaksi/features/media_sosial/model/media_sosial_model.dart';
import '../../../core/config/app_config.dart';
import '../../../core/theme/app_theme.dart';
import '../service/media_sosial_service.dart';
import '../widgets/sosial_card.dart';
import '../widgets/sosial_section_header.dart';
import '../widgets/alamat_card.dart';

class MediaSosialScreen extends StatefulWidget {
  const MediaSosialScreen({super.key});

  @override
  State<MediaSosialScreen> createState() => _MediaSosialScreenState();
}

class _MediaSosialScreenState extends State<MediaSosialScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _headerAnimController;

  @override
  void initState() {
    super.initState();
    _headerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _headerAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sosialList = MediaSosialService.getSosialMedia();
    final kontakList = MediaSosialService.getKontak();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App Bar ─────────────────────────────────────
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: _HeaderBackground(
                animController: _headerAnimController,
              ),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Media Sosial & Kontak',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    AppConfig.organizationShort,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.75),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Content ─────────────────────────────────────
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Sosial Media Section ───────────────────
                const SosialSectionHeader(
                  title: 'Ikuti Kami',
                  icon: Icons.thumb_up_alt_rounded,
                ),
                ...sosialList.asMap().entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: SosialCard(item: e.value, index: e.key),
                  ),
                ),

                // ── Kontak Section ─────────────────────────
                const SosialSectionHeader(
                  title: 'Hubungi Kami',
                  icon: Icons.contact_support_rounded,
                ),
                ...kontakList
                    .where((e) => e.platform != SosialPlatform.maps)
                    .toList()
                    .asMap()
                    .entries
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: SosialCard(
                          item: e.value,
                          index: e.key + sosialList.length,
                        ),
                      ),
                    ),

                // ── Lokasi Section ─────────────────────────
                const SosialSectionHeader(
                  title: 'Lokasi Kantor',
                  icon: Icons.place_rounded,
                ),
                const AlamatCard(),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header background dengan bubble animation ─────────────────
class _HeaderBackground extends StatelessWidget {
  final AnimationController animController;

  const _HeaderBackground({required this.animController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animController,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryDark, AppColors.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: CustomPaint(
            painter: _SosialHeaderPainter(animController.value),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── Ikon platform dekoratif ──────────────
                  _PlatformIcon(
                    icon: Icons.camera_alt_rounded,
                    delay: 0.0,
                    anim: animController.value,
                  ),
                  const SizedBox(width: 10),
                  _PlatformIcon(
                    icon: Icons.alternate_email_rounded,
                    delay: 0.33,
                    anim: animController.value,
                  ),
                  const SizedBox(width: 10),
                  _PlatformIcon(
                    icon: Icons.play_circle_filled_rounded,
                    delay: 0.66,
                    anim: animController.value,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PlatformIcon extends StatelessWidget {
  final IconData icon;
  final double delay;
  final double anim;

  const _PlatformIcon({
    required this.icon,
    required this.delay,
    required this.anim,
  });

  @override
  Widget build(BuildContext context) {
    final offset = sin((anim + delay) * 2 * pi) * 4.0;
    return Transform.translate(
      offset: Offset(0, offset),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Icon(icon, color: Colors.white.withOpacity(0.8), size: 22),
      ),
    );
  }
}

class _SosialHeaderPainter extends CustomPainter {
  final double anim;
  _SosialHeaderPainter(this.anim);

  @override
  void paint(Canvas canvas, Size size) {
    final bubbles = [
      (0.9, 0.2, 50.0, 0.07),
      (0.75, 0.8, 35.0, 0.06),
      (1.05, 0.55, 60.0, 0.05),
      (0.05, 0.9, 40.0, 0.08),
    ];

    for (final b in bubbles) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(b.$4)
        ..style = PaintingStyle.fill;
      final dx = sin(anim * 2 * pi + b.$1) * 8;
      final dy = cos(anim * 2 * pi * 0.7 + b.$2) * 8;
      canvas.drawCircle(
        Offset(b.$1 * size.width + dx, b.$2 * size.height + dy),
        b.$3,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_SosialHeaderPainter old) => old.anim != anim;
}
