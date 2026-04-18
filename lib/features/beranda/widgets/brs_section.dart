// lib/features/beranda/widgets/brs_section.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:simaksi/core/router/app_router.dart';

import '../../../core/api/api_client.dart' show ApiSuccess;
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/section_header.dart';
import '../../brs/model/brs_model.dart';
import '../../brs/service/brs_service.dart';

class BrsSection extends StatefulWidget {
  final VoidCallback? onLihatSemua;
  const BrsSection({super.key, this.onLihatSemua});

  @override
  State<BrsSection> createState() => _BrsSectionState();
}

class _BrsSectionState extends State<BrsSection> {
  List<BrsModel> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final result = await BrsService().getBrs(page: 1);
    if (!mounted) return;
    setState(() {
      if (result is ApiSuccess<List<BrsModel>>) {
        _items = result.data;
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceVariant,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Berita Resmi Statistik',
            subtitle: 'Rilis data statistik resmi BPS',
            accentColor: const Color(0xFF2E7D32),
            onLihatSemua:
                widget.onLihatSemua ?? () => context.push(AppRoutes.brs),
          ),
          _isLoading ? _buildShimmer() : _buildContent(),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_items.isEmpty) {
      return SizedBox(
        height: 80,
        child: Center(
          child: Text(
            'Belum ada BRS tersedia',
            style: AppTextStyles.bodyMedium,
          ),
        ),
      );
    }
    return SizedBox(
      height: 190,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _items.length,
        itemBuilder: (context, index) => _BrsCard(item: _items[index]),
      ),
    );
  }

  Widget _buildShimmer() {
    return SizedBox(
      height: 190,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: 4,
        itemBuilder: (_, __) => const _BrsCardShimmer(),
      ),
    );
  }
}

// ── BRS Card ──────────────────────────────────────────────────
class _BrsCard extends StatefulWidget {
  final BrsModel item;
  const _BrsCard({required this.item});

  @override
  State<_BrsCard> createState() => _BrsCardState();
}

class _BrsCardState extends State<_BrsCard> {
  bool _pressed = false;

  static const _green = Color(0xFF2E7D32);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('${AppRoutes.brs}/${widget.item.id}'),
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(0, _pressed ? 1 : 0, 0),
        width: 220,
        margin: const EdgeInsets.only(right: 12, bottom: 4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: _pressed
              ? []
              : [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
          border: Border.all(
            color: Colors.black.withOpacity(_pressed ? 0.04 : 0.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Thumbnail strip ──────────────────────────────
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
              child: SizedBox(
                height: 90,
                width: double.infinity,
                child: widget.item.thumbnail != null
                    ? CachedNetworkImage(
                        imageUrl: widget.item.thumbnail!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(color: Colors.grey.shade100),
                        errorWidget: (_, __, ___) =>
                            _BrsThumbFallback(item: widget.item),
                      )
                    : _BrsThumbFallback(item: widget.item),
              ),
            ),

            // ── Info ─────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(11, 9, 11, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kategori badge
                    if (widget.item.kategori != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.item.kategori!,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontPrimary,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: _green,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],

                    // Judul
                    Expanded(
                      child: Text(
                        widget.item.judul,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          height: 1.4,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Bottom row: tanggal + PDF icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 10,
                              color: AppColors.textHint,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(widget.item.tanggal),
                              style: AppTextStyles.labelSmall,
                            ),
                          ],
                        ),
                        if (widget.item.file != null)
                          const Icon(
                            Icons.picture_as_pdf_rounded,
                            size: 15,
                            color: Color(0xFFBF360C),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String raw) {
    try {
      final parts = raw.split('-');
      if (parts.length < 3) return raw;
      const months = [
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      final m = int.tryParse(parts[1]) ?? 0;
      return '${parts[2]} ${months[m]} ${parts[0]}';
    } catch (_) {
      return raw;
    }
  }
}

// ── Thumbnail Fallback ────────────────────────────────────────
class _BrsThumbFallback extends StatelessWidget {
  final BrsModel item;
  const _BrsThumbFallback({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Text(
              'BRS',
              style: TextStyle(
                fontFamily: AppTextStyles.fontPrimary,
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          Text(
            item.judul,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontPrimary,
              fontSize: 8,
              color: Colors.white,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shimmer ───────────────────────────────────────────────────
class _BrsCardShimmer extends StatelessWidget {
  const _BrsCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12, bottom: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // thumbnail placeholder
          Container(
            height: 90,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 8, width: 60, color: Colors.grey.shade300),
                const SizedBox(height: 7),
                Container(
                  height: 10,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 5),
                Container(height: 10, width: 140, color: Colors.grey.shade300),
                const SizedBox(height: 10),
                Container(height: 8, width: 80, color: Colors.grey.shade300),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
