// lib/shared/widgets/section_header.dart
// ============================================================
// SIMAKSI - Section Header Widget
// Header reusable untuk setiap section di beranda
// ============================================================

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String lihatSemuaLabel;
  final VoidCallback? onLihatSemua;
  final Color? accentColor;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.lihatSemuaLabel = 'Lihat Semua',
    this.onLihatSemua,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.primary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Left accent bar
          Container(
            width: 4,
            height: 26,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                  ),
              ],
            ),
          ),
          if (onLihatSemua != null)
            GestureDetector(
              onTap: onLihatSemua,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      lihatSemuaLabel,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Icon(Icons.arrow_forward_rounded, size: 13, color: color),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── App Bar Widget ───────────────────────────────────────────
// lib/shared/widgets/app_bar_widget.dart placeholder
