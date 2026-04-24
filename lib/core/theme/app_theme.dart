// lib/shared/theme/app_theme.dart
// ============================================================
// SIMAKSI - App Theme Configuration
// Ubah warna, font, dan style di sini secara terpusat
// ============================================================

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  AppColors._();

  // ── Brand Colors ──────────────────────────────────────────
  static const Color primary = Color(0xFF003F88); // BPS Deep Blue
  static const Color primaryLight = Color(0xFF1565C0);
  static const Color primaryDark = Color(0xFF00205C);
  static const Color accent = Color(0xFFE8B923); // BPS Gold
  static const Color accentLight = Color(0xFFF5D260);

  // ── Surface Colors ────────────────────────────────────────
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEEF2F7);
  static const Color cardShadow = Color(0x1A003F88);

  // ── Text Colors ───────────────────────────────────────────
  static const Color textPrimary = Color(0xFF0D1B2A);
  static const Color textSecondary = Color(0xFF4A5568);
  static const Color textHint = Color(0xFF9AA5B4);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Status Colors ─────────────────────────────────────────
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF57F17);
  static const Color error = Color(0xFFC62828);
  static const Color info = Color(0xFF01579B);

  // ── Category Colors (untuk sub-menu) ─────────────────────
  static const List<Color> categoryColors = [
    Color(0xFF003F88), // Publikasi
    Color(0xFF1B5E20), // BRS
    Color(0xFF4A148C), // Infografis
    Color(0xFF880E4F), // Media Sosial
    Color(0xFF0D47A1), // Indikator
    Color(0xFF1A237E), // Metadata
    Color(0xFF006064), // SKD
    Color(0xFF37474F), // Standar Pelayanan
    Color(0xFFBF360C), // Berita
  ];
}

class AppTextStyles {
  AppTextStyles._();

  static const String fontPrimary = 'Poppins';
  static const String fontDisplay = 'Playfair';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.25,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontPrimary,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontPrimary,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontPrimary,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontPrimary,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textHint,
    letterSpacing: 0.5,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTextStyles.fontPrimary,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
        background: AppColors.background,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: AppTextStyles.headlineMedium.copyWith(
          color: AppColors.textOnPrimary,
        ),
      ),
      cardTheme: const CardThemeData(
        // Ubah dari CardTheme ke CardThemeData
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textOnPrimary,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  // ── System UI ─────────────────────────────────────────────
  static void setSystemUI({bool dark = false}) {
    SystemChrome.setSystemUIOverlayStyle(
      dark
          ? SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: AppColors.background,
            )
          : SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: AppColors.background,
            ),
    );
  }
}

class BubbleData {
  final double x, y, radius, opacity, driftX, driftY, phase;
  const BubbleData({
    required this.x,
    required this.y,
    required this.radius,
    required this.opacity,
    required this.driftX,
    required this.driftY,
    required this.phase,
  });
}

class HeaderPatternPainter extends CustomPainter {
  final double animValue;

  static const _bubbles = [
    BubbleData(
      x: -0.05,
      y: -0.1,
      radius: 55,
      opacity: 0.10,
      driftX: 6,
      driftY: 10,
      phase: 0.0,
    ),
    BubbleData(
      x: 0.15,
      y: 0.6,
      radius: 38,
      opacity: 0.08,
      driftX: 8,
      driftY: 12,
      phase: 1.2,
    ),
    BubbleData(
      x: 0.35,
      y: -0.2,
      radius: 70,
      opacity: 0.07,
      driftX: 5,
      driftY: 8,
      phase: 2.5,
    ),
    BubbleData(
      x: 0.55,
      y: 0.8,
      radius: 30,
      opacity: 0.12,
      driftX: 10,
      driftY: 6,
      phase: 0.8,
    ),
    BubbleData(
      x: 0.65,
      y: 0.1,
      radius: 50,
      opacity: 0.09,
      driftX: 7,
      driftY: 14,
      phase: 3.1,
    ),
    BubbleData(
      x: 0.85,
      y: 0.5,
      radius: 65,
      opacity: 0.08,
      driftX: 6,
      driftY: 10,
      phase: 1.8,
    ),
    BubbleData(
      x: 1.0,
      y: -0.1,
      radius: 42,
      opacity: 0.10,
      driftX: 9,
      driftY: 7,
      phase: 4.2,
    ),
    BubbleData(
      x: 0.45,
      y: 0.3,
      radius: 25,
      opacity: 0.13,
      driftX: 4,
      driftY: 9,
      phase: 5.0,
    ),
  ];

  const HeaderPatternPainter({required this.animValue});

  @override
  void paint(Canvas canvas, Size size) {
    for (final b in _bubbles) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(b.opacity)
        ..style = PaintingStyle.fill;

      final dx = sin(animValue * 2 * pi + b.phase) * b.driftX;
      final dy = cos(animValue * 2 * pi * 0.7 + b.phase) * b.driftY;

      canvas.drawCircle(
        Offset(b.x * size.width + dx, b.y * size.height + dy),
        b.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(HeaderPatternPainter old) => old.animValue != animValue;
}

// ─── AnimatedHeaderPattern (tidak dipakai di beranda_screen, tapi tetap tersedia) ───
class AnimatedHeaderPattern extends StatefulWidget {
  final Widget child;
  const AnimatedHeaderPattern({super.key, required this.child});

  @override
  State<AnimatedHeaderPattern> createState() => _AnimatedHeaderPatternState();
}

class _AnimatedHeaderPatternState extends State<AnimatedHeaderPattern>
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
        return CustomPaint(
          painter: HeaderPatternPainter(animValue: _controller.value),
          child: widget.child,
        );
      },
    );
  }
}
