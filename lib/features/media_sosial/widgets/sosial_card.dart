// lib/features/media_sosial/widgets/sosial_card.dart
// ============================================================
// SIMAKSI - Sosial Media Card Widget
// Card item yang bisa di-tap untuk membuka link
// ============================================================

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/url_helper.dart';
import '../model/media_sosial_model.dart';

class SosialCard extends StatefulWidget {
  final MediaSosialItem item;
  final int index;

  const SosialCard({
    super.key,
    required this.item,
    required this.index,
  });

  @override
  State<SosialCard> createState() => _SosialCardState();
}

class _SosialCardState extends State<SosialCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(_) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: () => UrlHelper.launch(widget.item.url, context: context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isPressed
                  ? widget.item.iconColor.withOpacity(0.3)
                  : AppColors.surfaceVariant,
              width: _isPressed ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow.withOpacity(_isPressed ? 0.06 : 0.08),
                blurRadius: _isPressed ? 4 : 10,
                offset: Offset(0, _isPressed ? 2 : 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // ── Icon Container ──────────────────────────
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: widget.item.color,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    widget.item.icon,
                    color: widget.item.iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),

                // ── Label & Handle ──────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.label,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.item.handle,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // ── Arrow ───────────────────────────────────
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.textHint,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}