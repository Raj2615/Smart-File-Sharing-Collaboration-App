import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

// Reusable file type picker widget
// Shows available types as selectable chips
class TypeSelector extends StatelessWidget {
  final List<String> types;
  final String selectedType;
  final ValueChanged<String>? onTypeSelected;
  final bool enabled;

  const TypeSelector({
    super.key,
    required this.types,
    required this.selectedType,
    this.onTypeSelected,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: types.map((type) {
        final isSelected = selectedType == type;
        final color = AppColors.forFileType(type);

        return FilterChip(
          label: Text(type),
          selected: isSelected,
          onSelected: enabled
              ? (_) => onTypeSelected?.call(type)
              : null,
          selectedColor: color.withOpacity(0.2),
          checkmarkColor: color,
          labelStyle: TextStyle(
            color: isSelected ? color : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }
}
