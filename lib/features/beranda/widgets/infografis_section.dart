// lib/features/beranda/widgets/infografis_section.dart
// ============================================================
// SIMAKSI - Infografis Section (Beranda)
// Widget section horizontal scroll untuk halaman beranda.
// Menampilkan preview 8 infografis terbaru.
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simaksi/core/router/app_router.dart';

import '../../../core/api/api_client.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/section_header.dart';
import '../../infografis/model/infografis_model.dart';
import '../../infografis/service/infografis_service.dart';
import '../../infografis/widgets/infografis_card.dart';
import '../../infografis/widgets/infografis_detail_sheet.dart';

class InfografisSection extends StatefulWidget {
  final VoidCallback? onLihatSemua;

  const InfografisSection({super.key, this.onLihatSemua});

  @override
  State<InfografisSection> createState() => _InfografisSectionState();
}

class _InfografisSectionState extends State<InfografisSection> {
  List<InfografisModel> _items = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await InfografisService().getInfografisForHome(limit: 8);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (result is ApiSuccess<List<InfografisModel>>) {
        _items = result.data;
      } else if (result is ApiError<List<InfografisModel>>) {
        _error = result.message;
      }
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
            subtitle: 'Visualisasi data statistik',
            accentColor: const Color(0xFF4A148C),
            onLihatSemua:
                widget.onLihatSemua ?? () => context.push(AppRoutes.infografis),
          ),
          _isLoading
              ? _buildShimmer()
              : _error != null
              ? _buildErrorTile()
              : _buildContent(),
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
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _items.length,
        itemBuilder: (context, index) => SizedBox(
          width: 150,
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InfografisCard(
              item: _items[index],
              size: InfografisCardSize.small,
              onTap: () =>
                  InfografisDetailSheet.show(context, item: _items[index]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: 5,
        itemBuilder: (_, __) => const SizedBox(
          width: 150,
          child: Padding(
            padding: EdgeInsets.only(right: 12),
            child: InfografisCardShimmer(size: InfografisCardSize.small),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorTile() {
    return SizedBox(
      height: 80,
      child: Center(
        child: TextButton.icon(
          onPressed: _loadData,
          icon: const Icon(Icons.refresh_rounded, size: 16),
          label: const Text('Gagal memuat, ketuk untuk coba lagi'),
          style: TextButton.styleFrom(foregroundColor: AppColors.primary),
        ),
      ),
    );
  }
}
