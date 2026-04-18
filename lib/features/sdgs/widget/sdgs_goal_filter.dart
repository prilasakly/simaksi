import 'package:flutter/material.dart';

class SdgsGoalFilter extends StatelessWidget {
  final int? selectedGoal;
  final ValueChanged<int?> onGoalChanged;

  const SdgsGoalFilter({
    super.key,
    required this.selectedGoal,
    required this.onGoalChanged,
  });

  // Tentukan tinggi konstan di sini agar seragam
  static const double _targetHeight = 44.0;

  static const List<_GoalChipData> _goals = [
    _GoalChipData(null, 'Semua', Color(0xFF003F88)),
    _GoalChipData(1, '1. Kemiskinan', Color(0xFFE5243B)),
    _GoalChipData(2, '2. Kelaparan', Color(0xFFDDA63A)),
    _GoalChipData(3, '3. Kesehatan', Color(0xFF4C9F38)),
    _GoalChipData(4, '4. Pendidikan', Color(0xFFC5192D)),
    _GoalChipData(5, '5. Gender', Color(0xFFFF3A21)),
    _GoalChipData(6, '6. Air Bersih', Color(0xFF26BDE2)),
    _GoalChipData(7, '7. Energi', Color(0xFFFCC30B)),
    _GoalChipData(8, '8. Pekerjaan', Color(0xFFA21942)),
    _GoalChipData(9, '9. Inovasi', Color(0xFFFC6F23)),
    _GoalChipData(10, '10. Kesenjangan', Color(0xFFDD1367)),
    _GoalChipData(11, '11. Kota', Color(0xFFFD9D24)),
    _GoalChipData(12, '12. Konsumsi', Color(0xFFBF8B2E)),
    _GoalChipData(13, '13. Iklim', Color(0xFF3F7E44)),
    _GoalChipData(14, '14. Laut', Color(0xFF0A97D9)),
    _GoalChipData(15, '15. Daratan', Color(0xFF56C02B)),
    _GoalChipData(16, '16. Perdamaian', Color(0xFF00689D)),
    _GoalChipData(17, '17. Kemitraan', Color(0xFF19486A)),
  ];

  @override
  Widget build(BuildContext context) {
    final allGoals = _goals.where((g) => g.goal != null).toList();

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          // 1. Chip "Semua"
          _GoalChip(
            data: _goals.first,
            isSelected: selectedGoal == null,
            onTap: () => onGoalChanged(null),
          ),
          const SizedBox(width: 8),

          // 2. Dropdown untuk Goal 1-17
          Expanded(
            child: Container(
              height: _targetHeight, // Tinggi dipaksa sama
              alignment: Alignment.center, // Centering vertikal
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: selectedGoal != null
                      ? _goals.firstWhere((e) => e.goal == selectedGoal).color
                      : Colors.grey,
                  width: 1.5,
                ),
                color: selectedGoal != null
                    ? _goals
                          .firstWhere((e) => e.goal == selectedGoal)
                          .color
                          .withOpacity(0.1)
                    : Colors.transparent,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int?>(
                  isExpanded: true,
                  isDense: true, // PENTING: Menghilangkan padding internal
                  hint: const Text(
                    "Pilih Goal Lainnya",
                    style: TextStyle(fontSize: 12),
                  ),
                  value: selectedGoal,
                  onChanged: onGoalChanged,
                  icon: const Icon(Icons.arrow_drop_down),
                  items: allGoals.map((g) {
                    return DropdownMenuItem<int?>(
                      value: g.goal,
                      child: Text(
                        g.label,
                        style: TextStyle(
                          fontSize: 12,
                          color: g.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalChip extends StatelessWidget {
  final _GoalChipData data;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalChip({
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: SdgsGoalFilter._targetHeight, // Tinggi dipaksa sama
        alignment: Alignment.center, // Centering vertikal
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? data.color : data.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: data.color, width: 1.5),
        ),
        child: Text(
          data.label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : data.color,
          ),
        ),
      ),
    );
  }
}

class _GoalChipData {
  final int? goal;
  final String label;
  final Color color;

  const _GoalChipData(this.goal, this.label, this.color);
}
