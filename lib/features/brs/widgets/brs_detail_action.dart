// lib/features/brs/screen/widgets/brs_detail_actions.dart
import 'package:flutter/material.dart';
import 'package:simaksi/core/widgets/download_file.dart';
import 'package:simaksi/features/brs/model/brs_model.dart';
import 'package:simaksi/features/publikasi/widgets/pdf_reader_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';

class BrsDetailActions extends StatelessWidget {
  final BrsModel item;
  const BrsDetailActions({super.key, required this.item});

  static const _green = Color(0xFF1B5E20);

  @override
  Widget build(BuildContext context) {
    if (item.file == null && item.slide == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (item.file != null)
            Expanded(
              child: _ActionBtn(
                icon: Icons.picture_as_pdf_rounded,
                label: 'Baca PDF',
                color: _green,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        PdfReaderScreen(pdfUrl: item.file!, title: item.judul),
                  ),
                ),
              ),
            ),
          if (item.file != null && item.slide != null)
            const SizedBox(width: 12),
          if (item.slide != null)
            Expanded(
              child: _ActionBtn(
                icon: Icons.slideshow_rounded,
                label: 'Slide',
                color: AppColors.accent,
                labelColor: AppColors.primaryDark,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading...')),
                  );
                  
                  downloadFile(
                    url: item.slide!,
                    fileName: safeFileName('${item.judul}_slide'),
                    extension: 'pptx',
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color? labelColor;
  final VoidCallback onTap;

  const _ActionBtn({
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
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 17, color: labelColor ?? Colors.white),
              const SizedBox(width: 7),
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
