import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:simaksi/features/publikasi/model/publikasi_model.dart';
import 'package:simaksi/features/publikasi/widgets/pdf_reader_screen.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/clean_html.dart';

class DetailContent extends StatelessWidget {
  final PublikasiModel item;
  const DetailContent({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final abstrak = item.abstrak?.cleanHtml() ?? '';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Meta Badges ──────────────────────────────────
          Row(
            children: [
              if (item.rlDate != null)
                MetaBadge(
                  icon: Icons.calendar_today_rounded,
                  label: _formatDate(item.rlDate!),
                ),
              if (item.rlDate != null && item.size != null)
                const SizedBox(width: 8),
              if (item.size != null)
                MetaBadge(
                  icon: Icons.insert_drive_file_rounded,
                  label: item.size!,
                ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Action Buttons ───────────────────────────────
          if (item.pdf != null) ...[
            Row(
              children: [
                Expanded(
                  child: DetailActionButton(
                    icon: Icons.menu_book_rounded,
                    label: 'Baca Online',
                    color: AppColors.primary,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PdfReaderScreen(
                          pdfUrl: item.pdf!,
                          title: item.judul,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DetailActionButton(
                    icon: Icons.download_rounded,
                    label: 'Unduh PDF',
                    color: AppColors.accent,
                    labelColor: AppColors.primaryDark,
                    onTap: () => _downloadPdf(context, item.pdf!, item.judul),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],

          // ── Abstrak ──────────────────────────────────────
          if (abstrak.isNotEmpty) ...[
            const SectionDivider(title: 'Abstrak'),
            const SizedBox(height: 12),
            ExpandableText(text: abstrak),
            const SizedBox(height: 24),
          ],

          // ── Publikasi Terkait ────────────────────────────
          if (item.related.isNotEmpty) ...[
            const SectionDivider(title: 'Publikasi Terkait'),
            const SizedBox(height: 12),
            ...item.related.map((r) => RelatedItem(related: r)),
          ],

          const SizedBox(height: 40),
        ],
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
      final month = int.tryParse(parts[1]) ?? 0;
      return '${parts[2]} ${months[month]} ${parts[0]}';
    } catch (_) {
      return raw;
    }
  }

  void _downloadPdf(BuildContext context, String url, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mengunduh "$title"...'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfReaderScreen(pdfUrl: url, title: title),
      ),
    );
  }
}

// ── Meta Badge ────────────────────────────────────────────────
class MetaBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const MetaBadge({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.textSecondary),
          const SizedBox(width: 5),
          Text(label, style: AppTextStyles.labelSmall),
        ],
      ),
    );
  }
}

// ── Action Button ─────────────────────────────────────────────
class DetailActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color? labelColor;
  final VoidCallback onTap;

  const DetailActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: labelColor ?? Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: labelColor ?? Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Section Divider ───────────────────────────────────────────
class SectionDivider extends StatelessWidget {
  final String title;
  const SectionDivider({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(title, style: AppTextStyles.titleLarge),
      ],
    );
  }
}

// ── Expandable Text ───────────────────────────────────────────
class ExpandableText extends StatefulWidget {
  final String text;
  const ExpandableText({super.key, required this.text});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: _expanded ? null : 5,
          overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: AppTextStyles.bodyLarge.copyWith(fontSize: 14, height: 1.7),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Text(
            _expanded ? 'Tampilkan lebih sedikit' : 'Baca selengkapnya',
            style: const TextStyle(
              fontFamily: AppTextStyles.fontPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Related Item ──────────────────────────────────────────────
class RelatedItem extends StatelessWidget {
  final RelatedPublikasi related;
  const RelatedItem({super.key, required this.related});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              width: 40,
              height: 56,
              child: related.cover != null
                  ? CachedNetworkImage(
                      imageUrl: related.cover!,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => _RelatedCoverFallback(),
                    )
                  : _RelatedCoverFallback(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  related.judul,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMedium.copyWith(fontSize: 12),
                ),
                if (related.rlDate != null)
                  Text(
                    related.rlDate!.split('-').first,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textHint,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _RelatedCoverFallback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryLight,
      child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 20),
    );
  }
}
