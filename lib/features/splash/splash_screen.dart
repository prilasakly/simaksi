// lib/features/splash/splash_screen.dart
// ============================================================
// SIMAKSI - Splash / Loading Screen
// Halaman pertama yang muncul saat app dibuka
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/config/app_config.dart';
import '../../core/utils/asset_patch_service.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Animation Controllers ────────────────────────────────
  late final AnimationController _bgController;
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _loadingController;
  late final AnimationController _shimmerController;

  // ── Animations ────────────────────────────────────────────
  late final Animation<double> _bgFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<Offset> _logoSlide;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _subtitleFade;
  late final Animation<double> _loadingFade;
  late final Animation<double> _shimmerAnim;
  late final Animation<double> _progressAnim;

  // ── State ─────────────────────────────────────────────────
  String _statusText = 'Memulai aplikasi...';
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSequence();
  }

  void _setupAnimations() {
    // Background fade-in
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bgFade = CurvedAnimation(parent: _bgController, curve: Curves.easeOut);

    // Logo entrance
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoFade = CurvedAnimation(parent: _logoController, curve: Curves.easeIn);
    _logoSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
        );

    // Text entrance
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _titleFade = CurvedAnimation(parent: _textController, curve: Curves.easeIn);
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );
    _subtitleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    // Loading indicator
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _loadingFade = CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeIn,
    );
    _progressAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.linear),
    );

    // Shimmer loop
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    _shimmerAnim = CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.linear,
    );
  }

  Future<void> _startSequence() async {
    // 1. BG
    _bgController.forward();
    await Future.delayed(const Duration(milliseconds: 200));

    // 2. Logo
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 500));

    // 3. Text
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 600));

    // 4. Loading bar
    _loadingController.forward();
    await Future.delayed(const Duration(milliseconds: 300));

    // 5. Asset patch check
    _updateStatus('Memeriksa pembaruan konten...');
    await AssetPatchService.instance.checkAndApplyPatch();

    // 6. Simulate loading
    _updateStatus('Memuat data statistik...');
    await Future.delayed(const Duration(milliseconds: 700));

    _updateStatus('Menyiapkan beranda...');
    await Future.delayed(const Duration(milliseconds: 500));

    // 7. Navigate
    setState(() => _isReady = true);
    await Future.delayed(const Duration(milliseconds: 400));

    if (mounted) context.go(AppRoutes.beranda);
  }

  void _updateStatus(String text) {
    if (mounted) setState(() => _statusText = text);
  }

  @override
  void dispose() {
    _bgController.dispose();
    _logoController.dispose();
    _textController.dispose();
    _loadingController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: FadeTransition(
        opacity: _bgFade,
        child: Stack(
          children: [
            // ── Background Pattern ────────────────────────
            _BackgroundPattern(size: size),

            // ── Main Content ──────────────────────────────
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Logo Area
                  _LogoSection(
                    logoScale: _logoScale,
                    logoFade: _logoFade,
                    logoSlide: _logoSlide,
                  ),

                  const SizedBox(height: 36),

                  // Title Area
                  _TitleSection(
                    titleFade: _titleFade,
                    titleSlide: _titleSlide,
                    subtitleFade: _subtitleFade,
                  ),

                  const Spacer(flex: 2),

                  // Loading Area
                  FadeTransition(
                    opacity: _loadingFade,
                    child: _LoadingSection(
                      shimmerAnim: _shimmerAnim,
                      statusText: _statusText,
                      isReady: _isReady,
                    ),
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Background Pattern ──────────────────────────────────────
class _BackgroundPattern extends StatelessWidget {
  final Size size;
  const _BackgroundPattern({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: size, painter: _SplashPatternPainter());
  }
}

class _SplashPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Gold accent top-right
    paint.color = AppColors.accent.withOpacity(0.15);
    canvas.drawCircle(Offset(size.width + 40, -40), 180, paint);

    paint.color = AppColors.accent.withOpacity(0.08);
    canvas.drawCircle(Offset(size.width - 20, 100), 120, paint);

    // Blue gradient circles bottom-left
    paint.color = AppColors.primaryDark.withOpacity(0.5);
    canvas.drawCircle(Offset(-60, size.height + 60), 200, paint);

    paint.color = AppColors.primaryLight.withOpacity(0.15);
    canvas.drawCircle(Offset(80, size.height - 80), 150, paint);

    // Gold horizontal line accent
    final linePaint = Paint()
      ..color = AppColors.accent.withOpacity(0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.72);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.68,
      size.width,
      size.height * 0.74,
    );
    canvas.drawPath(path, linePaint);

    // Dot pattern
    paint.color = AppColors.accent.withOpacity(0.12);
    for (var i = 0; i < 5; i++) {
      for (var j = 0; j < 4; j++) {
        canvas.drawCircle(
          Offset(size.width * 0.08 + i * 30, size.height * 0.15 + j * 30),
          2,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Logo Section ────────────────────────────────────────────
class _LogoSection extends StatelessWidget {
  final Animation<double> logoScale;
  final Animation<double> logoFade;
  final Animation<Offset> logoSlide;

  const _LogoSection({
    required this.logoScale,
    required this.logoFade,
    required this.logoSlide,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: logoSlide,
      child: FadeTransition(
        opacity: logoFade,
        child: ScaleTransition(
          scale: logoScale,
          child: Column(
            children: [
              // BPS Logo Container
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // BPS text logo styled
                      Text(
                        'BPS',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontPrimary,
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          letterSpacing: 3,
                          height: 1.0,
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 2.5,
                        color: AppColors.accent,
                        margin: const EdgeInsets.symmetric(vertical: 2),
                      ),
                      Text(
                        'RI',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Title Section ────────────────────────────────────────────
class _TitleSection extends StatelessWidget {
  final Animation<double> titleFade;
  final Animation<Offset> titleSlide;
  final Animation<double> subtitleFade;

  const _TitleSection({
    required this.titleFade,
    required this.titleSlide,
    required this.subtitleFade,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: SlideTransition(
        position: titleSlide,
        child: FadeTransition(
          opacity: titleFade,
          child: Column(
            children: [
              // Decorative line
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 1,
                    color: AppColors.accent.withOpacity(0.5),
                  ),
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 1,
                    color: AppColors.accent.withOpacity(0.5),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // SIMAKSI
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [AppColors.accent, const Color(0xFFFFF176)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  AppConfig.appName,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontDisplay,
                    fontSize: 52,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 8,
                    height: 1.0,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Subtitle fade-in
              FadeTransition(
                opacity: subtitleFade,
                child: Column(
                  children: [
                    Text(
                      AppConfig.organizationName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Sistem Informasi Statistik',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.65),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Loading Section ──────────────────────────────────────────
class _LoadingSection extends StatelessWidget {
  final Animation<double> shimmerAnim;
  final String statusText;
  final bool isReady;

  const _LoadingSection({
    required this.shimmerAnim,
    required this.statusText,
    required this.isReady,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          // Status text
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              statusText,
              key: ValueKey(statusText),
              style: TextStyle(
                fontFamily: AppTextStyles.fontPrimary,
                fontSize: 12,
                color: Colors.white.withOpacity(0.7),
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Shimmer progress bar
          AnimatedBuilder(
            animation: shimmerAnim,
            builder: (context, _) {
              return Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: CustomPaint(
                    painter: _ShimmerBarPainter(
                      progress: shimmerAnim.value,
                      isReady: isReady,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // Version
          Text(
            'v${AppConfig.appVersion}',
            style: TextStyle(
              fontFamily: AppTextStyles.fontPrimary,
              fontSize: 11,
              color: Colors.white.withOpacity(0.35),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerBarPainter extends CustomPainter {
  final double progress;
  final bool isReady;

  _ShimmerBarPainter({required this.progress, required this.isReady});

  @override
  void paint(Canvas canvas, Size size) {
    if (isReady) {
      // Full fill
      final paint = Paint()
        ..shader = LinearGradient(
          colors: [AppColors.accent, AppColors.accentLight],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
      return;
    }

    // Shimmer moving bar
    final shimmerWidth = size.width * 0.4;
    final x = (progress * (size.width + shimmerWidth)) - shimmerWidth;

    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          AppColors.accent.withOpacity(0.8),
          AppColors.accentLight,
          AppColors.accent.withOpacity(0.8),
          Colors.transparent,
        ],
        stops: const [0, 0.2, 0.5, 0.8, 1.0],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(x, 0, shimmerWidth, size.height));

    canvas.drawRect(Rect.fromLTWH(x, 0, shimmerWidth, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant _ShimmerBarPainter old) =>
      old.progress != progress || old.isReady != isReady;
}
