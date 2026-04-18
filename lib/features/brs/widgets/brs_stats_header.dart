// lib/features/brs/screen/widgets/brs_stats_header.dart
import 'package:flutter/material.dart';
import '../../../../core/models/pagination_model.dart';
import '../../../../core/theme/app_theme.dart';

class BrsStatsHeader extends StatelessWidget {
  final BpsPagination? pagination;
  final int localCount;
  final bool hasFilter;

  const BrsStatsHeader({
    super.key,
    this.pagination,
    required this.localCount,
    this.hasFilter = false,
  });

  @override
  Widget build(BuildContext context) {
    final total = pagination?.total ?? localCount;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 14,
            decoration: BoxDecoration(
              color: const Color(0xFF1B5E20),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$total BRS ditemukan',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          if (hasFilter) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF1B5E20).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Terfilter',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontPrimary,
                  fontSize: 10,
                  color: Color(0xFF1B5E20),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
