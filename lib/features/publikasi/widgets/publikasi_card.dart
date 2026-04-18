import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:simaksi/features/publikasi/model/publikasi_model.dart';

import '../../../../core/theme/app_theme.dart';

class PublikasiCard extends StatefulWidget {
  final PublikasiModel item;
  final VoidCallback onTap;

  const PublikasiCard({super.key, required this.item, required this.onTap});

  @override
  State<PublikasiCard> createState() => _PublikasiCardState();
}

class _PublikasiCardState extends State<PublikasiCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        transform: Matrix4.translationValues(0, _pressed ? 2 : 0, 0),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: _pressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
          border: Border.all(
            color: Colors.black.withOpacity(_pressed ? 0.04 : 0.07),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize
              .min, // Memastikan column tidak mengambil ruang berlebih
          children: [
            // Area Gambar menggunakan Expanded agar fleksibel
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: widget.item.cover != null
                    ? CachedNetworkImage(
                        imageUrl: widget.item.cover!,
                        fit: BoxFit.cover,
                        width: double.infinity, // Paksa lebar penuh
                        errorWidget: (_, __, ___) =>
                            PublikasiCoverPlaceholder(item: widget.item),
                        placeholder: (_, __) =>
                            Container(color: Colors.grey.shade100),
                      )
                    : PublikasiCoverPlaceholder(item: widget.item),
              ),
            ),
            // Area Teks dengan tinggi yang lebih terukur
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.judul,
                    maxLines: 2, // Disarankan 2 baris agar aman di layar kecil
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                  if (widget.item.tahun.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.item.tahun,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PublikasiCoverPlaceholder extends StatelessWidget {
  final PublikasiModel item;
  const PublikasiCoverPlaceholder({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1565C0), Color(0xFF003F88)],
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Text(
              'BPS',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          const Spacer(),
          Text(
            item.judul,
            maxLines: 3, // Jangan terlalu banyak agar tidak overflow ke atas
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          if (item.tahun.isNotEmpty)
            Text(
              item.tahun,
              style: const TextStyle(fontSize: 8, color: Colors.white70),
            ),
        ],
      ),
    );
  }
}

class PublikasiCardShimmer extends StatelessWidget {
  const PublikasiCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 8,
                  color: Colors.grey.shade200,
                  width: double.infinity,
                ),
                const SizedBox(height: 4),
                Container(height: 8, color: Colors.grey.shade200, width: 60),
                const SizedBox(height: 4),
                Container(height: 8, color: Colors.grey.shade200, width: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
