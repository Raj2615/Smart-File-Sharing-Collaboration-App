import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

// Horizontal scrollable filter chip row
// Used for file type and visibility filters
class FilterChipRow extends StatelessWidget {
  final List<String> options;
  final String? selected;       // null = "All" selected
  final void Function(String?) onSelect;
  final Color Function(String)? colorForOption;
  final String allLabel;

  const FilterChipRow({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelect,
    this.colorForOption,
    this.allLabel = 'All',
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // "All" chip first
          _buildChip(
            label: allLabel,
            isSelected: selected == null,
            color: AppColors.primary,
            onTap: () => onSelect(null),
          ),
          const SizedBox(width: 8),

          // One chip per option
          ...options.map((opt) {
            final color = colorForOption != null
                ? colorForOption!(opt)
                : AppColors.primary;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildChip(
                label: opt,
                isSelected: selected == opt,
                color: color,
                onTap: () => onSelect(selected == opt ? null : opt),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? color : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}