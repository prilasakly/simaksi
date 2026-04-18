// lib/features/brs/screen/widgets/brs_abstrak_section.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/clean_html.dart';

class BrsAbstrakSection extends StatefulWidget {
  final String? abstrak;
  const BrsAbstrakSection({super.key, this.abstrak});

  @override
  State<BrsAbstrakSection> createState() => _BrsAbstrakSectionState();
}

class _BrsAbstrakSectionState extends State<BrsAbstrakSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final text = widget.abstrak?.cleanHtml() ?? '';
    if (text.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(title: 'Ringkasan'),
          const SizedBox(height: 10),
          // Highlight box — beda dari publikasi yang plain text
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1B5E20).withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF1B5E20).withOpacity(0.15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  maxLines: _expanded ? null : 6,
                  overflow: _expanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontSize: 13,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: Text(
                    _expanded ? 'Tampilkan lebih sedikit' : 'Baca selengkapnya',
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1B5E20),
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

// ── Infographics Section ──────────────────────────────────────
class BrsInfographicsSection extends StatelessWidget {
  final List infographics;
  const BrsInfographicsSection({super.key, required this.infographics});

  @override
  Widget build(BuildContext context) {
    if (infographics.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(title: 'Infografis'),
          const SizedBox(height: 10),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: infographics.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final item = infographics[i];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: item.image != null
                      ? Image.network(
                          item.image!,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _InfographicPlaceholder(),
                        )
                      : _InfographicPlaceholder(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _InfographicPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.image_outlined, size: 32, color: Colors.grey),
    );
  }
}

// ── Related BRS Section ───────────────────────────────────────
class BrsRelatedSection extends StatelessWidget {
  final List related;
  final void Function(String id) onTap;

  const BrsRelatedSection({
    super.key,
    required this.related,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (related.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(title: 'BRS Terkait'),
          const SizedBox(height: 10),
          ...related.map(
            (r) => GestureDetector(
              onTap: () => onTap(r.id),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black.withOpacity(0.06)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: const Color(0xFF1B5E20).withOpacity(0.1),
                      ),
                      child: const Icon(
                        Icons.article_rounded,
                        size: 18,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.judul,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.titleMedium.copyWith(
                              fontSize: 12,
                            ),
                          ),
                          if (r.tanggal != null)
                            Text(
                              r.tanggal!.split('-').first,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: const Color(0xFF1B5E20),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textHint,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Label ─────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFF1B5E20),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(title, style: AppTextStyles.titleLarge),
      ],
    );
  }
}
