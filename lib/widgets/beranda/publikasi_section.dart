// lib/widgets/beranda/publikasi_section.dart
// ============================================================
// SIMAKSI - Publikasi Section
// Section publikasi vertikal + horizontal scroll di beranda
// ============================================================

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:simaksi/widgets/beranda/section_header.dart' show SectionHeader;
import '../../api/api_client.dart';
import '../../config/app_config.dart';
import '../../models/publikasi_model.dart';
import '../../services/publikasi_service.dart';
import '../../shared/theme/app_theme.dart';

class PublikasiSection extends StatefulWidget {
  final VoidCallback? onLihatSemua;
  const PublikasiSection({super.key, this.onLihatSemua});

  @override
  State<PublikasiSection> createState() => _PublikasiSectionState();
}

class _PublikasiSectionState extends State<PublikasiSection> {
  List<PublikasiModel> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final result = await PublikasiService().getPublikasi(page: 1);

    setState(() {
      if (result is ApiSuccess<List<PublikasiModel>>) {
        _items = result.data;
      }

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Publikasi',
            subtitle: 'Buku & laporan statistik terbaru',
            accentColor: const Color(0xFF1565C0),
            onLihatSemua: widget.onLihatSemua,
          ),
          _isLoading ? _buildShimmer() : _buildContent(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_items.isEmpty) return _buildEmpty();
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _items.length,
        itemBuilder: (context, index) => _PublikasiCard(item: _items[index]),
      ),
    );
  }

  Widget _buildShimmer() {
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 4,
        itemBuilder: (context, _) => const _PublikasiCardShimmer(),
      ),
    );
  }

  Widget _buildEmpty() {
    return SizedBox(
      height: 100,
      child: Center(
        child: Text(
          'Belum ada publikasi tersedia',
          style: AppTextStyles.bodyMedium,
        ),
      ),
    );
  }
}

// ── Publikasi Card ───────────────────────────────────────────
class _PublikasiCard extends StatefulWidget {
  final PublikasiModel item;
  const _PublikasiCard({required this.item});

  @override
  State<_PublikasiCard> createState() => _PublikasiCardState();
}

class _PublikasiCardState extends State<_PublikasiCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to publikasi detail
      },
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 130,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        transform: Matrix4.translationValues(0, _pressed ? 2 : 0, 0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.black.withOpacity(_pressed ? 0.04 : 0.08),
            width: 0.5,
          ),
          boxShadow: _pressed
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book cover
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: widget.item.cover != null
                      ? CachedNetworkImage(
                          imageUrl: widget.item.cover!,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) =>
                              _CoverPlaceholder(item: widget.item),
                        )
                      : _CoverPlaceholder(item: widget.item),
                ),
              ),
              const SizedBox(height: 8),
              // Title
              Text(
                widget.item.judul,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.item.tahun,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoverPlaceholder extends StatelessWidget {
  final PublikasiModel item;
  const _CoverPlaceholder({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // BPS badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'BPS',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontPrimary,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
                Text(
                  item.judul,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontPrimary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
                Text(
                  item.tahun,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontPrimary,
                    fontSize: 10,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PublikasiCardShimmer extends StatelessWidget {
  const _PublikasiCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 8),
          Container(height: 10, color: Colors.grey.shade200, width: 100),
          const SizedBox(height: 4),
          Container(height: 10, color: Colors.grey.shade200, width: 60),
        ],
      ),
    );
  }
}
