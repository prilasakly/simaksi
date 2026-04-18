// lib/features/brs/screen/widgets/brs_filter_sheet.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class BrsFilterSheet extends StatefulWidget {
  final String? initialMonth;
  final String? initialYear;
  final void Function(String? month, String? year) onApply;

  const BrsFilterSheet({
    super.key,
    this.initialMonth,
    this.initialYear,
    required this.onApply,
  });

  @override
  State<BrsFilterSheet> createState() => _BrsFilterSheetState();
}

class _BrsFilterSheetState extends State<BrsFilterSheet> {
  String? _tempMonth;
  String? _tempYear;

  @override
  void initState() {
    super.initState();
    _tempMonth = widget.initialMonth;
    _tempYear = widget.initialYear;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B5E20),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text('Filter BRS', style: AppTextStyles.headlineMedium),
            ],
          ),
          const SizedBox(height: 20),
          Text('Bulan', style: AppTextStyles.titleMedium),
          const SizedBox(height: 8),
          BrsMonthSelector(
            selected: _tempMonth,
            onChanged: (v) => setState(() => _tempMonth = v),
          ),
          const SizedBox(height: 20),
          Text('Tahun', style: AppTextStyles.titleMedium),
          const SizedBox(height: 8),
          BrsYearSelector(
            selected: _tempYear,
            onChanged: (v) => setState(() => _tempYear = v),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onApply(null, null);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFF1B5E20)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(color: Color(0xFF1B5E20)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onApply(_tempMonth, _tempYear);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B5E20),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Terapkan Filter'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Active Filter Chip ─────────────────────────────────────────
class BrsActiveFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const BrsActiveFilterChip({
    super.key,
    required this.label,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1B5E20).withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1B5E20).withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              size: 14,
              color: Color(0xFF1B5E20),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Month Selector ─────────────────────────────────────────────
class BrsMonthSelector extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onChanged;

  const BrsMonthSelector({super.key, this.selected, required this.onChanged});

  static const _months = [
    ('1', 'Jan'),
    ('2', 'Feb'),
    ('3', 'Mar'),
    ('4', 'Apr'),
    ('5', 'Mei'),
    ('6', 'Jun'),
    ('7', 'Jul'),
    ('8', 'Agu'),
    ('9', 'Sep'),
    ('10', 'Okt'),
    ('11', 'Nov'),
    ('12', 'Des'),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _months.map((m) {
        final isSelected = selected == m.$1;
        return GestureDetector(
          onTap: () => onChanged(isSelected ? null : m.$1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF1B5E20)
                  : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF1B5E20)
                    : Colors.transparent,
              ),
            ),
            child: Text(
              m.$2,
              style: TextStyle(
                fontFamily: AppTextStyles.fontPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Year Selector ──────────────────────────────────────────────
class BrsYearSelector extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onChanged;

  const BrsYearSelector({super.key, this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final years = List.generate(10, (i) => (currentYear - i).toString());

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: years.map((y) {
        final isSelected = selected == y;
        return GestureDetector(
          onTap: () => onChanged(isSelected ? null : y),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF1B5E20)
                  : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF1B5E20)
                    : Colors.transparent,
              ),
            ),
            child: Text(
              y,
              style: TextStyle(
                fontFamily: AppTextStyles.fontPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
