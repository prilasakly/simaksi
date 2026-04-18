import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:simaksi/features/publikasi/model/publikasi_model.dart';

import '../../../../core/theme/app_theme.dart';

class DetailHeroHeader extends StatelessWidget {
  final PublikasiModel item;
  const DetailHeroHeader({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Hero(
                tag: 'cover_${item.id}',
                child: Container(
                  width: 110,
                  height: 155,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: item.cover != null
                        ? CachedNetworkImage(
                            imageUrl: item.cover!,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) =>
                                DetailCoverFallback(item: item),
                          )
                        : DetailCoverFallback(item: item),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.tahun.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.tahun,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontPrimary,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                    Text(
                      item.judul,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.4,
                      ),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.issn != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        'ISSN: ${item.issn}',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontPrimary,
                          fontSize: 10,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailCoverFallback extends StatelessWidget {
  final PublikasiModel item;
  const DetailCoverFallback({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Text(
              'BPS',
              style: TextStyle(
                fontFamily: AppTextStyles.fontPrimary,
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          const Spacer(),
          Text(
            item.judul,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontPrimary,
              fontSize: 9,
              color: Colors.white,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
