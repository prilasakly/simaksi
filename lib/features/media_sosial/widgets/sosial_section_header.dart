// lib/features/media_sosial/widgets/sosial_section_header.dart
// ============================================================
// SIMAKSI - Section Header Widget untuk Media Sosial Screen
// ============================================================

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class SosialSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const SosialSectionHeader({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: AppTextStyles.titleLarge.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
