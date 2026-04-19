// lib/features/infografis/widgets/infografis_search_bar.dart
// ============================================================
// SIMAKSI - Infografis Search Bar
// Search bar dengan debounce dan tombol clear.
// Dipasang di bawah AppBar (di dalam body / Column).
// ============================================================

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class InfografisSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final String hintText;

  const InfografisSearchBar({
    super.key,
    required this.onChanged,
    this.onClear,
    this.hintText = 'Cari infografis...',
  });

  @override
  State<InfografisSearchBar> createState() => _InfografisSearchBarState();
}

class _InfografisSearchBarState extends State<InfografisSearchBar> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _clear() {
    _ctrl.clear();
    widget.onChanged('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: TextField(
        controller: _ctrl,
        onChanged: widget.onChanged,
        textInputAction: TextInputAction.search,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.55),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.white.withOpacity(0.65),
            size: 20,
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _ctrl,
            builder: (_, value, __) => value.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: Colors.white.withOpacity(0.65),
                      size: 18,
                    ),
                    onPressed: _clear,
                    splashRadius: 18,
                  )
                : const SizedBox.shrink(),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.15),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 11,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.35),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
