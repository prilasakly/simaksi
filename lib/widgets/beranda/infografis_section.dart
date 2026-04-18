// lib/widgets/beranda/infografis_section.dart
// ============================================================
// SIMAKSI - Infografis Section
// Grid infografis dengan horizontal scroll
// ============================================================

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:simaksi/widgets/beranda/section_header.dart' show SectionHeader;
import '../../api/api_client.dart';
import '../../config/app_config.dart';
import '../../models/infografis_model.dart';
import '../../services/infografis_service.dart';
import '../../shared/theme/app_theme.dart';

class InfografisSection extends StatefulWidget {
  final VoidCallback? onLihatSemua;
  const InfografisSection({super.key, this.onLihatSemua});

  @override
  State<InfografisSection> createState() => _InfografisSectionState();
}

class _InfografisSectionState extends State<InfografisSection> {
  List<InfografisModel> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final result = await InfografisService().getInfografis();

    setState(() {
      if (result is ApiSuccess<List<InfografisModel>>) {
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
            title: 'Infografis',
            subtitle: 'Visualisasi data statistik menarik',
            accentColor: const Color(0xFF6A1B9A),
            onLihatSemua: widget.onLihatSemua,
          ),
          _isLoading ? _buildShimmer() : _buildContent(),
          const SizedBox(height: 16),
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
            'Belum ada infografis tersedia',
            style: AppTextStyles.bodyMedium,
          ),
        ),
      );
    }
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _items.length,
        itemBuilder: (context, index) => _InfografisCard(item: _items[index]),
      ),
    );
  }

  Widget _buildShimmer() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: 5,
        itemBuilder: (context, _) => const _InfografisCardShimmer(),
      ),
    );
  }
}

// ── Palette for placeholders ─────────────────────────────────
const _kPalette = [
  [Color(0xFF6A1B9A), Color(0xFF4A148C)],
  [Color(0xFF0277BD), Color(0xFF01579B)],
  [Color(0xFF2E7D32), Color(0xFF1B5E20)],
  [Color(0xFFBF360C), Color(0xFF870000)],
  [Color(0xFF00695C), Color(0xFF004D40)],
  [Color(0xFF1565C0), Color(0xFF0D47A1)],
];

// ── Infografis Card ──────────────────────────────────────────
class _InfografisCard extends StatelessWidget {
  final InfografisModel item;
  const _InfografisCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final paletteIndex = item.id.hashCode % _kPalette.length;
    final colors = _kPalette[paletteIndex.abs()];

    return GestureDetector(
      onTap: () {
        // TODO: Navigate to infografis detail / full screen view
      },
      child: Container(
        width: 155,
        margin: const EdgeInsets.only(right: 12, bottom: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colors[0].withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image or placeholder
              item.gambar != null
                  ? CachedNetworkImage(
                      imageUrl: item.gambar!,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) =>
                          _InfografisPlaceholder(colors: colors, item: item),
                    )
                  : _InfografisPlaceholder(colors: colors, item: item),

              // Bottom gradient
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.judul,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.3,
                        ),
                      ),
                      if (item.kategori != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.deskripsi!,
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontPrimary,
                            fontSize: 9,
                            color: Colors.white.withOpacity(0.75),
                          ),
                        ),
                      ],
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

class _InfografisPlaceholder extends StatelessWidget {
  final List<Color> colors;
  final InfografisModel item;

  const _InfografisPlaceholder({required this.colors, required this.item});

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
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.bar_chart_rounded,
                  size: 40,
                  color: Colors.white.withOpacity(0.4),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    item.judul,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.4,
                    ),
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

class _InfografisCardShimmer extends StatelessWidget {
  const _InfografisCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
