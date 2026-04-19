// lib/features/infografis/widgets/infografis_empty_state.dart
// ============================================================
// SIMAKSI - Infografis Empty & Error State
// Widget untuk kondisi kosong (no results) dan error.
// ============================================================

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

// ── Empty State ───────────────────────────────────────────────
class InfografisEmptyState extends StatelessWidget {
  final String keyword;
  final VoidCallback? onReset;

  const InfografisEmptyState({
    super.key,
    required this.keyword,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final hasKeyword = keyword.isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2F7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.image_search_rounded,
                size: 40,
                color: AppColors.textHint,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              hasKeyword
                  ? 'Infografis tidak ditemukan'
                  : 'Belum ada infografis',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              hasKeyword
                  ? 'Coba ubah kata kunci pencarian Anda'
                  : 'Infografis akan muncul di sini ketika tersedia',
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 13,
                color: AppColors.textHint,
              ),
              textAlign: TextAlign.center,
            ),
            if (hasKeyword && onReset != null) ...[
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: onReset,
                icon: const Icon(Icons.clear_rounded, size: 16),
                label: const Text('Hapus pencarian'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Error State ───────────────────────────────────────────────
class InfografisErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const InfografisErrorState({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFFCE4EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 38,
                color: Color(0xFFC62828),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Gagal memuat data',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 13,
                color: AppColors.textHint,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 11,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
