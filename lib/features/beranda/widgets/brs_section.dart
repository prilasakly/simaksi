// lib/widgets/beranda/brs_section.dart
// ============================================================
// SIMAKSI - BRS Section
// Berita Resmi Statistik dengan tampilan list card horizontal
// ============================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:simaksi/core/api/api_client.dart' show ApiSuccess;
import 'package:simaksi/features/brs/model/brs_model.dart' show BrsModel;
import 'package:simaksi/features/brs/service/brs_service.dart' show BrsService;
import 'package:simaksi/core/theme/app_theme.dart' show AppColors, AppTextStyles;
import 'package:simaksi/core/widgets/section_header.dart';


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
            onLihatSemua: widget.onLihatSemua,
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
      height: 180,
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
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: 4,
        itemBuilder: (context, _) => const _BrsCardShimmer(),
      ),
    );
  }
}

// ── BRS Card ─────────────────────────────────────────────────
class _BrsCard extends StatelessWidget {
  final BrsModel item;
  const _BrsCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to BRS detail
      },
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 12, bottom: 4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subject tag
              if (item.kategori != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.kategori!,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
              const SizedBox(height: 8),

              // Title
              Expanded(
                child: Text(
                  item.judul,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1.45,
                  ),
                ),
              ),

              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 8),

              // Bottom row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 11,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(width: 4),
                      Text(item.tanggal, style: AppTextStyles.labelSmall),
                    ],
                  ),
                  if (item.file != null)
                    const Icon(
                      Icons.picture_as_pdf_rounded,
                      size: 16,
                      color: Color(0xFFBF360C),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrsCardShimmer extends StatelessWidget {
  const _BrsCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}
