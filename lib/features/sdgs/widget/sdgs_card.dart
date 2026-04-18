// lib/widgets/sdgs/sdgs_card.dart
// ============================================================
// SIMAKSI - SDGs Card Widget
// Card dengan slide-down detail ketika di-tap
// ============================================================

import 'package:flutter/material.dart';
import 'package:simaksi/features/sdgs/model/sdgs_model.dart' show SdgsModel;
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/url_helper.dart' show UrlHelper;

class SdgsCard extends StatefulWidget {
  final SdgsModel item;

  const SdgsCard({super.key, required this.item});

  @override
  State<SdgsCard> createState() => _SdgsCardState();
}

class _SdgsCardState extends State<SdgsCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Color get _goalColor {
    final colors = [
      const Color(0xFFE5243B), // 1 - No Poverty
      const Color(0xFFDDA63A), // 2 - Zero Hunger
      const Color(0xFF4C9F38), // 3 - Good Health
      const Color(0xFFC5192D), // 4 - Quality Education
      const Color(0xFFFF3A21), // 5 - Gender Equality
      const Color(0xFF26BDE2), // 6 - Clean Water
      const Color(0xFFFCC30B), // 7 - Affordable Energy
      const Color(0xFFA21942), // 8 - Decent Work
      const Color(0xFFFC6F23), // 9 - Industry & Innovation
      const Color(0xFFDD1367), // 10 - Reduced Inequalities
      const Color(0xFFFD9D24), // 11 - Sustainable Cities
      const Color(0xFFBF8B2E), // 12 - Responsible Consumption
      const Color(0xFF3F7E44), // 13 - Climate Action
      const Color(0xFF0A97D9), // 14 - Life Below Water
      const Color(0xFF56C02B), // 15 - Life on Land
      const Color(0xFF00689D), // 16 - Peace & Justice
      const Color(0xFF19486A), // 17 - Partnerships
    ];
    final idx = widget.item.goalNumber - 1;
    if (idx < 0 || idx >= colors.length) return AppColors.primary;
    return colors[idx];
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header (always visible) ──────────────────────
          InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(12),
              bottom: _isExpanded
                  ? Radius.zero
                  : const Radius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Goal badge
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _goalColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${item.goalNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SDGs ID & Sub name
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: _goalColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                item.sdgsId,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: _goalColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                item.subName,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Title
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Unit
                        Row(
                          children: [
                            const Icon(
                              Icons.straighten_rounded,
                              size: 13,
                              color: AppColors.textHint,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.unit,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Chevron
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 280),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: _goalColor,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Expandable Detail ────────────────────────────
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              children: [
                Divider(
                  height: 1,
                  color: _goalColor.withOpacity(0.2),
                  indent: 14,
                  endIndent: 14,
                ),
                _DetailSection(item: item, goalColor: _goalColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Detail Section ────────────────────────────────────────
class _DetailSection extends StatelessWidget {
  final SdgsModel item;
  final Color goalColor;

  const _DetailSection({required this.item, required this.goalColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Goal name
          _InfoRow(
            icon: Icons.flag_rounded,
            label: 'Tujuan SDGs',
            value: item.sdgsGoalName,
            color: goalColor,
          ),
          const SizedBox(height: 10),

          // Sub kategori
          _InfoRow(
            icon: Icons.category_rounded,
            label: 'Sub Kategori',
            value: item.subName,
            color: goalColor,
          ),
          const SizedBox(height: 10),

          // Unit & Graph
          Row(
            children: [
              Expanded(
                child: _InfoRow(
                  icon: Icons.straighten_rounded,
                  label: 'Satuan',
                  value: item.unit,
                  color: goalColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InfoRow(
                  icon: Icons.bar_chart_rounded,
                  label: 'Grafik',
                  value: item.graphName,
                  color: goalColor,
                ),
              ),
            ],
          ),

          // Definisi (jika ada)
          if (item.def.isNotEmpty) ...[
            const SizedBox(height: 10),
            _InfoRow(
              icon: Icons.info_outline_rounded,
              label: 'Definisi',
              value: item.def,
              color: goalColor,
            ),
          ],

          // Notes (jika ada)
          if (item.cleanNotes.isNotEmpty) ...[
            const SizedBox(height: 10),
            _InfoRow(
              icon: Icons.notes_rounded,
              label: 'Catatan',
              value: item.cleanNotes,
              color: goalColor,
            ),
          ],

          // Meta links
          if (item.metaActivity != null || item.metaVar != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.link_rounded, size: 13, color: goalColor),
                const SizedBox(width: 4),
                Text(
                  'Metadata',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: goalColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (item.metaActivity != null)
              _MetaChip(
                label: 'Kegiatan',
                url: item.metaActivity!,
                color: goalColor,
              ),
            if (item.metaVar != null) ...[
              const SizedBox(height: 4),
              _MetaChip(
                label: 'Variabel',
                url: item.metaVar!,
                color: goalColor,
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.06),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;
  final String url;
  final Color color;

  const _MetaChip({
    required this.label,
    required this.url,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Bungkus Container dengan InkWell agar bisa diklik
    return InkWell(
      onTap: () => UrlHelper.launch(url, context: context),
      borderRadius: BorderRadius.circular(
        6,
      ), // Penting: disamakan dengan radius Container
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(Icons.open_in_new_rounded, size: 12, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                url,
                style: const TextStyle(fontSize: 10, color: AppColors.textHint),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
