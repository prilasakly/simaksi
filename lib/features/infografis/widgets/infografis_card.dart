// lib/features/infografis/widgets/infografis_card.dart
// ============================================================
// SIMAKSI - Infografis Card Widget
// Kartu infografis untuk grid & list.
// Mendukung: animasi press, shimmer loading, placeholder gradient.
// ============================================================

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_theme.dart';
import '../model/infografis_model.dart';

// ── Palette gradient per-id ───────────────────────────────────
const _kGradients = [
  [Color(0xFF4A148C), Color(0xFF6A1B9A)], // ungu
  [Color(0xFF003F88), Color(0xFF1565C0)], // biru BPS
  [Color(0xFF1B5E20), Color(0xFF2E7D32)], // hijau
  [Color(0xFF880E4F), Color(0xFFAD1457)], // pink
  [Color(0xFF004D40), Color(0xFF00695C)], // teal
  [Color(0xFFBF360C), Color(0xFFE64A19)], // oranye
  [Color(0xFF0D47A1), Color(0xFF1976D2)], // biru muda
  [Color(0xFF4E342E), Color(0xFF6D4C41)], // cokelat
];

List<Color> _gradientFor(int id) => _kGradients[id.abs() % _kGradients.length];

// ── Infografis Card ───────────────────────────────────────────
class InfografisCard extends StatefulWidget {
  final InfografisModel item;
  final VoidCallback onTap;

  /// Ukuran kartu: mode grid (default) atau list horizontal
  final InfografisCardSize size;

  const InfografisCard({
    super.key,
    required this.item,
    required this.onTap,
    this.size = InfografisCardSize.grid,
  });

  @override
  State<InfografisCard> createState() => _InfografisCardState();
}

class _InfografisCardState extends State<InfografisCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isSmall = widget.size == InfografisCardSize.small;
    final colors = _gradientFor(widget.item.id);

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 110),
        transform: Matrix4.translationValues(0, _pressed ? 2 : 0, 0),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(isSmall ? 14 : 16),
          boxShadow: _pressed
              ? []
              : [
                  BoxShadow(
                    color: colors[0].withOpacity(0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
          border: Border.all(
            color: Colors.black.withOpacity(_pressed ? 0.04 : 0.06),
            width: 0.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isSmall ? 14 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Image area ─────────────────────────────────
              Expanded(
                child: _buildImage(colors, isSmall),
              ),
              // ── Info area ──────────────────────────────────
              _buildInfo(isSmall),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(List<Color> colors, bool isSmall) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Gambar atau placeholder
        widget.item.adaGambar
            ? CachedNetworkImage(
                imageUrl: widget.item.gambar!,
                fit: BoxFit.cover,
                placeholder: (_, __) => _GradientPlaceholder(
                  colors: colors,
                  judul: widget.item.judul,
                  showText: false,
                ),
                errorWidget: (_, __, ___) => _GradientPlaceholder(
                  colors: colors,
                  judul: widget.item.judul,
                ),
              )
            : _GradientPlaceholder(
                colors: colors,
                judul: widget.item.judul,
              ),

        // Badge kategori (pojok kiri atas)
        Positioned(
          top: 8,
          left: 8,
          child: _KategoriBadge(kategori: widget.item.kategori),
        ),

        // Overlay gradient bawah
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: isSmall ? 40 : 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.45),
                ],
              ),
            ),
          ),
        ),

        // Ikon download (pojok kanan bawah) jika ada file
        if (widget.item.bisaDiunduh)
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.download_rounded,
                size: isSmall ? 12 : 14,
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfo(bool isSmall) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        isSmall ? 8 : 10,
        isSmall ? 6 : 8,
        isSmall ? 8 : 10,
        isSmall ? 8 : 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.item.judul,
            maxLines: isSmall ? 2 : 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppTextStyles.fontPrimary,
              fontSize: isSmall ? 10 : 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.35,
            ),
          ),
          if (widget.item.tanggalFormatted.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              widget.item.tanggalFormatted,
              style: TextStyle(
                fontFamily: AppTextStyles.fontPrimary,
                fontSize: isSmall ? 9 : 10,
                color: AppColors.textHint,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Gradient Placeholder ──────────────────────────────────────
class _GradientPlaceholder extends StatelessWidget {
  final List<Color> colors;
  final String judul;
  final bool showText;

  const _GradientPlaceholder({
    required this.colors,
    required this.judul,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Stack(
        children: [
          // Dekorasi lingkaran
          Positioned(
            right: -24,
            top: -24,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -16,
            bottom: -16,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Ikon dan teks
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.bar_chart_rounded,
                  size: 32,
                  color: Colors.white.withOpacity(0.35),
                ),
                if (showText) ...[
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      judul,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Kategori Badge ────────────────────────────────────────────
class _KategoriBadge extends StatelessWidget {
  final InfografisKategori kategori;
  const _KategoriBadge({required this.kategori});

  Color get _bg => switch (kategori) {
    InfografisKategori.ekonomi   => const Color(0xFF1B5E20),
    InfografisKategori.sosial    => const Color(0xFF01579B),
    InfografisKategori.lingkungan => const Color(0xFF004D40),
    _                            => const Color(0xFF37474F),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: _bg.withOpacity(0.85),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        kategori.label,
        style: const TextStyle(
          fontFamily: AppTextStyles.fontPrimary,
          fontSize: 8,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ── Card Shimmer ──────────────────────────────────────────────
class InfografisCardShimmer extends StatefulWidget {
  final InfografisCardSize size;
  const InfografisCardShimmer({
    super.key,
    this.size = InfografisCardSize.grid,
  });

  @override
  State<InfografisCardShimmer> createState() => _InfografisCardShimmerState();
}

class _InfografisCardShimmerState extends State<InfografisCardShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = widget.size == InfografisCardSize.small;
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Opacity(
        opacity: _anim.value,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(isSmall ? 14 : 16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(isSmall ? 14 : 16),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 9,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 5),
                    Container(
                      height: 9,
                      width: 80,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 5),
                    Container(
                      height: 8,
                      width: 55,
                      color: Colors.grey.shade200,
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

// ── Card Size Enum ────────────────────────────────────────────
enum InfografisCardSize {
  /// Kartu grid standar (digunakan di InfografisScreen)
  grid,

  /// Kartu kecil untuk horizontal scroll di beranda
  small,
}
