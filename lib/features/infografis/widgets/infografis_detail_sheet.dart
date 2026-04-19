// lib/features/infografis/widgets/infografis_detail_sheet.dart
// ============================================================
// SIMAKSI - Infografis Detail Bottom Sheet
// Menampilkan detail infografis: gambar penuh, judul, deskripsi,
// tombol unduh, dan tombol lihat gambar full screen.
// ============================================================

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../model/infografis_model.dart';

/// Tampilkan bottom sheet detail infografis.
///
/// ```dart
/// InfografisDetailSheet.show(context, item: item);
/// ```
class InfografisDetailSheet extends StatelessWidget {
  final InfografisModel item;

  const InfografisDetailSheet._({required this.item});

  // ── Static show helper ────────────────────────────────────
  static Future<void> show(
    BuildContext context, {
    required InfografisModel item,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => InfografisDetailSheet._(item: item),
    );
  }

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (ctx, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Drag handle
            const _DragHandle(),

            // Scrollable content
            Expanded(
              child: CustomScrollView(
                controller: scrollCtrl,
                slivers: [
                  // ── Gambar ─────────────────────────────────
                  SliverToBoxAdapter(child: _buildImage(context)),

                  // ── Meta & judul ───────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                      child: _buildMeta(),
                    ),
                  ),

                  // ── Deskripsi ──────────────────────────────
                  if (item.deskripsiFormatted.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
                        child: _buildDeskripsi(),
                      ),
                    ),

                  // ── Action buttons ─────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        18, 20, 18, mq.padding.bottom + 24,
                      ),
                      child: _buildActions(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return GestureDetector(
      onTap: () => _openFullImage(context),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: item.adaGambar
            ? CachedNetworkImage(
                imageUrl: item.gambar!,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: AppColors.surfaceVariant,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => _buildImageError(),
              )
            : _buildImageError(),
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: 48,
          color: AppColors.textHint,
        ),
      ),
    );
  }

  Widget _buildMeta() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badge kategori + tanggal
        Row(
          children: [
            _KategoriBadgeDetail(kategori: item.kategori),
            if (item.tanggalFormatted.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(
                item.tanggalFormatted,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontPrimary,
                  fontSize: 12,
                  color: AppColors.textHint,
                ),
              ),
            ],
            const Spacer(),
            Text(
              'ID: ${item.id}',
              style: const TextStyle(
                fontFamily: AppTextStyles.fontPrimary,
                fontSize: 11,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Judul
        Text(
          item.judul,
          style: AppTextStyles.headlineMedium.copyWith(
            fontSize: 16,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildDeskripsi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Divider
        const Divider(thickness: 0.5, height: 0),
        const SizedBox(height: 12),

        Text(
          'Ringkasan',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.primary,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item.deskripsiFormatted,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 13,
            height: 1.65,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Unduh file (jika tersedia)
        if (item.bisaDiunduh)
          _ActionButton(
            icon: Icons.download_rounded,
            label: 'Unduh Infografis',
            color: AppColors.primary,
            onTap: () => _launchUrl(item.fileUrl!),
          ),

        // Lihat gambar full
        if (item.adaGambar) ...[
          if (item.bisaDiunduh) const SizedBox(height: 10),
          _ActionButton(
            icon: Icons.open_in_new_rounded,
            label: 'Lihat Gambar Penuh',
            color: AppColors.primaryLight,
            filled: false,
            onTap: () => _openFullImage(context),
          ),
        ],
      ],
    );
  }

  // ── Helpers ───────────────────────────────────────────────
  void _openFullImage(BuildContext context) {
    if (!item.adaGambar) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _FullScreenImage(item: item),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// ── Full Screen Image Viewer ──────────────────────────────────
class _FullScreenImage extends StatelessWidget {
  final InfografisModel item;
  const _FullScreenImage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          item.judul,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          if (item.bisaDiunduh)
            IconButton(
              icon: const Icon(Icons.download_rounded),
              tooltip: 'Unduh',
              onPressed: () async {
                final uri = Uri.tryParse(item.fileUrl!);
                if (uri != null && await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
        ],
      ),
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 5.0,
        child: Center(
          child: CachedNetworkImage(
            imageUrl: item.gambar!,
            fit: BoxFit.contain,
            placeholder: (_, __) => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            errorWidget: (_, __, ___) => const Icon(
              Icons.broken_image_outlined,
              color: Colors.white54,
              size: 64,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 4),
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _KategoriBadgeDetail extends StatelessWidget {
  final InfografisKategori kategori;
  const _KategoriBadgeDetail({required this.kategori});

  Color get _bg => switch (kategori) {
    InfografisKategori.ekonomi    => const Color(0xFFE8F5E9),
    InfografisKategori.sosial     => const Color(0xFFE3F2FD),
    InfografisKategori.lingkungan => const Color(0xFFE0F2F1),
    _                             => AppColors.surfaceVariant,
  };

  Color get _fg => switch (kategori) {
    InfografisKategori.ekonomi    => const Color(0xFF1B5E20),
    InfografisKategori.sosial     => const Color(0xFF01579B),
    InfografisKategori.lingkungan => const Color(0xFF004D40),
    _                             => AppColors.textSecondary,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        kategori.label,
        style: TextStyle(
          fontFamily: AppTextStyles.fontPrimary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: _fg,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool filled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? color : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: filled
              ? null
              : BoxDecoration(
                  border: Border.all(color: color, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: filled ? Colors.white : color,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: filled ? Colors.white : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
