import 'package:appregdatainspect/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ReferenceStatusIndicator extends StatelessWidget {
  final bool isComplete;

  const ReferenceStatusIndicator({super.key, required this.isComplete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isComplete
            // ignore: deprecated_member_use
            ? Colors.green.withOpacity(0.1)
            // ignore: deprecated_member_use
            : AppColors.primaryRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isComplete ? Colors.green : AppColors.primaryRed,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isComplete ? Icons.check : Icons.warning_amber_rounded,
            size: 14,
            color: isComplete ? Colors.green : AppColors.primaryRed,
          ),
          const SizedBox(width: 4),
          Text(
            isComplete ? 'Completo' : 'Pendiente',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isComplete ? Colors.green : AppColors.primaryRed,
            ),
          ),
        ],
      ),
    );
  }
}
