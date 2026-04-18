// lib/features/beranda/widgets/sub_menu_grid.dart
// ============================================================
// SIMAKSI - Sub Menu Grid
// Grid menu navigasi utama di halaman beranda
// Tambah/edit menu di sini
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../core/router/app_router.dart';

// ── Menu Item Model ─────────────────────────────────────────
class _MenuItem {
  final String label;
  final IconData icon;
  final String route;
  final Color color;

  const _MenuItem({
    required this.label,
    required this.icon,
    required this.route,
    required this.color,
  });
}

// ── Menu Data (edit di sini) ────────────────────────────────
const List<_MenuItem> _menuItems = [
  _MenuItem(
    label: 'Publikasi',
    icon: Icons.menu_book_rounded,
    route: AppRoutes.publikasi,
    color: Color(0xFF283593),
  ),
  _MenuItem(
    label: 'BRS',
    icon: Icons.article_rounded,
    route: AppRoutes.brs,
    color: Color(0xFF2E7D32),
  ),
  _MenuItem(
    label: 'Infografis',
    icon: Icons.bar_chart_rounded,
    route: AppRoutes.infografis,
    color: Color(0xFF6A1B9A),
  ),
  _MenuItem(
    label: 'Media Sosial',
    icon: Icons.share_rounded,
    route: AppRoutes.mediaSosial,
    color: Color(0xFFAD1457),
  ),
  _MenuItem(
    label: 'Indikator',
    icon: Icons.trending_up_rounded,
    route: AppRoutes.indikator,
    color: Color(0xFF0277BD),
  ),
  _MenuItem(
    label: 'Metadata',
    icon: Icons.data_object_rounded,
    route: AppRoutes.metadata,
    color: Color(0xFF283593),
  ),
  _MenuItem(
    label: 'SKD',
    icon: Icons.star_rounded,
    route: AppRoutes.skd,
    color: Color(0xFF00695C),
  ),
  _MenuItem(
    label: 'Standar\nPelayanan',
    icon: Icons.verified_rounded,
    route: AppRoutes.standarPelayanan,
    color: Color(0xFF6A1B9A),
  ),
  _MenuItem(
    label: 'Berita',
    icon: Icons.newspaper_rounded,
    route: AppRoutes.berita,
    color: Color(0xFFBF360C),
  ),
  _MenuItem(
    label: 'SDGs',
    icon: Icons.public_rounded, // Menggunakan ikon dunia sebagai simbol SDGs
    route: AppRoutes.sdgs,
    color: Color(0xFF0277BD),
  ),
];

class SubMenuGrid extends StatelessWidget {
  const SubMenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 12),
            child: Text(
              'Layanan & Informasi',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 0.3,
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 12,
              crossAxisSpacing: 4,
              childAspectRatio: 0.75,
            ),
            itemCount: _menuItems.length,
            itemBuilder: (context, index) =>
                _MenuItemWidget(item: _menuItems[index]),
          ),
        ],
      ),
    );
  }
}

// ── Single Menu Item Widget ──────────────────────────────────
class _MenuItemWidget extends StatefulWidget {
  final _MenuItem item;
  const _MenuItemWidget({required this.item});

  @override
  State<_MenuItemWidget> createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<_MenuItemWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _tapController;
  late final Animation<double> _tapScale;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _tapScale = Tween<double>(
      begin: 1.0,
      end: 0.88,
    ).animate(CurvedAnimation(parent: _tapController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _tapController.forward(),
      onTapUp: (_) {
        _tapController.reverse();
        context.push(widget.item.route);
      },
      onTapCancel: () => _tapController.reverse(),
      child: ScaleTransition(
        scale: _tapScale,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon container
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: widget.item.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: widget.item.color.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(widget.item.icon, color: widget.item.color, size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              widget.item.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontFamily: AppTextStyles.fontPrimary,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
