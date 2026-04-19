// lib/features/infografis/widgets/infografis_stats_header.dart
// ============================================================
// SIMAKSI - Infografis Stats Header
// Menampilkan info total infografis & halaman aktif.
// ============================================================

import 'package:flutter/material.dart';

import '../../../core/models/pagination_model.dart';
import '../../../core/theme/app_theme.dart';

class InfografisStatsHeader extends StatelessWidget {
  final BpsPagination? pagination;
  final int currentPage;
  final String keyword;

  const InfografisStatsHeader({
    super.key,
    required this.pagination,
    required this.currentPage,
    required this.keyword,
  });

  @override
  Widget build(BuildContext context) {
    final total = pagination?.total ?? 0;
    final pages = pagination?.pages ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppColors.surface,
      child: Row(
        children: [
          // Total
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: AppTextStyles.fontPrimary,
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
                children: [
                  TextSpan(
                    text: '$total ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const TextSpan(text: 'infografis'),
                  if (keyword.isNotEmpty) ...[
                    const TextSpan(text: ' untuk '),
                    TextSpan(
                      text: '"$keyword"',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Halaman info
          if (pages > 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Hal $currentPage / $pages',
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
