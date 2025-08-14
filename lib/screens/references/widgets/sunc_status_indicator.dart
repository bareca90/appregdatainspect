import 'package:appregdatainspect/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SyncStatusIndicator extends StatelessWidget {
  final bool isSynced;

  const SyncStatusIndicator({super.key, required this.isSynced});

  @override
  Widget build(BuildContext context) {
    if (isSynced) return const SizedBox.shrink();

    return Row(
      children: [
        Icon(Icons.sync_problem, size: 16, color: AppColors.primaryRed),
        const SizedBox(width: 8),
        Text(
          'Pendiente de sincronización',
          style: TextStyle(
            color: AppColors.primaryRed,
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
