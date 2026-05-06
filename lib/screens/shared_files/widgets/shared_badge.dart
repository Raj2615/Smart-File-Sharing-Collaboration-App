import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

// Green "Shared" label badge shown on shared file cards
class SharedBadge extends StatelessWidget {
  final bool isShared;
  final bool showWhenFalse; // Whether to show "Personal" when not shared

  const SharedBadge({
    super.key,
    required this.isShared,
    this.showWhenFalse = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isShared && !showWhenFalse) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: isShared
            ? AppColors.secondary.withOpacity(0.15)
            : Colors.grey.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isShared
              ? AppColors.secondary.withOpacity(0.4)
              : Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isShared ? Icons.people : Icons.lock_outline,
            size: 12,
            color: isShared ? AppColors.secondary : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            isShared ? 'Shared' : 'Personal',
            style: TextStyle(
              fontSize: 11,
              color: isShared ? AppColors.secondary : Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}